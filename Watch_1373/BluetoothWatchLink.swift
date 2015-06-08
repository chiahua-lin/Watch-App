//
//  BluetoothWatchLink.swift
//  Watch_1373
//
//  Created by William LaFrance on 2/25/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import CoreBluetooth

let kSPPServiceUUID                       = CBUUID(string: "DD84F19E-C9D1-0AB7-A443-E6C39711E29A")
let kSPPCommandPortCharacteristicUUID     = CBUUID(string: "CC091D36-9541-8625-4E56-3CEA75D0D693")
let kSPPResponsePortCharacteristicUUID    = CBUUID(string: "CC091D36-9541-8625-4E56-3CEA75D0D694")
let kSPPSideBandCharacteristicUUID        = CBUUID(string: "CC091D36-9541-8625-4E56-3CEA75D0D698")

typealias PeripheralFilter = (CBPeripheral) -> BooleanType

enum BluetoothWatchLinkSingleton {
    static let singleton = BluetoothWatchLink()
}

struct FirmwareVersion {
    var major: UInt8
    var minor: UInt8
    var build: UInt8
}

enum FirmwareUpdateProcess : Printable
{
    case Uninitialized
    
    case WaitingForWatchResponse
    
    case WritingFirmware(range: NSRange)
    
    case Complete
    
    case Failed
    
    var description: String {
        get {
            switch self {
                case .Uninitialized:                return "Unitialized"
                case .WaitingForWatchResponse:      return "Waiting for Watch Response"
                case let .WritingFirmware(range):   return "Writing Firmware \(range)"
                case .Complete:                     return "Update Complete"
                case .Failed:                       return "Update Failed"
            }
        }
    }
}

class BluetoothWatchLink: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    //MARK: Singleton Accessor

    class func sharedInstance() -> BluetoothWatchLink {
        return BluetoothWatchLinkSingleton.singleton
    }

    //MARK: Instance variables

    private let central = CBCentralManager(delegate: nil, queue: dispatch_queue_create("com.watch1373.centralQueue", DISPATCH_QUEUE_SERIAL))

    private let peripheralFilter: PeripheralFilter
    
    private var peripheralArray:[CBPeripheral] = []

    private var messageHandlers: [(LSRPackableStruct) -> Void] = []
    
    private var connectionHandlers: [(([CBPeripheral]) -> Void, handlerID: String)] = []

    var firmwareVersion: FirmwareVersion?
    
    //MARK: State Machine

    private var state: BluetoothStateMachine {
        didSet(oldState) {
            LSRLog(.BluetoothStateMachine, .Info, "State transition: \(oldState.stateName) -> \(self.state.stateName)")

            switch oldState {
                case let .Discovering:
                    central.stopScan()

                default: break
            }

            switch state {
                case .Uninitialized: break

                case .Discovering:
                    central.scanForPeripheralsWithServices([kSPPServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])

                case let .Connecting(peripheral):
                    peripheral.delegate = self
                    central.connectPeripheral(peripheral, options: [:])

                case let .InterrogatingServices(peripheral):
                    peripheral.discoverServices([kSPPServiceUUID])

                case let .InterrogatingCharacteristics(peripheral, sppService):
                    let characteristics = [kSPPCommandPortCharacteristicUUID, kSPPResponsePortCharacteristicUUID, kSPPSideBandCharacteristicUUID]
                    peripheral.discoverCharacteristics(characteristics, forService: sppService)

                case let .Connected(peripheral, _, commandPortCharacteristic, responsePortCharacteristic, sideBandCharacteristic):
                    peripheral.setNotifyValue(true, forCharacteristic: responsePortCharacteristic)
            }
        }
    }

    //MARK: Initialization

    init(peripheralFilter _peripheralFilter: PeripheralFilter = { let name: String? = $0.name; return (name ?? "") == NSUserDefaults.standardUserDefaults().stringForKey("watch_name") }) {
        LSRLog(.BluetoothWatchLink, .Trace, "Setting up Bluetooth State Machine (BSM)")
        state = .Uninitialized

        peripheralFilter = _peripheralFilter

        super.init()

        central.delegate = self

        centralManagerDidUpdateState(central)
        
        registerMessageHandler(WatchFirmwareVersionMsg_t.self) {
            self.firmwareVersion = FirmwareVersion(major: ($0).major, minor: ($0).minor, build: ($0).build)
            NSNotificationCenter.defaultCenter().postNotificationName("watchDidUpdate", object: self)
        }
        
        registerMessageHandler(RequestNextFirmwareBlockMsg_t.self) {
            println("[BWL] Firmware update data request of size: \($0)")
            self.continueFirmwareUpdate(($0).blockSize)
        }
    }

    //MARK: Sending messages

    var canSendMessage: Bool {
        switch state {
            case .Connected: return true
            default: return false
        }
    }

    func sendMessage<T : LSRPackableStruct>(message: T, label: String = "Outgoing packet", type: CBCharacteristicWriteType = .WithResponse) {
        switch state {
            case let .Connected(peripheral, _, commandPortCharacteristic, _, _):
                let data = LSRPackableStructUtilities.pack(message)
                BluetoothPacketTrace.trace(data, direction: .CentralToPeripheral, label: label)
                peripheral.writeValue(data, forCharacteristic: commandPortCharacteristic, type: type)

            default:
                assertionFailure("Attempted to send packet when not connected. Check canSendMessage first!")
        }
    }

    //MARK: Receiving messages

    private func handlePacket(data: NSData) {
        let header = LSRPackableStructUtilities.unpack(data, LSR_MsgHeader_t.self)

        switch UInt32(header.msgCode) {
            case FW_PACKAGE_VERSION_ASYNC_MSG_CODE.value: handleMessage(LSRPackableStructUtilities.unpack(data, WatchFirmwareVersionMsg_t.self))
            case FITNESS_DASHBOARD_MSG_CODE.value:        handleMessage(LSRPackableStructUtilities.unpack(data, LSR_FitnessDashboardData_t.self, skipBits: 48))
            case FITNESS_DATA_MSG_CODE.value:             handleMessage(LSRPackableStructUtilities.unpack(data, LSR_FitnessData_t.self,          skipBits: 48))
            case REQUEST_NEXT_FW_BLOCK_MSG_CODE.value:    handleMessage(LSRPackableStructUtilities.unpack(data, RequestNextFirmwareBlockMsg_t.self))
            default: LSRLog(.BluetoothWatchLink, .Warning, "Unpacked header for unrecognized message: \(header)")
        }
    }

    private func handleMessage<T : LSRPackableStruct>(message: T) {
        for messageHandler in messageHandlers {
            messageHandler(message)
        }
    }

    func registerMessageHandler<T: LSRPackableStruct>(type: T.Type, dispatchQueue: dispatch_queue_t = dispatch_get_main_queue(), handler: (T) -> Void) {
        messageHandlers.append {
            if let message = $0 as? T {
                dispatch_async(dispatchQueue) {
                    handler(message)
                }
            }
        }
    }
    
    // MARK: Connection Handlers
    
    func registerConnectionHandler(handlerBlock: ([CBPeripheral]) -> Void) -> String {
        let aHandlerID = NSUUID().UUIDString
        connectionHandlers.append(handlerBlock, handlerID: aHandlerID)
        return aHandlerID
    }

    func unregisterConnectionHandlerWithID(handlerID: String) {
        // Find matching handlers (if any) with the handlerID and remove them from the connectionHandlers array
        LSRLog(.BluetoothWatchLink, .Trace, "Unregistering handler ID: \(handlerID), contents before: \(connectionHandlers)")
        connectionHandlers = connectionHandlers.filter({$1 != handlerID})
        LSRLog(.BluetoothWatchLink, .Trace, "Contents after: \(connectionHandlers)")
    }

    private func exerciseConnectionHandlers() {
        for (handler, _) in connectionHandlers {
            handler(peripheralArray)
        }
    }

    // MARK: Control 

    func connectToPeripheral(peripheral:CBPeripheral) {
        state = .Connecting(peripheral)
        NSUserDefaults.standardUserDefaults().setObject(peripheral.identifier.UUIDString, forKey: "LastConnectedDeviceUUIDString")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func disconnectFromPeripheral() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("LastConnectedDeviceUUIDString")
        NSUserDefaults.standardUserDefaults().synchronize()
        switch state {
            case let .Connected(peripheral, _, _, _, _): central.cancelPeripheralConnection(peripheral)
            default: return
        }
        LSRLog(.BluetoothWatchLink, .Trace, "Setting BSM to .Discovering.")
        state = .Discovering
    }
    
    func connectedPeripheral() -> CBPeripheral? {
        switch state {
            case let .Connected(peripheral, _, _, _, _): return peripheral
            default: return nil
        }
    }
    
    func beginScanning() {
        if central.state == .PoweredOn {
            LSRLog(.BluetoothWatchLink, .Trace, "Setting BSM to .Discovering.")
            state = .Discovering
        } else {
            LSRLog(.BluetoothWatchLink, .Warning, "beginScanning() called when central state is not .PoweredOn")
        }
    }

    func lastConnectedUUID() -> NSUUID? {
        let uuidString = NSUserDefaults.standardUserDefaults().objectForKey("LastConnectedDeviceUUIDString") as? String
        return uuidString.flatMap { NSUUID(UUIDString: $0) }
    }

    //MARK: CBCentralManagerDelegate conformance

    func centralManagerDidUpdateState(central: CBCentralManager!) {
        LSRLog(.BluetoothWatchLink, .Info, "Central state changed to \(central.state).")

        if central.state == .PoweredOn {
//            LSRLog(.BluetoothWatchLink, .Trace, "Setting BSM to .Discovering.")
//            state = .Discovering
            if let lastConnectedPeripheralUUIDString = NSUserDefaults.standardUserDefaults().objectForKey("LastConnectedDeviceUUIDString") as? String {
                LSRLog(.BluetoothWatchLink, .Trace, "Found a last connected device UUID string")
                if let lastConnectedPeripheralUUID = NSUUID(UUIDString: lastConnectedPeripheralUUIDString),
                    lastConnectedPeripherals = central.retrievePeripheralsWithIdentifiers([lastConnectedPeripheralUUID]),
                    let lastConnectedPeripheral = lastConnectedPeripherals.first as? CBPeripheral
                {
                    LSRLog(.BluetoothWatchLink, .Trace, "Will attempt to connect to last connected device")
                    connectToPeripheral(lastConnectedPeripheral)
                }
            }
        } else {
            LSRLog(.BluetoothWatchLink, .Trace, "Setting BSM to .Uninitialized because central state is not .PoweredOn.")
            state = .Uninitialized
        }
    }

    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        LSRLog(.BluetoothWatchLink, .Info, "Discovered peripheral: \(peripheral)")
        
        if find(peripheralArray, peripheral) == nil {
            peripheralArray.append(peripheral)
        }
        
        exerciseConnectionHandlers()
        //Functionality for Jarden, but not for Development
//        if peripheralFilter(peripheral) {
//            state = .Connecting(peripheral)
//        }
    }

    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        state = .InterrogatingServices(peripheral)
        
        exerciseConnectionHandlers()
    }

    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        LSRLog(.BluetoothWatchLink, .Info, "Disconnected peripheral: \(peripheral), \(error)")
        notificationRetries = 0

        if let lastConnectedDeviceUUID = lastConnectedUUID() where peripheral.identifier == lastConnectedDeviceUUID {
            connectToPeripheral(peripheral)
            return
        }
        
        state = .Discovering
        
        exerciseConnectionHandlers()
    }

    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        LSRLog(.BluetoothWatchLink, .Warning, "Failed to connect to peripheral: \(peripheral), \(error)")
        notificationRetries = 0

        if let lastConnectedDeviceUUID = lastConnectedUUID() where peripheral.identifier == lastConnectedDeviceUUID {
            connectToPeripheral(peripheral)
            return
        }

        state = .Discovering
        
        exerciseConnectionHandlers()
    }

    //MARK: CBPeripheralDelegate conformance

    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if let services = peripheral.services as? [CBService], sppService = services.filter({ $0.UUID == kSPPServiceUUID }).first {
            state = .InterrogatingCharacteristics(peripheral, sppService: sppService)
        } else {
            LSRLog(.BluetoothWatchLink, .Error, "Failed to discover required services. Found \(peripheral.services)")
            state = .Discovering
        }
    }

    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        if let characteristics = service.characteristics as? [CBCharacteristic],
            commandPortCharacteristic = characteristics.filter({ $0.UUID == kSPPCommandPortCharacteristicUUID }).first,
            responsePortCharacteristic = characteristics.filter({ $0.UUID == kSPPResponsePortCharacteristicUUID }).first,
            sideBandCharacteristic = characteristics.filter({ $0.UUID == kSPPSideBandCharacteristicUUID }).first
        {
            state = .Connected(peripheral, sppService: service,
                commandPortCharacteristic: commandPortCharacteristic,
                responsePortCharacteristic: responsePortCharacteristic,
                sideBandCharacteristic: sideBandCharacteristic)
        } else {
            LSRLog(.BluetoothWatchLink, .Error, "Failed to discover required characteristics. Found \(service.characteristics)")
            disconnectFromPeripheral()
            state = .Discovering
        }
    }

    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if let error = (error as NSError?) {
            LSRLog(.BluetoothWatchLink, .Warning, "Error occurred while writing new value to characteristic \(characteristic.UUID)! Is this fatal? \(error)")
        }
    }

    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if let characteristic = (characteristic as CBCharacteristic?) {
            if characteristic.UUID == kSPPResponsePortCharacteristicUUID {
                BluetoothPacketTrace.trace(characteristic.value, direction: .PeripheralToCentral)
                handlePacket(characteristic.value)
            } else {
                LSRLog(.BluetoothWatchLink, .Warning, "Updated value for characteristic other than kSPPResponsePortCharacteristicUUID!")
            }
        } else {
            LSRLog(.BluetoothWatchLink, .Warning, "peripheral:didUpdateValueForCharacteristic:error: called with nil characteristic. Error? \(error)")
        }
    }

    var notificationRetries = 0
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError?) {
        if let error = (error as NSError?) {
            LSRLog(.BluetoothWatchLink, .Error, "Failed to subscribe to response port. Error: \(error)")
            
            if notificationRetries < 1
            {
                LSRLog(.BluetoothWatchLink, .Error, "Will retry subscription")
                notificationRetries++
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                return
            }
            
            LSRLog(.BluetoothWatchLink, .Error, "Failed to subscribe to response port. Resetting BSM. Error: \(error)")
            
            state = .Discovering
            
            exerciseConnectionHandlers()
            
            return
        }

        switch state {
            case let .Connected(_, _, commandPortCharacteristic, responsePortCharacteristic, sideBandCharacteristic):
                LSRLog(.BluetoothWatchLink, .Info, "Subscribed to response port.")
                sendMessage(LSR_MsgHeader_t(msgSize: 6, msgCode: CONNECTED_MSG_CODE), label: "Connected message")
                sendMessage(TimeSyncMsg_t(date: NSDate()), label: "Time sync")
                
                exerciseConnectionHandlers()

            default:
                LSRLog(.BluetoothWatchLink, .Error, "Subscribed to response port but we're not in .Connected state! Resetting BSM.")
                exerciseConnectionHandlers()
                state = .Discovering
        }
    }

    //MARK: Firmware Updating

    var currentFirmwareUpdateProcess: FirmwareUpdateProcess?
    
    var firmwareDataToDownload: NSData?
    var overallFirmwareProgressMarker = 0
    
    func startUpdateFirmware(firmwareData: NSData) {
        currentFirmwareUpdateProcess = .Uninitialized
        
        firmwareDataToDownload = firmwareData
        if firmwareDataToDownload == nil {
            return
        }
        
        overallFirmwareProgressMarker = 0
        sendMessage(LSR_MsgHeader_t(msgSize: 6, msgCode: DO_FW_DOWNLOAD_CODE), label: "Do Firmware Download Message")
    }
    
    func continueFirmwareUpdate(batchSize: UInt16) {
        let sizeToWrite = UInt16(min(Int(batchSize), firmwareDataToDownload!.length - overallFirmwareProgressMarker))
        LSRLog(.BluetoothWatchLink, .Info, "\(NSDate()) [BWL] would continue firmware update (\(sizeToWrite):\(overallFirmwareProgressMarker) / \(firmwareDataToDownload?.length)) with batchSize: \(batchSize)")

        var currentBatchWritten: UInt16 = 0
        while currentBatchWritten < sizeToWrite {
            let nextDataToWrite = firmwareDataToDownload!.subdataWithRange(NSMakeRange(overallFirmwareProgressMarker, 128))
            // Write nextDataToWrite to sideBandCharacteristic
            switch state {
                case let .Connected(peripheral, _, _, _, sideBandCharacteristic):
                    BluetoothPacketTrace.trace(nextDataToWrite, direction: BluetoothPacketDirection.CentralToPeripheral, label: "Firmware Data (Sideband Characteristic)")
                    peripheral.writeValue(nextDataToWrite, forCharacteristic: sideBandCharacteristic, type: CBCharacteristicWriteType.WithoutResponse)
                
                default:
                    assertionFailure("[BWL] Attempted to send data when not connected.")
            }
            
            currentBatchWritten += 128
            overallFirmwareProgressMarker += 128
        }
        
        if overallFirmwareProgressMarker == firmwareDataToDownload!.length
        {
            LSRLog(.BluetoothWatchLink, .Info, "[BWL] Firmware Update Complete!")
        }
        // Here we should determine if we are completed or waiting for the next reply from the watch
    }
}

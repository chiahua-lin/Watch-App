//
//  BluetoothStateMachine.swift
//  Watch_1373
//
//  Created by William LaFrance.
//

import CoreBluetooth

enum BluetoothStateMachine : Printable {

    case Uninitialized

    case Discovering

    case Connecting(CBPeripheral)

    case InterrogatingServices(CBPeripheral)

    case InterrogatingCharacteristics(CBPeripheral,
        sppService: CBService)

    case Connected(CBPeripheral,
        sppService: CBService,
        commandPortCharacteristic: CBCharacteristic,
        responsePortCharacteristic: CBCharacteristic,
        sideBandCharacteristic: CBCharacteristic)

    var stateName: String {
        get {
            switch self {
                case .Uninitialized:                return "Uninitalized"
                case .Discovering:                  return "Discovering"
                case .Connecting:                   return "Connecting"
                case .InterrogatingServices:        return "InterrogatingServices"
                case .InterrogatingCharacteristics: return "InterrogatingCharacteristics"
                case .Connected:                    return "Connected"
            }
        }
    }

    var description: String {
        get {
            switch self {
                case .Uninitialized:
                    return ".Uninitialized"

                case .Discovering:
                    return ".Discovering"

                case let .Connecting(peripheral):
                    return ".Connecting (peripheral: \(peripheral))"

                case let .InterrogatingServices(peripheral):
                    return ".InterrogatingServices (peripheral: \(peripheral))"

                case let .InterrogatingCharacteristics(peripheral, sppService):
                    return ".InterrogatingCharacteristics (peripheral: \(peripheral), " +
                        "sppService: \(sppService.UUID)"

                case let .Connected(peripheral, sppService, commandPortCharacteristic, responsePortCharacteristic, sideBandCharacteristic):
                    return ".Connected (peripheral: \(peripheral), " +
                        "sppService: \(sppService.UUID), " +
                        "commandPortCharacteristic: \(commandPortCharacteristic.UUID), " +
                        "responsePortCharacteristic: \(responsePortCharacteristic.UUID), " +
                        "sideBandCharacteristic: \(sideBandCharacteristic.UUID))"
            }
        }
    }
}

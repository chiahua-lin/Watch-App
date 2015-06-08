//
//  SettingsPairingTableViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 5/11/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit
import CoreBluetooth

class SettingsPairingTableViewController: UITableViewController {

    let watchLink = BluetoothWatchLink.sharedInstance()
    var peripheralArray:[CBPeripheral] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        watchLink.registerConnectionHandler { (peripheralArray) -> Void in
            self.peripheralArray = peripheralArray
            println("peripheralArray: \(self.peripheralArray)")
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
        if let peripheral = watchLink.connectedPeripheral() {
            peripheralArray = [peripheral]
        } else {
            watchLink.beginScanning()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func test() {
        let watchLink = BluetoothWatchLink.sharedInstance()
        LSRLog(.Initialization, .Info, "BluetoothWatchLink setup: \(watchLink)")
        
        watchLink.registerMessageHandler(WatchFirmwareVersionMsg_t.self) {
            LSRLog(.BluetoothWatchLink, .Info, "Watch reported firmware version: \($0)"); return
        }
        
        watchLink.registerMessageHandler(LSR_FitnessData_t.self) {
            LSRLog(.BluetoothWatchLink, .Info, "Fitness data (non-dashboard): \($0)"); return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return peripheralArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        let peripheral = peripheralArray[indexPath.row]
        cell.textLabel!.text = peripheral.name
//        cell.textLabel?.text
        // Configure the cell...
        
        if peripheral.state == .Connected {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let peripheral = peripheralArray[indexPath.row]
        
        if let connectedPeripheral = watchLink.connectedPeripheral() {
            if connectedPeripheral != peripheral {
                watchLink.disconnectFromPeripheral()
                watchLink.connectToPeripheral(peripheralArray[indexPath.row])
            } else {
                watchLink.disconnectFromPeripheral()
                println("You're already paired!")
            }
        } else {
            watchLink.connectToPeripheral(peripheral)
        }
    }
}

//
//  FirmwareViewController.swift
//  Watch_1373
//
//  Created by Joe Bonniwell on 5/4/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit


class FirmwareViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var watchConnectedLabel: UILabel?
    @IBOutlet weak var firmwareVersionLabel: UILabel?
    
    @IBOutlet weak var startUpdateButton: UIButton?
    
    @IBOutlet weak var firmwareTableView: UITableView?
    
    // Firmware image list tableview with selection
    
    // Status display
    
    var availableFirmwareNames: Array<String>?
    var selectedFirmwareIndex: Int?
    // Start firmware update process button
    override func viewDidLoad()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "watchDidUpdate", name: "WatchUpdateNotification", object: BluetoothWatchLink.sharedInstance())
        // Get the current firmware list and then display it in a tableview
        if let watchFirmwareVersion = BluetoothWatchLink.sharedInstance().firmwareVersion
        {
            // We have the firmware version, update stuff
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            let firmwareFilesDirectory = documentsDirectory.stringByAppendingPathComponent("firmwareFiles")
            NSFileManager.defaultManager().createDirectoryAtPath(firmwareFilesDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)
            
            let existingFirmwareFiles = NSFileManager.defaultManager().contentsOfDirectoryAtPath(firmwareFilesDirectory, error: nil)
            
            println("existing firmware files: \(existingFirmwareFiles)")
            
            availableFirmwareNames = allAvailableFirmwareFileNames()
            // Get any images that are in the bundle and move/save them over to the directory
            // What to do with that? list it I guess?
            self.firmwareTableView?.tableFooterView = UIView(frame: CGRectZero)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // Update the UI to reflect the current watch status...
        availableFirmwareNames = allAvailableFirmwareFileNames()
        updateStatusDisplay()
    }
    
    func updateStatusDisplay()
    {
        // Connected Label
        if BluetoothWatchLink.sharedInstance().canSendMessage
        {
            self.watchConnectedLabel?.text = "Connected"
            self.watchConnectedLabel?.textColor = UIColor.greenColor()
        }
        else
        {
            self.watchConnectedLabel?.text = "Not Connected"
            self.watchConnectedLabel?.textColor = UIColor.redColor()
        }
        
        // Firmware Version Label
        if let watchFirmwareVersion: FirmwareVersion = BluetoothWatchLink.sharedInstance().firmwareVersion
        {
            self.firmwareVersionLabel?.text = "\(watchFirmwareVersion.major).\(watchFirmwareVersion.minor).\(watchFirmwareVersion.build)"
            self.firmwareVersionLabel?.textColor = UIColor.greenColor()
        }
        else
        {
            self.firmwareVersionLabel?.text = "Unknown"
            self.firmwareVersionLabel?.textColor = UIColor.redColor()
        }
        
        self.startUpdateButton?.enabled = false
        if BluetoothWatchLink.sharedInstance().canSendMessage && BluetoothWatchLink.sharedInstance().firmwareVersion != nil
        {
            self.startUpdateButton?.enabled = true
        }
        
        self.firmwareTableView?.reloadData()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "watchDidUpdate", object: BluetoothWatchLink.sharedInstance())
    }
    
    // How to monitor for update to firmware version...
    func watchDidUpdate()
    {
        println("watchDidUpdate")
        updateStatusDisplay()
    }
    
    @IBAction func startFirmwareDownload()
    {
        // Start the firmware download process
        
        // Should maybe create an object that can manage the process
        
        // 1. Send the command to start updating the firmware
        // 2. Record the requested block size from the response command
        // 3. Write up until the block size or end of the firmware file
        // 4. Wait for response if stopped at block size
        
        // Create state object
        if let actualSelectedFirmware = selectedFirmwareIndex
        {
            let firmwareName: String? = availableFirmwareNames?[actualSelectedFirmware]
            if firmwareName != nil
            {
                let firmwareData = firmwareDataForFileName(firmwareName!)
                BluetoothWatchLink.sharedInstance().startUpdateFirmware(firmwareData!)
            }
        }
    }
    
    // MARK: - TableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return availableFirmwareNames!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Create cell
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("firmwareVersionCell") as? UITableViewCell
        if tableViewCell == nil
        {
            tableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "firmwareVersionCell")
        }
        
        tableViewCell!.textLabel?.text = availableFirmwareNames?.first
        tableViewCell!.accessoryType = UITableViewCellAccessoryType.None
        if indexPath.row == selectedFirmwareIndex
        {
            tableViewCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return tableViewCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedFirmwareIndex = indexPath.row
        self.firmwareTableView?.reloadData()
    }
}
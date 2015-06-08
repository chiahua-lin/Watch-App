//
//  PairingViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/18/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit
import CoreBluetooth

class PairingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let watchLink = BluetoothWatchLink.sharedInstance()
    var peripheralArray:[CBPeripheral] = []
    var connectionHandlerID: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = JardenColor.teal
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : JardenColor.teal]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : JardenColor.teal], forState: .Normal)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController() {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionHandlerID = watchLink.registerConnectionHandler { (peripheralArray) -> Void in
            self.peripheralArray = peripheralArray
            
            println("Connection handler callback for PairingViewController")
            dispatch_async(dispatch_get_main_queue()) {
                if self.watchLink.connectedPeripheral() != nil
                {
                    // Perform the same action as the temp button...
                    self.advanceToPairingSuccess()
                }
                else if self.watchLink.lastConnectedUUID() == nil
                {
                    if let firstPeripheralFound = self.peripheralArray.first
                    {
                        self.watchLink.connectToPeripheral(firstPeripheralFound)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        if watchLink.lastConnectedUUID() == nil
        {
            watchLink.beginScanning()
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func tempButtonTapped()
    {
        advanceToPairingSuccess()
    }
    
    func advanceToPairingSuccess()
    {
        self.performSegueWithIdentifier("ShowPairingSuccess", sender: nil)
        watchLink.unregisterConnectionHandlerWithID(connectionHandlerID!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cellIdentifier = "Watch_Cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let peripheral = peripheralArray[indexPath.row]

        cell.textLabel!.text = peripheral.name
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        watchLink.connectToPeripheral(peripheralArray[indexPath.row])
    }
}

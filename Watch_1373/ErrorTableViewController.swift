//
//  ErrorTableViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 5/4/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

struct LSRError {
    var date:NSDate
    var errorNumber:Int
    var errorName:String
    var errorType:String
    var cycle:String
    var fileName:String
    var lineNumber:Int
    var errorMessage:String
}

//[
//    {
//        "time": 123456789,
//        "number": 6,
//        "name": LSR_ERROR_WDOG_RESET,
//        "type": "Error",
//        "cycle": "Any",
//        "file": "lsr_wdog_task",
//        "line": 345,
//        "msg": "Watchdog reset occured (task 4, time 123456789)",
//    },
//]


class ErrorTableViewController: UITableViewController {

    var errorArray:[LSRError] = []
    var errorLookupArray:[AnyObject]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = NSBundle.mainBundle().pathForResource("watch_error_dictionary", ofType: "json") {
            let dataBlob = NSFileManager.defaultManager().contentsAtPath(path)
            var error:NSError? = nil
            let JSONObject = NSJSONSerialization.JSONObjectWithData(dataBlob!, options: nil, error: &error) as? [AnyObject]
            if let objects = JSONObject {
                errorLookupArray = objects
            }
        }
        println(formatObject(errorNumber: 100))
        println(formatObject(errorNumber: 1000))
        println(formatObject(errorNumber: 1001))
        println(formatObject(errorNumber: 5))
        println(formatObject(errorNumber: 0))
        println(formatObject(errorNumber: 3000))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func formatObject(#errorNumber:Int) -> Dictionary<NSObject, AnyObject>? {
        var errorDictionary:Dictionary<NSObject, AnyObject>?
        for errorArrayObject in errorLookupArray as! [Dictionary<NSObject, AnyObject>] {
            let startingError = errorArrayObject["start"] as! Int
            let endingError = errorArrayObject["end"] as! Int
            if errorNumber >= startingError && errorNumber <= endingError {
                let errorPosition:Int
                if startingError != 0 {
                    errorPosition = errorNumber % startingError
                } else {
                    errorPosition = errorNumber
                }
                
                let errorArray = errorArrayObject["errors"] as? [AnyObject]
                errorDictionary = errorArray![errorPosition] as? Dictionary<NSObject, AnyObject>
            }
        }
        
        return errorDictionary
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
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

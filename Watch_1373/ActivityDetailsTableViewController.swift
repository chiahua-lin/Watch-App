//
//  ActivityDetailsTableViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/4/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ActivityDetailsTableViewController: UITableViewController {
    
    var fakeData:[(Int, NSDate)] = []
    var goalTextIdentifier = ""
    var goalValue:Int!
    var maxValueLimiter:Int!
    
//    override func awakeFromNib() {
//        
//    }
    override func viewWillAppear(animated: Bool) {
        fakeDataGenerator()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 7
    }
    
    func weeklabel(date:NSDate) -> String? {
        if let beginningOfWeek = NSCalendar.currentCalendar().dateForBeginningOfWeek(date), let endOfWeek = NSCalendar.currentCalendar().dateForEndOfWeek(date) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM"
            
            let beginningDay = NSCalendar.currentCalendar().component(.CalendarUnitDay, fromDate: beginningOfWeek)
            let endingDay = NSCalendar.currentCalendar().component(.CalendarUnitDay, fromDate: endOfWeek)
            
            return "\(dateFormatter.stringFromDate(beginningOfWeek)) \(beginningDay) - \(dateFormatter.stringFromDate(endOfWeek)) \(endingDay)"
        } else {
            return ""
        }
    }
    
    func dayLabel(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        if NSCalendar.currentCalendar().isDateInThisWeek(date) {
            dateFormatter.dateFormat = "EE"
        } else {
            dateFormatter.dateFormat = "MM/dd"
        }
        return dateFormatter.stringFromDate(date)
    }
    
    func fakeDataGenerator() {
        var sizeOfDataset = 14
        
        fakeData = []
        
        
        let date = NSCalendar.currentCalendar().dateForEndOfWeek(NSDate())!
        
        for index in 0..<sizeOfDataset {
            fakeData.append(randomUniform(maxValueLimiter!), NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: -index, toDate: date , options: NSCalendarOptions(0))!)
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let CellIdentifier = "SectionHeaderCell"
        
        let sessionHeaderCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ActivitySessionHeaderTableViewCell
        let date = NSDate(timeIntervalSinceNow: Double(86400 * (section * 7) * -1))
        
        sessionHeaderCell.dateLabel.text = weeklabel(date)
        
        return sessionHeaderCell
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivitySessionTableViewCell

        let sessionMultiplier = indexPath.section
        let fakeDataTuple = fakeData[(indexPath.row + ((sessionMultiplier > 0) ? (indexPath.section * 7) : 0))]
        
        cell.dateLabel.text = dayLabel(fakeDataTuple.1)
        cell.activityNameLabel.text = "\(fakeDataTuple.0) \(goalTextIdentifier)"
        
        if fakeDataTuple.0 > goalValue {
            cell.activityNameLabel.textColor = JardenColor.teal
        }

        return cell
    }

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

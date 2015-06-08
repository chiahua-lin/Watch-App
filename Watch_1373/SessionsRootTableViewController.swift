//
//  SessionsRootTableViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/27/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SessionsRootTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCell", forIndexPath: indexPath) as! UITableViewCell
        
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let CellIdentifier = "SectionHeaderCell"
        
        let sessionHeaderCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! SessionHeaderTableViewCell
        let date = NSDate(timeIntervalSinceNow: Double(86400 * (section * 7) * -1))
        
        sessionHeaderCell.dateLabel.text = weeklabel(date)
        
        return sessionHeaderCell
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
}

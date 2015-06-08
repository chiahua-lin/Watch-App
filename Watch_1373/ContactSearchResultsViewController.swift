//
//  ContactSearchResultsViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ContactSearchResultsViewController: UITableViewController {
    var searchList:[Contact]?
    
    override func viewWillAppear(animated: Bool) {
        let nib = UINib(nibName: "OnelinkContactCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ContactCell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchList = searchList {
            return searchList.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "ContactCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! ContactSelectionTableViewCell
        
        let contact = searchList![indexPath.row]
        
        cell.contactName.text = contact.name
        cell.contactImage.image = contact.profilePicture
        cell.contactPhone.text = contact.phoneNumber
        cell.showSelectionCircle(true)
        
        return cell
    }

}

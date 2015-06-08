//
//  ContactViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/30/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    let contactArray = [Contact(name:"Issac Newton", profilePicture:UIImage(named: "issac_newton.jpg")!, phoneNumber:"None", selected:false),
                        Contact(name:"Richard Feynman", profilePicture:UIImage(named: "Richard_Feynman.png")!, phoneNumber:"626-395-6811", selected:false),
                        Contact(name:"William Nye", profilePicture:UIImage(named: "Bill_Nye.jpg")!, phoneNumber:"703-739-5000", selected:false),
                        Contact(name:"Neil Degrasse Tyson", profilePicture:UIImage(named: "tyson_big_bang.jpg")!, phoneNumber:"212-769-5100", selected:false),
                        Contact(name:"Carl Sagan", profilePicture:UIImage(named: "carlsagan.jpg")!, phoneNumber:"607-254-4636", selected:false)]
    var searchController:UISearchController?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nib = UINib(nibName: "OnelinkContactCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ContactCell")
        let contactSearchController = ContactSearchResultsViewController()
        contactSearchController.searchList = contactArray
        searchController = UISearchController(searchResultsController:contactSearchController)
        searchController?.searchResultsUpdater = self
        
        searchController?.searchBar.frame = CGRectInset(searchController!.searchBar.frame, 0, -20)
        
        tableView.tableHeaderView = searchController?.searchBar
//        tableView.setEditing(true, animated: false)
        
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        definesPresentationContext = true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactSelectionTableViewCell
        let contact = contactArray[indexPath.row % 5]
        cell.contactName.text = contact.name
        cell.contactImage.image = contact.profilePicture
        cell.contactPhone.text = contact.phoneNumber
        cell.setSelected(contact.selected, animated: false)
        cell.showSelectionCircle(true)
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //Enable search array
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //Update search results with new .text value setting
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

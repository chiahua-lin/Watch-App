//
//  ProfileViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/23/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit
import CoreImage

enum UserAttributes: Int {
    case Birthdate
    case Height
    case Weight
    case Eyes
    case Hair
    case Race
    case name
}

protocol ProfileViewControllerDelegate {
    func updateProfileDetails(values:(UserAttributes, AnyObject));
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissHoverScreenButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    var currentUserProfile = Profile(name: "Robert Haworth", birthdate: NSDate().dateByAddingTimeInterval(-86400 * 9161), heightInInches:69, weight: 170, hair: .Brown, eyes: .Blue, race: .White, profilePicture:UIImage(named:"rexnuke.gif")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = continueButton.bounds.size.width / 2
        dismissHoverScreenButton.layer.cornerRadius = dismissHoverScreenButton.bounds.size.width / 2
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let row = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(row, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 150
        default: return 44
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    @IBAction func didTapDateLabel(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("PickerViewControllerSegue", sender: sender)
    }
    
    @IBAction func didTapNameLabel(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("TextFieldControllerSegue", sender: sender)
    }
    
    @IBAction func didTapProfilePicture(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .Default) { (action) in
            self.presentPhotoLibraryView()
        }
        
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .Default) { (action) in
            self.presentCameraView()
        }
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(photoLibraryAction)
        
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentPhotoLibraryView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            pickerController.sourceType = .PhotoLibrary
        }
        pickerController.navigationBar.barTintColor = UIColor.whiteColor()
        pickerController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : JardenColor.teal]
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func presentCameraView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            pickerController.sourceType = .Camera
        }
        pickerController.navigationBar.barTintColor = UIColor.whiteColor()
        pickerController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : JardenColor.teal]
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        currentUserProfile.profilePicture = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true) {
            self.tableView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) {}
        println("cancelled image taking")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let profileCellIdentifier = "ProfileCell"
        let profileDetailCellIdentifier = "DetailCell"
        
        var cell:UITableViewCell
        
        if indexPath.row == 0 {
            let testCell = tableView.dequeueReusableCellWithIdentifier(profileCellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
            testCell.nameLabel.text = currentUserProfile.name
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM dd, YYYY"
            testCell.dateLabel.text = dateFormatter.stringFromDate(currentUserProfile.birthdate)
            testCell.profileImageView.image = currentUserProfile.profilePicture
            testCell.addPhotoLabel.hidden = true
            testCell.maleButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            cell = testCell
        } else {
            let testCell = tableView.dequeueReusableCellWithIdentifier(profileDetailCellIdentifier, forIndexPath: indexPath) as! ProfileDetailTableViewCell
            if let profile = UserAttributes(rawValue: indexPath.row) {
                switch profile {
                case .Height:
                    testCell.profileInfoLabel.text = "Height"
                    testCell.profileInfoDetailLabel.text = "\(currentUserProfile.heightInInches / 12)'\(currentUserProfile.heightInInches % 12)\""
                case .Weight:
                    testCell.profileInfoLabel.text = "Weight"
                    testCell.profileInfoDetailLabel.text = "\(currentUserProfile.weight)"
                case .Eyes:
                    testCell.profileInfoLabel.text = "Eyes"
                    testCell.profileInfoDetailLabel.text = currentUserProfile.eyes.stringValue()
                case .Hair:
                    testCell.profileInfoLabel.text = "Hair"
                    testCell.profileInfoDetailLabel.text = currentUserProfile.hair.stringValue()
                case .Race:
                    testCell.profileInfoLabel.text = "Race"
                    testCell.profileInfoDetailLabel.text = currentUserProfile.race.stringValue()
                default: break
                }

            }
            cell = testCell
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:break
        default: performSegueWithIdentifier("PickerViewControllerSegue", sender: indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickerViewControllerSegue" {
            let destinationController = segue.destinationViewController as! PickerTableViewController
            if let indexPath = sender as? NSIndexPath {
                switch indexPath.row {
                case 1: destinationController.pickerType = .Height
                case 2: destinationController.pickerType = .Weight
                case 3: destinationController.pickerType = .Eyes
                case 4: destinationController.pickerType = .Hair
                case 5: destinationController.pickerType = .Race
                default: break
                }
            } else {
                destinationController.pickerType = .Birthdate
            }
            destinationController.currentUserProfile = currentUserProfile
            destinationController.profileDelegate = self
        } else if segue.identifier == "TextFieldControllerSegue" {
            let destinationController = segue.destinationViewController as! TextFieldEntryTableViewController
            destinationController.currentProfileName = currentUserProfile.name
            destinationController.profileDelegate = self
        }
    }
    
    @IBAction func removeHoverView(sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }
    
    func updateProfileDetails(values:(UserAttributes, AnyObject)) {
        println("updated \(values.0) to \(values.1)")
        switch values.0 {
        case .Height: currentUserProfile.heightInInches = values.1 as! Int
        case .Weight: currentUserProfile.weight = values.1 as! Int
        case .Eyes: currentUserProfile.eyes = EyeColor(rawValue:values.1 as! Int)!
        case .Hair: currentUserProfile.hair = HairColor(rawValue:values.1 as! Int)!
        case .name: currentUserProfile.name = values.1 as! String
        case .Race: currentUserProfile.race = Race(rawValue: values.1 as! Int)!
        case .Birthdate: currentUserProfile.birthdate = values.1 as! NSDate
        }
        tableView.reloadData()
    }
}

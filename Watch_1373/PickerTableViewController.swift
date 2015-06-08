//
//  PickerTableViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/23/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum EyeColor:Int {
    case Amber
    case Blue
    case Brown
    case Grey
    case Green
    case Hazel
    case Violet
    
    func stringValue() -> String{
        switch self {
        case .Amber: return "Amber"
        case .Blue: return "Blue"
        case .Brown: return "Brown"
        case .Grey: return "Grey"
        case .Green: return "Green"
        case .Hazel: return "Hazel"
        case .Violet: return "Violet"
        default: return ""
        }
    }
    
    static var count: Int { return self.Violet.hashValue + 1}
}

enum HairColor:Int {
    case Black
    case Brown
    case Blonde
    case Auburn
    case Chestnut
    case Red
    case Grey
    case White

    func stringValue() -> String {
        switch self {
        case .Black: return "Black"
        case .Brown: return "Brown"
        case .Blonde: return "Blonde"
        case .Auburn: return "Auburn"
        case .Chestnut: return "Chestnut"
        case .Red: return "Red"
        case .Grey: return "Grey"
        case .White: return "White"
        default: return ""
        }
    }
    
    static var count: Int { return self.White.hashValue + 1}
}

enum Race:Int {
    case AmericanIndian
    case AlaskaNative
    case Asian
    case Black
    case AfricanAmerican
    case NativeHawaiian
    case OtherPacificIslander
    case White
    
    func stringValue() -> String {
        switch self {
        case .AmericanIndian: return "American Indian"
        case .AlaskaNative: return "Alaska Native"
        case .Asian: return "Asian"
        case .Black: return "Black"
        case .AfricanAmerican: return "African American"
        case .NativeHawaiian: return "Native Hawaiian"
        case .OtherPacificIslander: return "Other Pacific Islander"
        case .White: return "White"
        }
    }
    
    static var count: Int { return self.White.hashValue + 1}
}

class PickerTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerType:UserAttributes?
    var currentUserProfile:Profile?
    
    var profileDelegate:ProfileViewControllerDelegate?
    
    @IBOutlet weak var navItem: UINavigationItem!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let type = pickerType {
            var navTitle = ""
            switch type {
            case .Height: navTitle = "Enter Height"
            case .Weight: navTitle = "Enter Weight"
            case .Eyes: navTitle = "Enter Eye Color"
            case .Hair: navTitle = "Enter Hair Color"
            case .Race: navTitle = "Enter Race"
            default: break
            }
            
            navItem.title = navTitle
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
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let type = pickerType {
            switch type {
            case .Height: return component == 0 ? 10 : 13
            case .Weight: return 400
            case .Eyes: return EyeColor.count
            case .Hair: return HairColor.count
            case .Race: return Race.count
            default: return 0
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateProfile()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if let type = pickerType {
            switch type {
            case .Height: return 2
            default: return 1
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if let type = pickerType {
            switch type {
            case .Height:
                if component == 0 {
                    return "\(row)'"
                } else {
                    return "\(row)\""
                }
            case .Weight: return "\(row) lbs"
            case .Eyes: return EyeColor(rawValue: row)?.stringValue()
            case .Hair: return HairColor(rawValue: row)?.stringValue()
            case .Race: return Race(rawValue: row)?.stringValue()
            default: return "Not Needed"
            }
        }
        return "Not Needed"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
        if let type = pickerType {
            
            var rowValue:Int = 0
            
            switch type {
            case .Birthdate:
                let test = tableView.dequeueReusableCellWithIdentifier("DatePicker", forIndexPath: indexPath) as! DatePickerTableViewCell
                test.datePicker.maximumDate = NSDate()
                test.datePicker.addTarget(self, action: Selector("updateProfile"), forControlEvents: .ValueChanged)
                test.datePicker.date = currentUserProfile!.birthdate
                cell = test
            case .Weight:
                rowValue = currentUserProfile!.weight++
            case .Height:
                let test = tableView.dequeueReusableCellWithIdentifier("StandardPicker", forIndexPath: indexPath) as! PickerTableViewCell
                test.picker.selectRow(currentUserProfile!.heightInInches / 12, inComponent: 0, animated: false)
                test.picker.selectRow(currentUserProfile!.heightInInches % 12, inComponent: 1, animated: false)
                cell = test
            case .Eyes:
                rowValue = currentUserProfile!.eyes.rawValue
            case .Hair:
                rowValue = currentUserProfile!.hair.rawValue
            case .Race:
                rowValue = currentUserProfile!.race.rawValue
            default: break
            }
            
            if type != .Height && type != .Birthdate {
                let test = tableView.dequeueReusableCellWithIdentifier("StandardPicker", forIndexPath: indexPath) as! PickerTableViewCell
                test.picker.selectRow(rowValue, inComponent: 0, animated: false)
                cell = test
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 162
    }

    func updateProfile() {
        if let type = pickerType {
            if type == .Birthdate {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! DatePickerTableViewCell
                
                profileDelegate?.updateProfileDetails((type, cell.datePicker.date))
            } else {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! PickerTableViewCell
                
                switch type {
                case .Height:
                    let inches = (cell.picker.selectedRowInComponent(0) * 12) + cell.picker.selectedRowInComponent(1)
                    profileDelegate?.updateProfileDetails((type, inches))
                case .Weight: profileDelegate?.updateProfileDetails((type, cell.picker.selectedRowInComponent(0)))
                default: profileDelegate?.updateProfileDetails((type, cell.picker.selectedRowInComponent(0)))
                }
            }
        }
    }
}

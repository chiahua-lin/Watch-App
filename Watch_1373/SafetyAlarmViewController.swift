//
//  SafetyAlarmViewController.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum PanicAlarmState: Printable {
    case Inactive
    case Pending
    case Active

    var description: String { switch self {
        case .Inactive: return ".Inactive"
        case .Pending:  return ".Pending"
        case .Active:   return ".Active"
    }}
}

class SafetyAlarmViewController: UITableViewController {

    @IBOutlet weak var activateButtonOutline:              UIView!
    @IBOutlet weak var activateButtonMainLabel:            UILabel!
    @IBOutlet weak var activateButtonSubtitle:             UILabel!
    @IBOutlet weak var buttonTextVerticalOffsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var addContactButton:                   UIBarButtonItem!

    var alarmState: PanicAlarmState = .Inactive {
        didSet {
            func configureInterface(#color: UIColor, #textColor: UIColor, #navBarText: String, #buttonText: String, #buttonSubtitle: String?) {
                navigationController?.navigationBar.barTintColor = color
                self.title = navBarText
                activateButtonOutline.backgroundColor = color
                activateButtonSubtitle.textColor = textColor
                activateButtonMainLabel.text = buttonText
                activateButtonSubtitle.text = buttonSubtitle
                buttonTextVerticalOffsetConstraint.constant = buttonSubtitle == nil ? 0 : 10
            }

            switch alarmState {
                case .Inactive:
                    configureInterface(color: JardenColor.teal,
                        textColor: UIColor.blackColor(),
                        navBarText: "Safety",
                        buttonText: "Activate",
                        buttonSubtitle: "Push and Hold")
                    addContactButton.enabled = true

                case .Pending:
                    configureInterface(color: JardenColor.alarmPending,
                        textColor: JardenColor.alarmPending,
                        navBarText: "Alert Pending",
                        buttonText: "Push to Cancel",
                        buttonSubtitle: nil)
                    addContactButton.enabled = false

                case .Active:
                    configureInterface(color: JardenColor.alarmSent,
                        textColor: JardenColor.alarmSent,
                        navBarText: "Cancel Alert",
                        buttonText: "Push to Cancel",
                        buttonSubtitle: nil)
                    addContactButton.enabled = false
            }

            tableView.reloadData()
        }
    }

    let kRecipientData: [[(name: String, date: String, image: String, inactiveMessageState: OnelinkRecipientCellMessageState, activeMessageState: OnelinkRecipientCellMessageState)]] = [
        [
            ("Bill Nye",    "Wednesday",    "Bill_Nye.jpg", .None, .None)
        ], [
            ("Carl Sagan",  "Wednesday",    "carlsagan.jpg",  .TealNewMessage,  .RedMessageRead),
            ("Phil Plait",  "Thursday",     "PhilPlait.jpg",  .TealMessageRead, .RedMessageRead),
            ("Hank Green",  "Friday",       "HankGreen.jpg",  .RedNewMessage,   .RedNewMessage),
            ("Buzz Aldrin", "Jul 20, 1969", "BuzzAldrin.jpg", .RedMessageRead,  .RedNewMessage)
        ]
    ]

    @IBAction func activateButtonGestureRecognized(sender: UIGestureRecognizer) {
        if let sender = sender as? UILongPressGestureRecognizer where sender.state == .Began && alarmState == .Inactive {
            alarmState = .Pending
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.alarmState = .Active
            }
        }

        if let sender = sender as? UITapGestureRecognizer where alarmState == .Active {
            performSegueWithIdentifier("AlarmDeactivationPasscodePromptSegue", sender: sender)
        }
    }

    @IBAction func addButtonTapped(sender: AnyObject) {
        UIAlertController.stub(presentFrom: self, text: "Coming soon!")
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let identifier = identifier {
            switch identifier {
                case "AlarmDeactivationPasscodePromptSegue":
                    return true

                case "ShowPanicLocationSegue":
                    // Only segue if alarm is not pending or active
                    if alarmState != .Inactive {
                        return false
                    }

                    // Only segue if cell is an "incoming" panic
                    if let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
                        let inactiveMessageState = kRecipientData[indexPath.section][indexPath.row].inactiveMessageState
                        if inactiveMessageState != .TealNewMessage && inactiveMessageState != .TealMessageRead {
                            return false
                        }
                    } else {
                        assert(false, "\(__FILE__):\(__LINE__) attempting to ShowPanicLocationSegue from cell not in table view")
                        return false
                    }

                    return true

                default:
                    assert(false, "\(__FILE__):\(__LINE__) shouldPerformSegueWithIdentifier called with unknown identifier \"\(identifier)\"")
            }
        }

        assert(false, "\(__FILE__):\(__LINE__) shouldPerformSegueWithIdentifier called with nil identifier")
        return false
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AlarmDeactivationPasscodePromptSegue" {
            let destination = segue.destinationViewController as! AlertDeactivationPasscodePromptController
            destination.completionBlock = {
                self.alarmState = .Inactive
            }
        }
    }

    // MARK: UITableViewDataSource conformance

    let kViewControllerSectionAlarmRecipientRequest = 0
    let kViewControllerSectionOnelinkRecipients     = 1
    let kViewControllerSectionCount                 = 2

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kViewControllerSectionCount
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case kViewControllerSectionAlarmRecipientRequest: return "ALARM RECIPIENT REQUEST"
            case kViewControllerSectionOnelinkRecipients:     return "ONELINK RECIPIENTS"
            default:                                          return nil
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return alarmState == .Inactive ? 15 : 0
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if alarmState != .Inactive {
            return nil
        }

        let kLabelInset: CGFloat = 20.0

        let label = UILabel(frame: CGRect(x: kLabelInset, y: 0, width: CGRectGetWidth(tableView.bounds) - kLabelInset * 2, height: 15))
        label.font = UIFont.withFace(.GothamBook, size: 8.0)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 15))
        view.backgroundColor = JardenColor.sectionHeader
        view.addSubview(label)

        return view
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case kViewControllerSectionAlarmRecipientRequest: return alarmState == .Inactive ? 1 : 0
            case kViewControllerSectionOnelinkRecipients:     return 4
            default:                                          return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recipientData = kRecipientData[indexPath.section][indexPath.row]

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OnelinkRequestedRecipientCellReuseIdentifier", forIndexPath: indexPath) as! OnelinkRequestedRecipientCell

            cell.selectionStyle = .None
            cell.avatarImageView.image = UIImage(named: recipientData.image)
            cell.nameLabel.text = recipientData.name

            cell.acceptAction = { UIAlertController.stub(presentFrom: self, text: "Accepted") }
            cell.ignoreAction = { UIAlertController.stub(presentFrom: self, text: "Ignored") }

            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("OnelinkRecipientCellReuseIdentifier", forIndexPath: indexPath) as! OnelinkRecipientCell

            cell.selectionStyle = .Blue
            cell.avatarImageView.image = UIImage(named: recipientData.image)
            cell.nameLabel.text = recipientData.name

            if alarmState == .Pending {
                cell.dateLabel.text = "pending..."
                cell.messageState = .None
            } else {
                cell.dateLabel.text = recipientData.date
                cell.messageState = alarmState == .Inactive ? recipientData.inactiveMessageState : recipientData.activeMessageState
            }

            return cell
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            UIAlertController.stub(presentFrom: self, text: "Delete action received")
        }
    }

    //MARK: UITableViewDelegate conformance

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 61.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

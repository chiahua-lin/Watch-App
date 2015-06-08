//
//  JSSDashboardRootViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum DashboardNotificationKeys  {
    case Steps
    case HeartRate
    case CaloriesBurned
    case SleepMinutes
    case Distance
    case ActiveMinutes
    case SPO2
    case VO2
    case CurrentActivity
}

class DashboardRootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeNavigationBar: TimeNavigationView!

    var goalsOrderArray = [Goal.HeartRate, .Steps, .CaloriesBurned, .Sleep, .Distance, .ActiveMinutes]
    
    var currentValues: [DashboardNotificationKeys: Double] = [:]

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func editing(sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            sender.title = "Done"
            tableView.editing = true
        } else {
            sender.title = "Edit"
            tableView.editing = false
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BluetoothWatchLink.sharedInstance().registerMessageHandler(LSR_FitnessDashboardData_t.self) { message in
            // male .415, female .413
            // stride factor * height (inches) * step count = distance walked (inches)
            self.currentValues = [
                .Steps:           Double(message.currentTotalSteps),
                .HeartRate:       Double(message.currentHeartRate),
                .SPO2:            Double(message.currentSpO2Value),
                .CaloriesBurned:  Double(message.currentCaloriesBurned),
                .SleepMinutes:    Double(message.currentSleepMinutes),
                .ActiveMinutes:   Double(message.currentTotalActiveMinutes),
                .VO2:             Double(message.currentVO2Value),
                .CurrentActivity: Double(message.currentActivity),
                // Distance walked in miles for 6'0" male
                .Distance:        Double(ceil((Double(message.currentTotalSteps) * 0.415 * 72 / 63360) * 100) / 100),
            ]
            self.tableView.reloadData()
        }
    }

    //MARK: TableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalsOrderArray.count
    }

    func indexPathForGoal(goalValue: Goal) -> NSIndexPath? {
        if let row = find(goalsOrderArray, goalValue) {
            return NSIndexPath(forRow: row, inSection: 0)
        }
        return nil
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let goalCellIdentifier = "GoalCellIdentifier"
        let goalGraphCellIdentifier = "GoalGraphCellIdentifier"

        let goalForCell = goalsOrderArray[indexPath.row]

        var goalValue: Double? = nil
        switch goalForCell {
            case .Steps:          goalValue = currentValues[.Steps]
            case .HeartRate:      goalValue = currentValues[.HeartRate]
            case .CaloriesBurned: goalValue = currentValues[.CaloriesBurned]
            case .Sleep:          goalValue = currentValues[.SleepMinutes]
            case .Distance:       goalValue = currentValues[.Distance]
            case .ActiveMinutes:  goalValue = currentValues[.ActiveMinutes]
            default: break
        }
        
        let reuseIdentifier = goalForCell == .HeartRate ? goalCellIdentifier : goalGraphCellIdentifier
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! GoalsTableViewCell

        cell.updateGoalType(goalForCell)
        
        if goalForCell == .HeartRate {
            let test = cell as! HeartRateGoalsTableViewCell
            if let goalValueUnwrapped = goalValue {
                test.updateCell(goalValueUnwrapped, secondaryValue: currentValues[.SPO2])
            }
        } else {
            if let goalValueUnwrapped = goalValue {
                cell.updateGoalValue(goalValueUnwrapped)
            }

        }

        return cell
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceValue = goalsOrderArray[sourceIndexPath.row]

        goalsOrderArray.removeAtIndex(sourceIndexPath.row)
        goalsOrderArray.insert(sourceValue, atIndex:destinationIndexPath.row)
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    //MARK: TableViewDelegate methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let goal = goalsOrderArray[indexPath.row]
        var goalSegueString: String? = nil
        switch goal {
            case .Steps, .Distance, .ActiveMinutes: goalSegueString = "GoalDetailScreenSegue"
            case .CaloriesBurned:                   goalSegueString = "CaloriesDetailScreenSegue"
            case .Sleep:                            goalSegueString = "SleepDetailScreenSegue"
            case .HeartRate:                        goalSegueString = "HeartRateDetailSegue"
            default: break
        }
        if let segueName = goalSegueString {
            performSegueWithIdentifier(segueName, sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? GoalsDetailsViewController, cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
            let goal = goalsOrderArray[indexPath.row]
            let goalNavigationTitle: String
            switch goal {
                case .Steps:          goalNavigationTitle = "Steps"
                case .Distance:       goalNavigationTitle = "Distance"
                case .ActiveMinutes:  goalNavigationTitle = "Active Minutes"
                case .CaloriesBurned: goalNavigationTitle = "Calories"
                default:              goalNavigationTitle = ""
            }
            destinationViewController.metricDetailType = goal
            destinationViewController.navigationItem.title = goalNavigationTitle

        } else if let destinationViewController = segue.destinationViewController as? SleepViewController {
            destinationViewController.navigationItem.title = "Sleep"

        } else if let destinationViewController = segue.destinationViewController as? HeartRateViewController {
            destinationViewController.navigationItem.title = "HR/SpO2"
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85.0
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }

    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}

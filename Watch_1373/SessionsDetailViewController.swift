//
//  SessionsDetailViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/30/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SessionsDetailViewController: UIViewController {

    
    let activityType:Activity
    @IBOutlet weak var sessionProgressView: SessionProgressView!
    
    @IBOutlet weak var heartRateContainerView: BorderedView! {
        didSet {
            heartRateContainerView.borderColor = JardenColor.darkGrey
            heartRateContainerView.borderWidth = 1.0
            heartRateContainerView.borderSides = .Top | .Right | .Bottom
        }
    }
    @IBOutlet weak var spo2ContainerView: BorderedView! {
        didSet {
            spo2ContainerView.borderColor = JardenColor.darkGrey
            spo2ContainerView.borderWidth = 1.0
            spo2ContainerView.borderSides = .Top | .Bottom
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        activityType = Activity(rawValue:Int(arc4random_uniform(3)))!
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sessionProgressView.strokeSize = 4
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func didTapHeartRateZoneView(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("HeartRateZoneSegue", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "HeartRateZoneSegue" && segue.identifier != "SessionProgressViewSegue" {
            let metricsVC = segue.destinationViewController as! AccruedMetricsViewController
            switch segue.identifier! {
            case "Steps":
                metricsVC.goalType = Goal(rawValue: 0)
            case "Calories":
                metricsVC.goalType = Goal(rawValue: 3)
            case "Distance":
                metricsVC.goalType = Goal(rawValue: 2)
            default: return
            }
            metricsVC.activityType = self.activityType
        } else if segue.identifier == "SessionProgressViewSegue" {
            let sessionVC = segue.destinationViewController as! SessionProgressViewController
            sessionVC.segueCallback = { self.performSegueWithIdentifier("HeartRateZoneSegue", sender: self)}
        }
    }
    
//    case Steps
//    case HeartRate
//    case Distance
//    case CaloriesBurned
//    case Sleep
//    case ActiveMinutes
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

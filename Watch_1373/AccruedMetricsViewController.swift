//
//  AccruedMetricsViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/29/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum Activity: Int {
    case Running, Walking, Biking, Swimming
}

class AccruedMetricsViewController: UIViewController {

    @IBOutlet weak var metricImageView: UIImageView!
    @IBOutlet weak var firstMetricValueLabel: UILabel!
    @IBOutlet weak var secondMetricValueLabel: UILabel?
    
    var goalType:Goal?
    var activityType:Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstMetricValueLabel.text = "100"
        secondMetricValueLabel?.text = "101"
//        if let goal = goalType, image = UIImage(named:goal.imageName()) {
//            metricImageView.image = image
//        }
        populateFakeData()
        // Do any additional setup after loading the view.
    }
    
    func populateFakeData() {
        if let activity = activityType, goal = goalType {
            switch (activity, goal) {
            case (.Biking, .Steps):     firstMetricValueLabel.text = "----"
            case (_, .Steps):           firstMetricValueLabel.text = "534"
            case (_, .CaloriesBurned):  firstMetricValueLabel.text = "645"
            case (_, .Distance):        firstMetricValueLabel.text = "2.5"
            case (_, .HeartRate):       firstMetricValueLabel.text = "70"
                if let secondLabel = secondMetricValueLabel {
                    secondLabel.text = "190"
                }
            case (_, .SpO2):            firstMetricValueLabel.text = "95"
                if let secondLabel = secondMetricValueLabel {
                    secondLabel.text = "99"
                }
            default: break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

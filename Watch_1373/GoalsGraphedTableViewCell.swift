//
//  JSSGoalsGraphingTableViewCell.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/25/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

let licenseKey = "HFhx+UrhNSgr0CvMjAxNTAyMjByaGF3b3J0aEBsc3IuY29tcEHoXfnT2jopB8uH9NLHrMSMVJo8QOGYBFNHwtyyf3rWNBkkSE/+D2wmlq3XGI7WCyeylBwNMQ/EVJZOJlJHZtJ+XhEJw/7tViiOhnb0UVYYXCNgYu3QaVPZS7MPY7Tx2YusJt8tZIeLjgTys3T6p4PZR78U=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+"

class GoalsGraphedTableViewCell: GoalsTableViewCell {
    
    @IBOutlet weak var donutView: DonutView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     override func updateGoalValue(currentValue: Double?) {
        super.updateGoalValue(currentValue)
        if let goalType = currentGoalType {
            var test:Double = 0
            if let value = currentValue {
                test = value / goalType.currentGoalValue()
                
                
            }
            
            if goalType == .HeartRate {
                test = 1.0
                donutView.fillPercentage = test
                donutView.animateCircle(0.0)
            } else {
                donutView.fillPercentage = test
                donutView.animateCircle(1.0)
            }
        }
    }

}

//
//  HeartRateTableViewCell.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/10/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class HeartRateGoalsTableViewCell: GoalsTableViewCell {

    @IBOutlet weak var secondaryGoalLabel: UILabel!
    @IBOutlet weak var secondaryGoalValueLabel: UILabel!
    
    func updateCell(currentValue:Double?, secondaryValue:Double?) {
        super.updateGoalValue(currentValue)
        if let value = secondaryValue {
            secondaryGoalValueLabel.text = "\(value)%"
        } else {
            secondaryGoalValueLabel.text = "0%"
        }
        
    }
}

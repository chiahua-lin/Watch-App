//
//  JSSGoalsTableViewCell.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum Goal : Int {
    case Steps
    case HeartRate
    case Distance
    case CaloriesBurned
    case Sleep
    case ActiveMinutes
    case SpO2
    
    func imageName() -> String {
        switch self {
            case .Steps:          return "Feet_white"
            case .HeartRate:      return "Heart_white"
            case .Distance:       return "Distance_white_dashboard"
            case .CaloriesBurned: return "Fire_white"
            case .Sleep:          return "Sleep_white_dashboard"
            case .ActiveMinutes:  return "Active_white_dashboard"
            case .SpO2:           return ""
        }
    }
    
    func valueLabel() -> String {
        switch self {
            case .Steps:          return ""
            case .HeartRate:      return "BPM"
            case .Distance:       return "Miles"
            case .CaloriesBurned: return ""
            case .Sleep:          return "%"
            case .ActiveMinutes:  return "Min"
            case .SpO2:           return "%"
        }
    }
    
    func goalName() -> String {
        switch self {
            case .Steps:          return "Steps"
            case .HeartRate:      return "Heart Rate"
            case .Distance:       return "Distance"
            case .CaloriesBurned: return "Calories Burned"
            case .Sleep:          return "Sleep"
            case .ActiveMinutes:  return "Active Minutes"
            case .SpO2:           return "SpO2"
        }
    }
    
    func currentGoalValue() -> Double {
        switch self {
            case .Steps:          return 7000
            case .CaloriesBurned: return 2500
            case .Sleep:          return 100
            case .ActiveMinutes:  return 30
            case .Distance:       return 5
            default:              return 0
        }
    }
}

class GoalsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goalValueLabel: UILabel?
    @IBOutlet weak var goalLabel: UILabel?
    @IBOutlet weak var goalImageView: UIImageView?
    
    @IBOutlet weak var circleView: UIView? {
        didSet {
            if let cornerDiameter = circleView?.bounds.size.width {
                circleView?.layer.cornerRadius = cornerDiameter / 2
            }
        }
    }
    
    private var currentValue: Double = 0.0

    var currentGoalType: Goal?

    override func prepareForReuse() {
        currentGoalType = nil
        currentValue = 0.0

        updateDisplayLayout()
        super.prepareForReuse()
    }
    
    func updateGoalValue(currentValue:Double?) {
        if let value = currentValue {
            self.currentValue = value
        } else {
            self.currentValue = 0
        }
        
        updateDisplayLayout()
    }
    
    func updateGoalType(goalType:Goal) {
        currentGoalType = goalType
        updateDisplayLayout()
    }
    
    private func updateDisplayLayout() {
        if let goal = currentGoalType {
            goalImageView?.image = UIImage(named: goal.imageName())
            goalValueLabel?.text = valueLabelTextForGoal(goal)
            goalLabel?.text = goal.goalName()
        } else {
            goalImageView?.image = nil
            goalValueLabel?.text = ""
            goalLabel?.text = "No Goal"
        }
    }
    
    func valueLabelTextForGoal(goal: Goal) -> String {
        switch goal {
        case .Distance: return String(format: " %0.1f %@", currentValue, goal.valueLabel())
        default: return String(format: "%0.0f %@", currentValue, goal.valueLabel())
        }
        
    }
    
}

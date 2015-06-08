//
//  JSSTimeNavigationView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum TimeScale: Int {
    case Day
    case Week
    case Month
    case Year

    func asNSCalendarUnit() -> NSCalendarUnit {
        switch self {
            case .Day:   return .CalendarUnitMinute
            case .Week:  return .CalendarUnitDay
            case .Month: return .CalendarUnitDay
            case .Year:  return .CalendarUnitMonth
        }
    }
}

class TimeNavigationView: UIView {

    var dateManager = CurrentDateManager()
    
    var updateAction: VoidCallback
    var currentTimeScale: TimeScale = .Day
    
    let leftButton = UIButton()
    let rightButton = UIButton()
    let centerTimeLabel = UILabel()

    required init(coder aDecoder: NSCoder) {
        updateAction = {}
        
        super.init(coder: aDecoder)
        configureButtons()
        configureLabel()
    }

    func configureButtons() {

        let configurationTuple = [(leftButton, "Arrow_left_color", UIEdgeInsetsMake(11, 22, 11, 0)),
                                  (rightButton, "Arrow_right_color", UIEdgeInsetsMake(11, 0, 11, 22))]
        
        for (button, imageName, edgeInset) in configurationTuple {
            button.setImage(UIImage(named: imageName), forState: .Normal)
            button.imageEdgeInsets = edgeInset
            button.addTarget(self, action: Selector("didChangeTime:"), forControlEvents: .TouchUpInside)
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(button)
            configureButtonConstraints(button)
        }
    }

    func configureLabel() {
        centerTimeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(centerTimeLabel)
        centerTimeLabel.font = UIFont.withFace(.GothamMedium, size: 16.0)
        centerTimeLabel.textColor = JardenColor.darkGrey

        self.addConstraint(NSLayoutConstraint(item: centerTimeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: centerTimeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

        updateDateLabel()
    }

    func configureButtonConstraints(button: UIButton) {
        var layoutDirectionOption:NSLayoutFormatOptions = .DirectionLeadingToTrailing

        if button == rightButton {
            layoutDirectionOption = .DirectionRightToLeft
        }

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-insetPadding-[button(buttonWidth)]", options: layoutDirectionOption, metrics: ["insetPadding" : self.bounds.size.width * 0.02, "buttonWidth" : 44], views: ["button" : button]))

        self.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    func didChangeTime(sender: UIButton) {
        switch currentTimeScale {
            case .Day:   dateManager.offsetDateByDateComponents(NSDateComponents(day:   sender == rightButton ? 1 : -1))
            case .Week:  dateManager.offsetDateByDateComponents(NSDateComponents(day:   sender == rightButton ? 7 : -7))
            case .Month: dateManager.offsetDateByDateComponents(NSDateComponents(month: sender == rightButton ? 1 : -1))
            case .Year:  dateManager.offsetDateByDateComponents(NSDateComponents(year:  sender == rightButton ? 1 : -1))
        }
        
        updateAction()
        updateDateLabel()
    }

    func updateDateLabel() {
        centerTimeLabel.text = NSDateUtilities.dateLabelForDate(dateManager.currentDate)
        rightButton.enabled = !NSCalendar.currentCalendar().isDateInToday(dateManager.currentDate)
    }

}

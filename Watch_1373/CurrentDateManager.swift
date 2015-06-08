//
//  JSSCurrentDateManager.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

public struct CurrentDateManager {

    public let currentDate: NSDate
    
    public init(currentDate: NSDate = NSDate()) {
        self.currentDate = currentDate
    }
    
    public mutating func offsetDateByDateComponents(dateComponents: NSDateComponents) {
        if let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(0)) {
            self = CurrentDateManager(currentDate: date.earlierDate(NSDate()))
        } else {
            assert(false, "\(__FILE__):\(__LINE__) dateByAddingComponents failed unexpectedly")
        }
    }
    
    public mutating func resetDateToToday() {
        self = CurrentDateManager()
    }

    public func isCurrentDateYesterday() -> Bool {
        return NSCalendar.currentCalendar().isDateInYesterday(currentDate)
    }

    public func isCurrentDateToday() -> Bool {
        return NSCalendar.currentCalendar().isDateInToday(currentDate)
    }

    func beginningOfDateFromRelativeDate() -> NSDate {
        return currentDate.dateByGoingBackToBeginningOfDay()
    }

    func endOfDateFromRelativeDate() -> NSDate {
        return currentDate.dateByAdvancingToEndOfDay()
    }

}

//
//  FoundationExtensions.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

public extension NSDateComponents {

    public convenience init(day: Int) {
        self.init()
        self.day = day
    }

    public convenience init(month: Int) {
        self.init()
        self.month = month
    }

    public convenience init(year: Int) {
        self.init()
        self.year = year
    }

}

extension NSCalendar {

    func dateForBeginningOfWeek(date:NSDate) -> NSDate? {
        var beginningOfWeek:NSDate? = nil
        var interval:NSTimeInterval = 0
        let succeed = rangeOfUnit(NSCalendarUnit.CalendarUnitWeekOfMonth, startDate: &beginningOfWeek, interval: &interval, forDate:date)
        
        if !succeed {
            println("Unable to find beginnning of week")
        }
        
        return beginningOfWeek
    }
    
    func dateForEndOfWeek(date:NSDate) -> NSDate? {
        if let beginningOfWeek = dateForBeginningOfWeek(date) {
            let test = dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 6, toDate: beginningOfWeek, options: NSCalendarOptions(0))
            return test
        }
        
        return nil
    }

    func isDateInThisWeek(date: NSDate) -> Bool {
        return isDate(date, equalToDate: NSDate(), toUnitGranularity: NSCalendarUnit.CalendarUnitWeekOfYear)
    }

}

extension NSDate {

    func dateByGoingBackToBeginningOfDay() -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: self, options: NSCalendarOptions(0))!
    }

    func dateByAdvancingToEndOfDay() -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(23, minute: 59, second: 59, ofDate: self, options: NSCalendarOptions(0))!
    }

}

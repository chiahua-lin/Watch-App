//
//  NSDateUtilities.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/9/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

enum NSDateUtilities {

    static func ordinalSuffixForDayOfMonth(date: NSDate) -> String {
        switch NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitDay, fromDate: date) {
            case 1, 21, 31: return "st"
            case 2, 22:     return "nd"
            case 3, 23:     return "rd"
            default:        return "th"
        }
    }

    /**
      * Returns date in format "September 25th, 1990"
      */
    static func dateLabelForDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let monthDay = dateFormatter.stringFromDate(date)
        let ordinalSuffix = NSDateUtilities.ordinalSuffixForDayOfMonth(date)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.stringFromDate(date)

        return "\(monthDay)\(ordinalSuffix), \(year)"
    }

}
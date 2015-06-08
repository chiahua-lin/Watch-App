//
//  CurrentDateManagerTests.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/20/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit
import XCTest
import Watch_1373

class CurrentDateManagerTests: XCTestCase {

    func testOffsetDateByDateComponents() {
        var dateManager = CurrentDateManager()
        dateManager.offsetDateByDateComponents(NSDateComponents(day: -7)) // Go back a week
        let originalDate = dateManager.currentDate

        let calendar = NSCalendar.currentCalendar()
        let originalDateMinusOne = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: originalDate, options: NSCalendarOptions.allZeros)!
        let originalDatePlusOne  = calendar.dateByAddingUnit(.CalendarUnitDay, value: 1, toDate: originalDate, options: NSCalendarOptions.allZeros)!

        // Date = -1
        dateManager.offsetDateByDateComponents(NSDateComponents(day: -1))
        XCTAssertNotEqual(originalDate, dateManager.currentDate)
        XCTAssertEqual(originalDateMinusOne, dateManager.currentDate)

        // Date = +1
        dateManager.offsetDateByDateComponents(NSDateComponents(day: 2))
        XCTAssertNotEqual(originalDate, dateManager.currentDate)
        XCTAssertEqual(originalDatePlusOne, dateManager.currentDate)

        // Date = 0
        dateManager.offsetDateByDateComponents(NSDateComponents(day: -1))
        XCTAssertEqual(originalDate, dateManager.currentDate)
    }

    func testOffsetDateByDateComponentsCanNotGoIntoFuture() {
        var dateManager = CurrentDateManager()
        let originalDate = dateManager.currentDate
        let calendar = NSCalendar.currentCalendar()
        let originalDateMinusOne = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: originalDate, options: NSCalendarOptions.allZeros)!

        // Date = -1
        dateManager.offsetDateByDateComponents(NSDateComponents(day: -1))
        XCTAssertNotEqual(originalDate, dateManager.currentDate)
        XCTAssertTrue(dateManager.isCurrentDateYesterday())
        XCTAssertEqual(originalDateMinusOne, dateManager.currentDate)

        // Date = +1
        dateManager.offsetDateByDateComponents(NSDateComponents(day: 2))
        XCTAssertTrue(dateManager.isCurrentDateToday(), "Date should have pinned to current date")
    }

    func testIsCurrentDateToday() {
        var dateManager = CurrentDateManager()
        XCTAssertTrue(dateManager.isCurrentDateToday())

        dateManager.offsetDateByDateComponents(NSDateComponents(day: -1))
        XCTAssertFalse(dateManager.isCurrentDateToday())

        dateManager.resetDateToToday()
        XCTAssertTrue(dateManager.isCurrentDateToday())
    }

    func testIsCurrentDateYesterday() {
        var dateManager = CurrentDateManager()
        XCTAssertFalse(dateManager.isCurrentDateYesterday())

        dateManager.offsetDateByDateComponents(NSDateComponents(day: -1))
        XCTAssertTrue(dateManager.isCurrentDateYesterday())
    }

}

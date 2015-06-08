//
//  LSRPackableStructTest.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import XCTest
import Watch_1373

/* Extending a struct defined in TestPackableStruct.h, since #pragma pack isn't available in Swift */
extension TestPackable : LSRPackableStruct {
    public static let unpackedFieldLength = [ 8, 16, 32, 64 ]
    public static let packedFieldLength = [ 2, 2, 2, 2 ]
}

/* This could be made generic to allow multiple sizes but stored properties are not yet allowed on generic types */
struct TestInspectable : LSRPackableStruct {
    static let unpackedFieldLength = [ 8 ]
    static let packedFieldLength = unpackedFieldLength

    let u8: UInt8
}

class LSRPackableStructTest: XCTestCase {

    func testSimplePack() {
        let simplePackInput = TestPackable(u8: 0b00, u16: 0b01, u32: 0b10, u64: 0b11)
        let simplePacked = LSRPackableStructUtilities.pack(simplePackInput)
        let inspectableUnpacked = LSRPackableStructUtilities.unpack(simplePacked, TestInspectable.self)
        XCTAssertEqual(inspectableUnpacked.u8, 0b11100100) // Bytes are re-ordered due to little endian, ugh
    }

    func testSimpleUnpack() {
        let simplePacked = LSRPackableStructUtilities.pack(TestInspectable(u8: 0b11100100))
        let simpleUnpacked = LSRPackableStructUtilities.unpack(simplePacked, TestPackable.self)
        XCTAssertEqual(simpleUnpacked.u8, 0b00)
        XCTAssertEqual(simpleUnpacked.u16, 0b01)
        XCTAssertEqual(simpleUnpacked.u32, 0b10)
        XCTAssertEqual(simpleUnpacked.u64, 0b11)
    }

    func testFitnessDashboardRanges() {
        self.measureBlock() {
            for currentTotalSteps in [0, 1, 16383] {
                for currentHeartRate in [0, 1, 255] {
                    for currentCaloriesBurned in [0, 1, 8191] {
                        for currentSleepMinutes in [0, 1, 2047] {
                            for currentTotalActiveMinutes in [0, 1, 2047] {
                                for currentSpO2Value in [0, 1, 127] {
                                    for currentVO2Value in [0, 1, 127] {
                                        for currentActivity in [0, 1, 7] {
                                            let fitnessDashboardMessage = LSR_FitnessDashboardData_t(
                                                currentTotalSteps: UInt32(currentTotalSteps),
                                                currentHeartRate: UInt8(currentHeartRate),
                                                currentCaloriesBurned: UInt16(currentCaloriesBurned),
                                                currentSleepMinutes: UInt16(currentSleepMinutes),
                                                currentTotalActiveMinutes: UInt16(currentTotalActiveMinutes),
                                                currentSpO2Value: UInt8(currentSpO2Value),
                                                currentVO2Value: UInt8(currentVO2Value),
                                                currentActivity: UInt8(currentActivity))
                                            let packedUnpacked = LSRPackableStructUtilities.unpack(LSRPackableStructUtilities.pack(fitnessDashboardMessage), LSR_FitnessDashboardData_t.self)
                                            XCTAssertEqual(packedUnpacked.currentTotalSteps, UInt32(currentTotalSteps), "total steps")
                                            XCTAssertEqual(packedUnpacked.currentHeartRate, UInt8(currentHeartRate), "heart rate")
                                            XCTAssertEqual(packedUnpacked.currentCaloriesBurned, UInt16(currentCaloriesBurned), "calories burned")
                                            XCTAssertEqual(packedUnpacked.currentSleepMinutes, UInt16(currentSleepMinutes), "sleep minutes")
                                            XCTAssertEqual(packedUnpacked.currentTotalActiveMinutes, UInt16(currentTotalActiveMinutes), "active minutes")
                                            XCTAssertEqual(packedUnpacked.currentSpO2Value, UInt8(currentSpO2Value), "spo2")
                                            XCTAssertEqual(packedUnpacked.currentVO2Value, UInt8(currentVO2Value), "vo2")
                                            XCTAssertEqual(packedUnpacked.currentActivity, UInt8(currentActivity), "activity")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testTimeSync() {
        let unpacked = TimeSyncMsg_t(date: NSDate())
        let packed = LSRPackableStructUtilities.pack(unpacked)
        let reunpacked = LSRPackableStructUtilities.unpack(packed, TimeSyncMsg_t.self)

        XCTAssertEqual(unpacked.header.msgCode, reunpacked.header.msgCode)
        XCTAssertEqual(unpacked.date, reunpacked.date)
    }

}

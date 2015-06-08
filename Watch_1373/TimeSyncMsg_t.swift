//
//  TimeSyncMsg_t.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/5/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

extension TimeSyncMsg_t : LSRPackableStruct {
    public static let packedFieldLength = [sizeof(LSR_MsgHeader_t) * 8, 32]
    public static let unpackedFieldLength = packedFieldLength
}

extension TimeSyncMsg_t {
    private static func timeZoneOffset() -> NSTimeInterval {
        let timeZone = NSTimeZone.localTimeZone()
        return NSTimeInterval(timeZone.secondsFromGMT)
    }

    public var date: NSDate {
        set(newDate) {
            secTime = UInt32(newDate.timeIntervalSince1970 + TimeSyncMsg_t.timeZoneOffset())
        }
        get {
            return NSDate(timeIntervalSince1970: NSTimeInterval(secTime) - TimeSyncMsg_t.timeZoneOffset())
        }
    }
}

extension TimeSyncMsg_t {
    public init(date: NSDate) {
        header = LSR_MsgHeader_t(msgSize: sizeof(TimeSyncMsg_t), msgCode: TIME_SYNC_MSG_CODE)
        secTime = 0
        self.date = date
    }
}

extension TimeSyncMsg_t : Printable {
    public var description: String {
        return "TimeSyncMsg_t<date: \(date)>"
    }
}

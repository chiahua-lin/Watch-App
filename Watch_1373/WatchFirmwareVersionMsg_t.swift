//
//  WatchFirmwareVersionMsg_t.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

extension WatchFirmwareVersionMsg_t : LSRPackableStruct {
    public static let packedFieldLength = [ sizeof(LSR_MsgHeader_t) * 8, 8, 8, 8 ]
    public static let unpackedFieldLength = packedFieldLength
}

extension WatchFirmwareVersionMsg_t : Printable {
    public var description: String {
        return "WatchFirmwareVersionMsg_t<major: \(major), minor: \(minor), build: \(build)>"
    }
}

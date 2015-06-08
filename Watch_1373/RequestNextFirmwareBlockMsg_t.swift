//
//  RequestNextFirmwareBlockMsg_t.swift
//  Watch_1373
//
//  Created by Joe Bonniwell on 5/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

extension RequestNextFirmwareBlockMsg_t : LSRPackableStruct {
    public static let packedFieldLength = [sizeof(LSR_MsgHeader_t) * 8, 16]
    public static let unpackedFieldLength = packedFieldLength
}

extension RequestNextFirmwareBlockMsg_t : Printable {
    public var description: String {
        return "RequestNextFirmwareBlockMsg_t<blockSize: \(blockSize)>"
    }
}
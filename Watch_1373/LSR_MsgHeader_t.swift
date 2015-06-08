//
//  LSR_MsgHeader_t.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/5/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

extension LSR_MsgHeader_t : LSRPackableStruct {
    public static let packedFieldLength = [ 8, 8, 8, 8, 8, 8 ]
    public static let unpackedFieldLength = packedFieldLength
}

extension LSR_MsgHeader_t {
    init(msgSize: Int, msgCode: _MSG_CODES_) {
        self.msgSize = LSR_MsgSize_t(msgSize)
        self.msgCode = LSR_MsgCode_t(msgCode.value)
        self.rxID = LSR_MsgID_t(WATCH_HOST_NODE_ID.value)
        self.txID = LSR_MsgID_t(WATCH_MOBILE_APP_NODE_ID.value)
        self.options = 0
        self.rsvd = 0
    }
}

extension LSR_MsgHeader_t : Printable {
    public var description: String {
        return "LSRMsgHeader<msgSize: \(msgSize), msgCode: \(msgCode), rxID: \(rxID), txID: \(txID)>"
    }
}

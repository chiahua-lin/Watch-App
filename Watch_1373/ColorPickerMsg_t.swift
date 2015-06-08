//
//  ColorPickerMsg_t.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

extension ColorPickerMsg_t : LSRPackableStruct {
    public static let packedFieldLength = [ 48, 32 ]
    public static let unpackedFieldLength = packedFieldLength
}

extension ColorPickerMsg_t {
    init(color: UIColor) {
        header = LSR_MsgHeader_t(msgSize: sizeof(ColorPickerMsg_t), msgCode: COLOR_PICKER_MSG_CODE)

        var red:   CGFloat = 0
        var blue:  CGFloat = 0
        var green: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: nil)

        self.color = UInt32(red * 255) << 16 | UInt32(green * 255) << 8 | UInt32(blue * 255)
    }
}

//
//  LSR_FitnessData_t.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

extension LSR_FitnessData_t : LSRPackableStruct {
    public static let packedFieldLength = [ 14, 8, 13, 11, 11, 7, 7, 3, 32 ]
    public static let unpackedFieldLength = [ 32, 8, 16, 16, 16, 8, 8, 8, 32 ]
}

extension LSR_FitnessData_t : Printable {
    public var description: String {
        return "LSR_FitnessData_t<\(reflectionDescribe(self))>"
    }
}

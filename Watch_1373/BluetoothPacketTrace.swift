//
//  BluetoothPacketTrace.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

enum BluetoothPacketDirection: Printable {
    case PeripheralToCentral
    case CentralToPeripheral

    var description: String {
        switch self {
            case .PeripheralToCentral: return "P->C"
            case .CentralToPeripheral: return "C->P"
        }
    }
}

enum BluetoothPacketTrace {
    static func trace(data: NSData, direction: BluetoothPacketDirection, label: String? = nil) {
        let trailingLabel = label.map { " (\($0))" } ?? ""
        LSRLog(.BluetoothPacketTrace, .Trace, "\(direction) \(data)\(trailingLabel)")
    }
}

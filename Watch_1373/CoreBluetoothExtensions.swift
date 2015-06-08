//
//  CoreBluetoothExtensions.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/13/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import CoreBluetooth

extension CBCentralManagerState: Printable {

    public var description: String { switch self {
        case .Unknown:      return ".Unknown"
        case .Resetting:    return ".Resetting"
        case .Unsupported:  return ".Unsupported"
        case .Unauthorized: return ".Unauthorized"
        case .PoweredOff:   return ".PoweredOff"
        case .PoweredOn:    return ".PoweredOn"
    }}

}

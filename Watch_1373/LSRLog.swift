//
//  LSRLog.swift
//  Watch_1373
//
//  Created by William LaFrance on 5/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import Foundation

// If logs are printed to stdout, certain log domains can be muted.
let kMutedDomains: [LSRLoggerDomain] = [/*.BluetoothWatchLink,*/ .Exosite/*, .BluetoothStateMachine*/]

enum LSRLoggerDomain {
    case Initialization
    case BluetoothWatchLink
    case BluetoothStateMachine
    case BluetoothPacketTrace
    case UserInterface
    case Development
    case Exosite

    var tag: String {
        switch self {
            case .Initialization:        return "INIT"
            case .BluetoothWatchLink:    return "BWL"
            case .BluetoothStateMachine: return "BSM"
            case .BluetoothPacketTrace:  return "BPT"
            case .UserInterface:         return "UI"
            case .Development:           return "DEV"
            case .Exosite:               return "EXO"
        }
    }
}

enum LSRLoggerLevel: Int32 {
    case Error   = 0
    case Warning = 1
    case Info    = 2
    case Trace   = 4
}

func LSRLog(domain: LSRLoggerDomain, level: LSRLoggerLevel, message: String, filename: String = __FILE__, lineNumber: Int = __LINE__, functionName: String = __FUNCTION__) {
    if NSUserDefaults.standardUserDefaults().boolForKey("network_logging") {
        _LSRLogImpl(filename, Int32(lineNumber), functionName, domain.tag, level.rawValue, message)
    } else {
        if nil == find(kMutedDomains, domain) {
            dispatch_async(dispatch_get_main_queue()) {
                println("[\(domain.tag)] \(message)")
            }
        }
    }
}

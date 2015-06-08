//
//  JardenColor.swift
//  Watch_1373
//
//  Created by William LaFrance on 3/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

extension UIColor {
    
    private class func solid(red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
    }
}

enum JardenColor {
    static let lightGrey = UIColor.solid(168, 169, 168)
    static let darkGrey  = UIColor.solid(88, 89, 91)
    static let red       = UIColor.solid(207, 32, 46)
    static let blue      = UIColor.solid(0, 113, 206)
    static let yellow    = UIColor.solid(255, 164, 0)
    static let teal      = UIColor.solid(38, 202, 211)
    static let green     = UIColor.solid(119, 188, 31)
    static let cream     = UIColor.solid(241, 241, 242)
    
    static let sectionHeader      = UIColor.solid(239, 239, 240)
    static let alarmPending       = UIColor.solid(248, 162, 49)
    static let alarmSent          = UIColor.solid(164, 34, 49)
    
    static let teeterTotterBar    = UIColor.solid(136, 137, 145)
    static let teeterTotterBall   = UIColor.solid(230, 231, 232)
    
    static let heartRateGradient1 = UIColor.solid(98, 78, 159)
    static let heartRateGradient2 = UIColor.solid(206, 32, 47)
    static let heartRateGradient3 = UIColor.solid(120, 188, 67)
    static let heartRateGradient4 = UIColor.solid(79, 169, 217)
}

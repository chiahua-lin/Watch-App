//
//  CoreGraphicsExtensions.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/10/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import QuartzCore

extension CALayer {
    var borderUIColor: UIColor? {
        get {
            return UIColor(CGColor: borderColor)
        }
        set(color) {
            borderColor = color?.CGColor
        }
    }
}

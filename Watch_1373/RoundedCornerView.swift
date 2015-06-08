//
//  RoundedCornerView.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/8/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundedCornerView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0                    { didSet { setNeedsDisplay() } }
    @IBInspectable var firstColor:   UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
    @IBInspectable var secondColor:  UIColor? = nil                 { didSet { setNeedsDisplay() } }
    var roundedCorners: UIRectCorner = nil                          { didSet { setNeedsDisplay() } }

    override func awakeFromNib() {
        backgroundColor = UIColor.clearColor()
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundedCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        CGContextAddPath(context, path.CGPath)

        if let secondColor = secondColor { // draw gradient
            CGContextClip(context)
            let gradient = CGGradientCreateWithColors(nil, [firstColor.CGColor, secondColor.CGColor], nil)
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(CGRectGetWidth(bounds), 0), 0)
        } else { // non-gradient
            CGContextSetFillColorWithColor(context, firstColor.CGColor)
            CGContextFillPath(context)
        }
    }

}

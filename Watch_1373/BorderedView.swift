//
//  LSRBorderedView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Robert Haworth. All rights reserved.
//

import UIKit

enum Shape: Int {
    case Rectangle
    case Circle
    case Triangle
}

enum BorderStyle: Int {
    case BorderStyleSolid = 1
    case BorderStyleDashed
    case BorderStyleDotted
}

//Nasty implementation of NS_Options for Swift.
struct Border : RawOptionSetType, BooleanType {
    
    //Detailed protocol implementation of RawOptionSetType which is a collection of protocols listed here -> _RawOptionSetType, BitwiseOperationsType, NilLiteralConvertible
    typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    init(rawValue value: UInt) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: Border { return self(0) }
    static func fromMask(raw: UInt) -> Border { return self(raw) }
    var rawValue: UInt { return self.value }
    
    //Implementation of BooleanType protocol
    var boolValue:Bool { get { return self.value != 0 }}
    
    static var None: Border { return self(0) }
    static var Left: Border { return Border(1 << 0) }
    static var Right: Border { return Border(1 << 1) }
    static var Bottom: Border { return Border(1 << 2) }
    static var Top: Border { return Border(1 << 3) }
}

class BorderedView: UIView {
    var shape:Shape
    var borderSides:Border
    var style:BorderStyle
    var borderWidth:CGFloat
    var borderColor:UIColor
    var isSelected:Bool
    

    required init(coder aDecoder: NSCoder) {
        borderWidth = 1.0
        style = .BorderStyleSolid
        shape = .Rectangle
        borderSides = .None
        borderColor = JardenColor.lightGrey
        isSelected = false
        
        super.init(coder: aDecoder)
    }
    
    func initWithBorder(borders:Border) {
        
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetFillColorWithColor(context, backgroundColor?.CGColor)
        
        var borderRect = rect;
        
        switch style {
        
            case .BorderStyleDotted:
                borderRect = CGRectInset(rect, self.borderWidth * 0.5, self.borderWidth * 0.5)
                CGContextSetLineCap(context, kCGLineCapRound)
                CGContextSetLineWidth(context, self.borderWidth)
                var spacingArray:[CGFloat] = [0, self.borderWidth * 2]
                CGContextSetLineDash(context, 0.0, spacingArray, 2)
            
            case .BorderStyleDashed:
                CGContextSetLineWidth(context, self.borderWidth)
                var spacingArray:[CGFloat] = [5, 3]
                CGContextSetLineDash(context, 1, spacingArray, 2)

            default:
                break
        }
        
        switch shape {
            case .Rectangle:
                if borderSides & .Top {
                    CGContextMoveToPoint(context, CGRectGetMinX(borderRect), CGRectGetMinY(borderRect))
                    CGContextAddLineToPoint(context, CGRectGetMaxX(borderRect), CGRectGetMinY(borderRect))
                    CGContextStrokePath(context)
                }
                
                if borderSides & .Bottom {
                    CGContextMoveToPoint(context, CGRectGetMinX(borderRect), CGRectGetMaxY(borderRect))
                    CGContextAddLineToPoint(context, CGRectGetMaxX(borderRect), CGRectGetMaxY(borderRect))
                    CGContextStrokePath(context)
                }
                
                if borderSides & .Left {
                    CGContextMoveToPoint(context, CGRectGetMinX(borderRect), CGRectGetMinY(borderRect))
                    CGContextAddLineToPoint(context, CGRectGetMinX(borderRect), CGRectGetMaxY(borderRect))
                    CGContextStrokePath(context)
                }
                
                if borderSides & .Right {
                    CGContextMoveToPoint(context, CGRectGetMaxX(borderRect), CGRectGetMinY(borderRect))
                    CGContextAddLineToPoint(context, CGRectGetMaxX(borderRect), CGRectGetMaxY(borderRect))
                    CGContextStrokePath(context)
                }
            
            case .Circle:
                if CGRectEqualToRect(rect, borderRect) {
                    borderRect = CGRectInset(rect, self.borderWidth * 0.5, self.borderWidth * 0.5)
                }
                
                if isSelected {
                    CGContextSetFillColorWithColor(context, JardenColor.teal.CGColor)
                } else {
                    CGContextSetFillColorWithColor(context, backgroundColor?.CGColor)
                }
                
                CGContextSetLineWidth(context, self.borderWidth)
                CGContextFillEllipseInRect(context, borderRect)
                CGContextStrokeEllipseInRect(context, borderRect)
                CGContextFillPath(context)
            
            default:
                break
        }
        
    }
    

}

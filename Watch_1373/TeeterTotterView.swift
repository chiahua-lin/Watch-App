//
//  TeeterTotterView.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/23/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class TeeterTotterView: UIView {

    private let kTriangleHeightPercent:      CGFloat =  0.2
    private let kTriangleBottomWidthPercent: CGFloat =  0.15
    private let kTriangleTopWidthPercent:    CGFloat =  0.1
    private let kBaseboardHeight:            CGFloat =  5.0
    private let kBallSize:                   CGFloat = 40.0
    private let kBallInset:                  CGFloat = 15.0

    private var baseboard:  CAShapeLayer?
    private var crossbar:   CALayer?
    private var topSection: CALayer?
    private var leftText:   CATextLayer?
    private var rightText:  CATextLayer?

    var leftLabel:  String? = "441"
    var rightLabel: String? = "1000"
    var font: UIFont = UIFont.withFace(.GothamBook, size: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private final func _CGPathMoveToPoint(path: CGMutablePath!, _ m: UnsafePointer<CGAffineTransform>)(_ x: CGFloat, _ y: CGFloat) {
        CGPathMoveToPoint(path, m, x, y)
    }

    private final func _CGPathAddLineToPoint(path: CGMutablePath!, _ m: UnsafePointer<CGAffineTransform>)(_ x: CGFloat, _ y: CGFloat) {
        CGPathAddLineToPoint(path, m, x, y)
    }

    private final func setup() {
        let path = CGPathCreateMutable()

        let tHeight      = CGRectGetHeight(bounds) * kTriangleHeightPercent
        let tTopWidth    = CGRectGetWidth(bounds)  * kTriangleTopWidthPercent * 0.5
        let tBottomWidth = CGRectGetWidth(bounds)  * kTriangleBottomWidthPercent * 0.5

        let move = _CGPathMoveToPoint(path, nil)
        let line = _CGPathAddLineToPoint(path, nil)

        move(0,                                           CGRectGetHeight(bounds) - kBaseboardHeight)           // Baseboard Top Left
        line(CGRectGetWidth(bounds) * 0.5 - tBottomWidth, CGRectGetHeight(bounds) - kBaseboardHeight)           // Triangle Bottom Left
        line(CGRectGetWidth(bounds) * 0.5 - tTopWidth,    CGRectGetHeight(bounds) - kBaseboardHeight - tHeight) // Triangle Top Left
        line(CGRectGetWidth(bounds) * 0.5 + tTopWidth,    CGRectGetHeight(bounds) - kBaseboardHeight - tHeight) // Triangle Top Right
        line(CGRectGetWidth(bounds) * 0.5 + tBottomWidth, CGRectGetHeight(bounds) - kBaseboardHeight)           // Triangle Bottom Right
        line(CGRectGetWidth(bounds),                      CGRectGetHeight(bounds) - kBaseboardHeight)           // Baseboard Top Right
        line(CGRectGetWidth(bounds),                      CGRectGetHeight(bounds))                              // Baseboard Bottom Right
        line(0,                                           CGRectGetHeight(bounds))                              // Baseboard Bottom Left
        line(0,                                           CGRectGetHeight(bounds) - kBaseboardHeight)           // Baseboard Top Left

        baseboard = CAShapeLayer()
        baseboard!.path = path
        baseboard!.fillColor = JardenColor.teeterTotterBar.CGColor
        layer.addSublayer(baseboard)

        topSection = CALayer()
        topSection!.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(bounds), height: CGRectGetHeight(bounds) - kBaseboardHeight - tHeight)
        layer.addSublayer(topSection)

        crossbar = CALayer()
        crossbar!.frame = CGRect(x: 0, y: CGRectGetHeight(topSection!.bounds) - kBaseboardHeight, width: CGRectGetWidth(topSection!.bounds), height: kBaseboardHeight)
        crossbar!.backgroundColor = JardenColor.teeterTotterBar.CGColor
        topSection?.addSublayer(crossbar)

        func makeBall(rect: CGRect) -> CAShapeLayer {
            let ball = CAShapeLayer()
            ball.path = UIBezierPath(ovalInRect: rect).CGPath
            ball.fillColor = JardenColor.teeterTotterBall.CGColor
            topSection!.addSublayer(ball)
            return ball
        }

        func makeTextLayer(rect: CGRect, text: String?) -> CATextLayer {
            let textLayer = CATextLayer()
            textLayer.string = NSAttributedString(string: text ?? "", attributes: [ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blackColor() ])
            textLayer.frame = CGRectInset(rect, 0, (CGRectGetHeight(rect) - font.lineHeight) / 2.0) // vertically center
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.contentsScale = UIScreen.mainScreen().scale
            topSection!.addSublayer(textLayer)
            return textLayer
        }

        let ballTop        = CGRectGetHeight(topSection!.bounds) - kBaseboardHeight - kBallSize
        let leftBallFrame  = CGRect(x:                                      kBallInset,             y: ballTop, width: kBallSize, height: kBallSize)
        let rightBallFrame = CGRect(x: CGRectGetWidth(topSection!.bounds) - kBallInset - kBallSize, y: ballTop, width: kBallSize, height: kBallSize)

        let leftBall  = makeBall(leftBallFrame)
        let rightBall = makeBall(rightBallFrame)
        leftText  = makeTextLayer(leftBallFrame, leftLabel)
        rightText = makeTextLayer(rightBallFrame, rightLabel)
        
        topSection!.transform = CATransform3DRotate(topSection!.transform, -0.12, 0, 0, 1)
    }
    
}

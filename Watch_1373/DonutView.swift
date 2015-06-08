//
//  MyDrawingView.swift
//  GravitySandbox
//
//  Created by Robert Haworth on 4/20/15.
//  Copyright (c) 2015 Robert Haworth. All rights reserved.
//

import UIKit

class DonutView: UIView {

    var circleLayer:CAShapeLayer?
    var backgroundCircle:CAShapeLayer?
    
    var fillPercentage = 0.0
    var lineThickness:CGFloat = 0.1


    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        circleLayer = generateShapeLayer(true)
        backgroundCircle = generateShapeLayer(false)
        layer.addSublayer(backgroundCircle)
        layer.addSublayer(circleLayer)
    }
    
    func generateShapeLayer(animated:Bool) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let offset = frame.size.width * lineThickness
        
        let newPoint = CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
        
        let circlePath = UIBezierPath(arcCenter: newPoint, radius: (bounds.size.width / 2) - (offset / 2), startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2 * 3), clockwise: true)
        
        
        layer.path = circlePath.CGPath
        
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.redColor().CGColor
        layer.lineWidth = frame.size.width * lineThickness
        layer.strokeEnd = 0.0
        if !animated {
            layer.strokeEnd = 1.0
            layer.lineWidth = layer.lineWidth / 4
        }
        layer.lineCap = kCALineCapRound
        return layer
    }
    
    override func layoutSubviews() {
        
        updateShapePaths()
        super.layoutSubviews()
    }
    
    func updateShapePaths() {
        let offset = frame.size.width * lineThickness
        let newPoint = convertPoint(center, fromView: superview)
        let newPath = UIBezierPath(arcCenter: newPoint, radius: (frame.size.width / 2) - (offset / 2), startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI_2 * 3), clockwise: true)
        self.backgroundCircle!.path = newPath.CGPath
        self.circleLayer!.path = newPath.CGPath
    }
//
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        updateShapePaths()
//    }
    
    func animateCircle(duration:NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        animation.fromValue = circleLayer?.strokeEnd
        animation.toValue = fillPercentage
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer?.strokeEnd = CGFloat(fillPercentage)
        circleLayer?.strokeColor = colorForPercentage(fillPercentage).CGColor
        backgroundCircle?.strokeColor = self.circleLayer?.strokeColor
        circleLayer?.addAnimation(animation, forKey: "animateCircle")
    }
    
    func colorForPercentage(fillPercentage:Double) -> UIColor {
        if fillPercentage >= 1.0 {
            return JardenColor.teal
        } else if fillPercentage >= 0.4 {
            return JardenColor.yellow
        } else {
            return JardenColor.red
        }
    }

}

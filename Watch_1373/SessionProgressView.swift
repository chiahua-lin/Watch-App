//
//  SessionProgressView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 5/12/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SessionProgressView: UIView {
    
    var strokeSize:CGFloat {
        didSet {
            strokePadding = strokeSize / 2
        }
    }
    
    //This value is dynamically determined when AL calls layoutSubviews. This is determined to be bounds.height / 2 / 11
    //The equation takes into account the rule that 1/2 of our height MUST equal 8 line widths and 6 line spaces. Line spaces are defined as being 1/2 line width.
    var strokePadding:CGFloat = 0
    
    //This is an arbitrary starting arc angle. The arc values are inverted due to the UIBezierPath being drawn backwards. (Eg. 120 is really 240 if you're drawing the math using M_PI as your starting base and you label counter clockwise)
    let startingArcAngle:Double = 120
    
    
    //Center Point is dynamically determined when AL calls layoutSubviews. This is determined to be 1/2 the bounds.height
    var centerPoint:CGPoint = CGPointZero
    
    //This is an array where you can place the forward-drawing, solid layers that will be used for animations.
    var foregroundLayers:[CAShapeLayer] = []
    
    required init(coder aDecoder: NSCoder) {
        strokeSize = 0
        super.init(coder: aDecoder)
    }
    
    
    //After each AL cycle, layoutSubviews() will be called giving us the ability to re-draw the view dynamically. The only limitation is that the height of this view MUST be greater than 44 pixels. If it is not, the view is unable to be drawn/laid out.
    //Currently there is boiler plate code to handle an animation after a delay of 2 seconds for demo purposes.
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size.height < 44.0 {
            assert(false, "Failed to draw due to height size restriction")
        }
        centerPoint = CGPoint(x: (bounds.size.width - (bounds.size.height / 2)), y: bounds.size.height / 2)
        let lineWidth = (bounds.size.height / 2) / 11
        
        strokeSize = floor(lineWidth)
        rebuildView()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.animateForegroundLayers()
        }
    }
    
    
    //Once all dynamic values ave been attained, we remove all previous sublayers. Generate all background layers, generate all foreground layers, and add them to the view.layer layer.
    func rebuildView() {
        if self.layer.sublayers != nil {
            self.layer.sublayers.removeAll(keepCapacity: true)
        }
        let backgroundLayers = createLayers(0.4)
        
        for layer in backgroundLayers {
            self.layer.addSublayer(layer)
        }
        
        foregroundLayers = createLayers(1.0)
        
        for layer in foregroundLayers {
            self.layer.addSublayer(layer)
        }
    }
    
    //This is the basic demo animation being used to currently give a 'visualization' of how this will work. In the future this should be replaced to be backed by actual information and ratio'ed percentages
    func animateForegroundLayers() {
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.duration = 2.0
        animation.fromValue = 0.0
        animation.toValue = 0.7
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        for layer in foregroundLayers {
            animation.fromValue = layer.strokeEnd
            animation.toValue = Double(arc4random_uniform(100)) / 100.0
            layer.addAnimation(animation, forKey: "animation")
        }
    }
    
    //This is a method to create the basic 4 line layers and return them in an array. If you pass alpha of 1.0 to this, it will trigger the UIBezierPath to be inverted so that it draws in from the left side instead of the right, as well as will set the strokeEnd to 0.0 so that it may be animated into being drawn.
    func createLayers(alpha:CGFloat) -> [CAShapeLayer] {
        let outerPath = outerLinePath(reversed: alpha == 1.0 ? true:false)
        let innerPath = innerOuterPath(reversed: alpha == 1.0 ? true:false)
        let innerLowerPath = innerLowerLinePath(reversed: alpha == 1.0 ? true:false)
        let outerLowerPath = outerLowerLinePath(reversed: alpha == 1.0 ? true:false)
    
        
        let outerUpperLayer = CAShapeLayer()!
        
        outerUpperLayer.fillColor = UIColor.clearColor().CGColor
        outerUpperLayer.path = outerPath.CGPath
        outerUpperLayer.strokeColor = UIColor(red: 218.0/255, green: 0.0/255, blue: 123.0/255, alpha: alpha).CGColor
        outerUpperLayer.lineCap = kCALineCapRound
        outerUpperLayer.lineWidth = strokeSize
        
        let innerOuterLayer = CAShapeLayer()!
        innerOuterLayer.fillColor = UIColor.clearColor().CGColor
        innerOuterLayer.path = innerPath.CGPath
        innerOuterLayer.strokeColor = UIColor(red: 118/255.0, green: 36/255.0, blue: 130/255.0, alpha: alpha).CGColor
        innerOuterLayer.lineCap = kCALineCapRound
        innerOuterLayer.lineWidth = strokeSize
        
        let innerLowerLayer = CAShapeLayer()!
        innerLowerLayer.fillColor = UIColor.clearColor().CGColor
        innerLowerLayer.path = innerLowerPath.CGPath
        innerLowerLayer.strokeColor = UIColor(red: 194/255.0, green: 0/255.0, blue: 33/255.0, alpha: alpha).CGColor
        innerLowerLayer.lineCap = kCALineCapRound
        innerLowerLayer.lineWidth = strokeSize
        
        let outerLowerLayer = CAShapeLayer()!
        outerLowerLayer.fillColor = UIColor.clearColor().CGColor
        outerLowerLayer.path = outerLowerPath.CGPath
        outerLowerLayer.strokeColor = UIColor(red: 62/255.0, green: 167/255.0, blue: 216/255.0, alpha: alpha).CGColor
        outerLowerLayer.lineCap = kCALineCapRound
        outerLowerLayer.lineWidth = strokeSize
        //testLayer.path
        let array = [outerUpperLayer, innerOuterLayer, innerLowerLayer, outerLowerLayer]
        if alpha == 1.0 {
            for layer in array {
                //Optimization setting for drawing CAShapeLayers. Removes requirement for CoreAnimation to track and blend the alpha channels to make pretty.
                layer.opaque = true
                layer.strokeEnd = 0.0
            }
        }
        
        return array
    }
    
    
    //This is the function that generates the outerLinePath
    func outerLinePath(#reversed:Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        let radius = radiusForLine(1)
        var startingAngle =  CGFloat(startingArcAngle / 180 * M_PI)
        var endingAngle = endingAngleMath(1)
        
        var endPoint = makePoint(endingAngle, radius: radius, center: centerPoint)
        
        path.addArcWithCenter(centerPoint, radius:radius , startAngle:startingAngle, endAngle: endingAngle, clockwise: false)
        
        path.addLineToPoint(CGPointMake(0, endPoint.y))
        if reversed {
            return path.bezierPathByReversingPath()
        } else {
            return path
        }
    }
    
    //This is the function that generates the innerOuterLinePath
    func innerOuterPath(#reversed:Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        let radius = radiusForLine(2)
        let startingAngle = CGFloat(startingArcAngle / 180 * M_PI)
        let endingAngle = endingAngleMath(2)
        
        path.addArcWithCenter(centerPoint, radius: radius, startAngle:startingAngle , endAngle: endingAngle, clockwise: false)
        
        
        var endPoint = makePoint(endingAngle, radius: radius, center: centerPoint)
        path.addLineToPoint(CGPointMake(0, endPoint.y))
        
        if reversed {
            return path.bezierPathByReversingPath()
        } else {
            return path
        }
    }
    
    //This is the function that generates the innerLowerLinePath
    func innerLowerLinePath(#reversed:Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        let radius = radiusForLine(3)
        let startingAngle = CGFloat(startingArcAngle / 180 * M_PI)
        let endingAngle = endingAngleMath(3)
        
        var endPoint = makePoint(endingAngle, radius: radius, center: centerPoint)
        
        path.addArcWithCenter(centerPoint, radius: radius, startAngle: startingAngle, endAngle: endingAngle, clockwise: false)
        
        path.addLineToPoint(CGPointMake(0, endPoint.y))
        
        if reversed {
            return path.bezierPathByReversingPath()
        } else {
            return path
        }
    }
    
    //This is the function that generates the outerLowerLinePath
    func outerLowerLinePath(#reversed:Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        let startingAngle = CGFloat(startingArcAngle / 180 * M_PI)
        
        let radius = radiusForLine(4)
        
        let endingAngle = endingAngleMath(4)
        var endPoint = makePoint(endingAngle, radius: radius, center: centerPoint)
        
        path.addArcWithCenter(centerPoint, radius: radius, startAngle: startingAngle, endAngle: endingAngle, clockwise: false)
        
        path.addLineToPoint(CGPointMake(0, endPoint.y))
        
        if reversed {
            return path.bezierPathByReversingPath()
        } else {
            return path
        }
    }
    
    //This is where we calculate the ending angle in radians based off the line that you are currently attempting to draw.
    //Much Triginometry was involved.
    func endingAngleMath(lineNumber:CGFloat) -> CGFloat {
        let radius = radiusForLine(lineNumber)
        var firstHalf:CGFloat = 0
        switch lineNumber {
        case 1: firstHalf = 2 * (strokeSize + strokePadding)
        case 2: firstHalf = (strokeSize + strokePadding)
        case 3: firstHalf = CGFloat(M_PI)
        case 4: firstHalf = (-strokeSize - strokePadding)
        default: break
        }
        
        switch lineNumber {
        case 3: return CGFloat(M_PI)
        default: return CGFloat(M_PI) + asin(firstHalf / radius)
        }
    }
    
    //This will determine the radius to be used for each line.
    func radiusForLine(lineNumber:CGFloat) -> CGFloat {
        return (bounds.size.height / 2) - (strokeSize * (lineNumber - 1) + strokePadding * (lineNumber - 1) + strokeSize / 2)
    }
    
    //This will determine a point on a circle given it's radius, center point, and the degree in radians you want to represent as a point.
    func makePoint(radian:CGFloat, radius:CGFloat, center:CGPoint) -> CGPoint{
        var point = CGPointZero
        point.x = (center.x + radius * cos(radian))
        point.y = (center.y + radius * sin(radian))
        
        
        return point
    }
    
}

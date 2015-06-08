//
//  ImageDrawingView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/30/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ImageDrawingView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        drawCanvas2(frame: rect)
    }
    
    func drawCanvas2(#frame: CGRect) {
        //// Color Declarations
        let fillColor = JardenColor.red
        
        
        //// Subframes
        let group2: CGRect = CGRectMake(frame.minX - 0.2, frame.minY + 0.3, frame.width + 0.2, frame.height - 0.1)
        
        
        //// Group 2
        //// Group 3
        //// Group 4
        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(group2.minX + 0.12112 * group2.width, group2.minY + 0.00000 * group2.height))
        bezierPath.addCurveToPoint(CGPointMake(group2.minX + 0.75755 * group2.width, group2.minY + 1.00000 * group2.height), controlPoint1: CGPointMake(group2.minX + 0.61360 * group2.width, group2.minY + 0.35922 * group2.height), controlPoint2: CGPointMake(group2.minX + -0.80322 * group2.width, group2.minY + 0.92880 * group2.height))
        bezierPath.addCurveToPoint(CGPointMake(group2.minX + 0.78786 * group2.width, group2.minY + 0.28803 * group2.height), controlPoint1: CGPointMake(group2.minX + -0.21225 * group2.width, group2.minY + 0.76375 * group2.height), controlPoint2: CGPointMake(group2.minX + 1.49248 * group2.width, group2.minY + 0.65696 * group2.height))
        bezierPath.addCurveToPoint(CGPointMake(group2.minX + 0.45449 * group2.width, group2.minY + 0.61812 * group2.height), controlPoint1: CGPointMake(group2.minX + 0.82574 * group2.width, group2.minY + 0.46278 * group2.height), controlPoint2: CGPointMake(group2.minX + 0.74240 * group2.width, group2.minY + 0.58252 * group2.height))
        bezierPath.addCurveToPoint(CGPointMake(group2.minX + 0.12112 * group2.width, group2.minY + 0.00000 * group2.height), controlPoint1: CGPointMake(group2.minX + 0.66663 * group2.width, group2.minY + 0.35599 * group2.height), controlPoint2: CGPointMake(group2.minX + 0.44691 * group2.width, group2.minY + 0.16828 * group2.height))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;
        
        bezierPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        bezierPath.fill()
        
        
        
        
        //// Group 5
        //// Bezier 2 Drawing
        var bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPointMake(group2.minX + 0.68178 * group2.width, group2.minY + 0.92880 * group2.height))
        bezier2Path.addCurveToPoint(CGPointMake(group2.minX + 1.00000 * group2.width, group2.minY + 0.68932 * group2.height), controlPoint1: CGPointMake(group2.minX + 0.96969 * group2.width, group2.minY + 0.88997 * group2.height), controlPoint2: CGPointMake(group2.minX + 0.63632 * group2.width, group2.minY + 0.72816 * group2.height))
        bezier2Path.addCurveToPoint(CGPointMake(group2.minX + 0.68178 * group2.width, group2.minY + 0.92880 * group2.height), controlPoint1: CGPointMake(group2.minX + 0.57571 * group2.width, group2.minY + 0.69579 * group2.height), controlPoint2: CGPointMake(group2.minX + 0.50752 * group2.width, group2.minY + 0.82524 * group2.height))
        bezier2Path.closePath()
        bezier2Path.miterLimit = 4;
        
        bezier2Path.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        bezier2Path.fill()
    }
    

}

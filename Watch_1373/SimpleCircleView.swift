//
//  SimpleCircleView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/16/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SimpleCircleView: UIView {
    
    var selected = false {
        didSet {
            if selected {
                UIView.animateWithDuration(0.1) {
                    self.backgroundColor = JardenColor.lightGrey
                    return
                }
            } else {
                UIView.animateWithDuration(0.1) {
                    self.backgroundColor = UIColor.clearColor()
                    return
                }
            }
        }
    }
    
    func test() {
        layer.borderWidth = 0.5
        layer.borderColor = JardenColor.lightGrey.CGColor
        backgroundColor = UIColor.clearColor()
        layer.cornerRadius = bounds.size.width / 2
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        test()
    }
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

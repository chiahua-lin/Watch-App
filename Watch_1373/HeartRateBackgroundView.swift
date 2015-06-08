//
//  HeartRateBackgroundView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/13/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class HeartRateBackgroundView: UIView {
    
    var lineThickness:CGFloat = 0.1
    
    override var backgroundColor:UIColor? {
        didSet {
            if backgroundColor == UIColor.clearColor() {
                backgroundColor = oldValue
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = bounds.size.width * lineThickness
        layer.borderColor = JardenColor.teal.CGColor
        layer.cornerRadius = bounds.size.width / 2
    }

}

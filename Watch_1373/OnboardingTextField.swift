//
//  OnboardingTextField.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/17/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class OnboardingTextField: UITextField {
    
    var textFieldType:ScreenType?
    
    var triggerError:VoidCallback?
    var resolveError:VoidCallback?
    
    var errored = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        leftViewMode = UITextFieldViewMode.Always
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = JardenColor.lightGrey.CGColor
    }
    
    
    func imageNameForLeftView(imageName:String) {
        setImageWithName(imageName)
    }
    
//    func triggerError(imageName:String) {
//        setImageWithName(imageName)
//        layer.borderColor = JardenColor.teal.CGColor
//    }
    
    func setImageWithName(name:String) {
        
        if leftView != nil {
            let imageView = leftView as! UIImageView
            imageView.image = UIImage(named: name)
        } else {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.bounds = CGRectMake(0, 0, 35, 35)
            imageView.contentMode = .ScaleAspectFit
            leftViewMode = .Always
            leftView = imageView
        }
    }
    
//    func resolveError(imageName:String) {
//        setImageWithName(imageName)
//        layer.borderColor = JardenColor.lightGrey.CGColor
//        
//    }
    
    func updatePlaceholderAttributedText(text:String) {
        let font = UIFont.withFace(.GothamBook, size: UIFont.systemFontSize())
        attributedPlaceholder = NSAttributedString(string: attributedPlaceholder!.string, attributes: [NSForegroundColorAttributeName : JardenColor.teal, NSFontAttributeName : font])
    }
    
//    override func drawPlaceholderInRect(rect: CGRect) {
//        JardenColor.teal.setFill()
//        let string = NSString(string: self.placeholder!)
//        if let attributes = self.attributedPlaceholder?.attributesAtIndex(1, effectiveRange: nil) {
//            attributes[NSForegroundColorAttributeName] = JardenColor.teal
//            string.drawInRect(rect, withAttributes: attributes)
//        }
//    }
}

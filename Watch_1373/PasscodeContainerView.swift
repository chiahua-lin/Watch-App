//
//  PasscodeContainerView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/17/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class PasscodeContainerView: UIView, UIKeyInput, UITextInputTraits {
    
    var text:String = ""
    var keyboardType:UIKeyboardType = .PhonePad
    var completionBlock:VoidCallback? = nil
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func deleteBackward() {
        if text.endIndex != text.startIndex {
            text.removeAtIndex(text.endIndex.predecessor())
            println("new text: \(text)")
        } else {
            println("I've hit a wall!")
        }
        
        completionBlock?()
    }
    
    func insertText(newText: String) {
        text = text.stringByAppendingString(newText)
        println("new text: \(text)")
        completionBlock?()
    }
    
    func hasText() -> Bool {
        return count(text) != 0
    }
}
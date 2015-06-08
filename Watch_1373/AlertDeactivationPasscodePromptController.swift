//
//  AlertDeactivationPasscodePromptController.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/15/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class AlertDeactivationPasscodePromptController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passcodeTextfield: UITextField!

    let kPasscode = "1111"

    var completionBlock: VoidCallback?

    override func viewWillAppear(animated: Bool) {
        passcodeTextfield.becomeFirstResponder()
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)

        if newString == kPasscode {
            println("Passcodes match")

            navigationController?.popViewControllerAnimated(true)
            completionBlock?()
        }

        return true
    }
}

//
//  EnterPasscodeViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/23/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

protocol PasscodeTextFieldDelegate: NSObjectProtocol {
    func textFieldDidDelete(sender:UITextField)
}

class PasscodeTextField: UITextField, UIKeyInput {
    
    var myDelegate:PasscodeTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if let del = myDelegate {
            if del.respondsToSelector(Selector("textFieldDidDelete:")) {
                del.textFieldDidDelete(self)
            }
        }
    }
}

import UIKit

//PasscodeTextFieldDelegate, UITextFieldDelegate
class EnterPasscodeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet var passcodeViews: [SimpleCircleView]!
    @IBOutlet weak var passcodeContainerView: PasscodeContainerView!
    
    var localFieldChangeNotification:NSObjectProtocol?
    var isReenterScreen = false
//    var temporaryPasscode:NSString = ""
    var firstPasscode:NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeContainerView.completionBlock = { [unowned self] in
            self.updatePasscodeViews()
        }
        passcodeContainerView.becomeFirstResponder()
        
        if isReenterScreen {
            topLabel.text = "Re-enter your passcode"
        }
    }
    
    func updatePasscodeViews() {
        let numberOfCharacters = count(passcodeContainerView.text)
        
        if numberOfCharacters == 4 {
            if !isReenterScreen {
                segueToNewViewController()
            } else {
                if firstPasscode == passcodeContainerView.text {
                    //valid
                    println("Matched!")
                    performSegueWithIdentifier("ProfileSegue", sender: self)
                } else {
                    navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        for (index, simpleView) in enumerate(passcodeViews) {
            if index <= numberOfCharacters - 1 {
                simpleView.selected = true
            } else {
                simpleView.selected = false
            }
        }
        
        if !errorLabel.hidden {
            errorLabel.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isReenterScreen {
            navItem.title = "Confirm Passcode"
            
        } else {
            navItem.title = "Enter Passcode"
        }
        
//        if isReenterScreen && firstPasscode != "" {
//            navigationController?.popViewControllerAnimated(true)
//        }
        
        if passcodeContainerView.text != "" {
            firstPasscode = ""
            passcodeContainerView.text = ""
            updatePasscodeViews()
            errorLabel.hidden = false
            passcodeContainerView.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueToNewViewController() {
        if let newViewController = storyboard?.instantiateViewControllerWithIdentifier("PasscodeViewController") as? EnterPasscodeViewController {
            newViewController.isReenterScreen = true
            newViewController.firstPasscode = passcodeContainerView.text
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
//    func returnPasscodeFromTextField() -> String {
//        return self.firstField.text.stringByAppendingString(self.secondField.text).stringByAppendingString(self.thirdField.text).stringByAppendingString(self.fourthField.text)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

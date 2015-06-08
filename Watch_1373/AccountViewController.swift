//
//  CreateAccountViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/17/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum ScreenType {
    case login, create
}

class AccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: OnboardingTextField! {
        didSet {
            
            emailTextField.resolveError = {
                self.emailTextField.setImageWithName("SVG-uncategorized_lock_grey")
                self.emailTextField.layer.borderColor = JardenColor.lightGrey.CGColor
                self.emailTextField.errored = false
            }
            
            emailTextField.triggerError = {
                self.emailTextField.setImageWithName("SVG-uncategorized_lock_teal")
                self.emailTextField.layer.borderColor = JardenColor.teal.CGColor
                self.emailTextField.errored = true
            }
            
            emailTextField.resolveError?()
        }
    }
    @IBOutlet weak var passwordTextField: OnboardingTextField! {
        didSet {
            
            passwordTextField.resolveError = {
                self.passwordTextField.setImageWithName("SVG-uncategorized_lock_grey")
                self.passwordTextField.layer.borderColor = JardenColor.lightGrey.CGColor
                self.passwordTextField.errored = false
            }
            
            passwordTextField.triggerError = {
                self.passwordTextField.setImageWithName("SVG-uncategorized_lock_teal")
                self.passwordTextField.layer.borderColor = JardenColor.teal.CGColor
                self.passwordTextField.errored = true
            }
            
            passwordTextField.resolveError?()
        }
    }
    @IBOutlet weak var confirmPasswordTextField: OnboardingTextField! {
        didSet {
//            confirmPasswordTextField.imageNameForLeftView("SVG-uncategorized_lock_grey")
//            confirmPasswordTextField.layer.borderColor = JardenColor.lightGrey.CGColor
            
            confirmPasswordTextField.resolveError = {
                self.confirmPasswordTextField.setImageWithName("SVG-uncategorized_lock_grey")
                self.confirmPasswordTextField.layer.borderColor = JardenColor.lightGrey.CGColor
                self.confirmPasswordTextField.errored = false
            }
            
            confirmPasswordTextField.triggerError = {
                self.confirmPasswordTextField.setImageWithName("SVG-uncategorized_lock_teal")
                self.confirmPasswordTextField.layer.borderColor = JardenColor.teal.CGColor
                self.confirmPasswordTextField.errored = true
            }
            
            confirmPasswordTextField.resolveError?()
        }
    }
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var attributedTextView: UITextView!

    @IBOutlet weak var forgotPasswordLabel: UIButton!
    @IBOutlet weak var accountActionButton: UIButton!
    
    @IBOutlet weak var onelinkLogoImageView: UIImageView!
    @IBOutlet weak var screenSwitchLabel: UILabel!
    @IBOutlet weak var screenSwitchButton: UIButton!
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var forgotPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordHeightConstraint: NSLayoutConstraint!
    
    var screenType:ScreenType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        buildAttributedTextLabel()
        attributedTextView.selectable = false
//        let exosite = ExositeController()
//        exosite.createAccount()
        // Do any additional setup after loading the view.
    }
    
    func configureLabels() {
        
        emailTextField.textFieldType = screenType!
        passwordTextField.textFieldType = screenType!
        confirmPasswordTextField.textFieldType = screenType!
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        
        switch screenType! {
        case .login:
            attributedTextView.hidden = true
            forgotPasswordLabel.hidden = false
            termsOfServiceLabel.hidden = true
            
            accountActionButton.setTitle("Sign In", forState: .Normal)
            screenSwitchLabel.text = "Don't have an account?"
            screenSwitchButton.setTitle("Sign Up", forState: .Normal)
            
            confirmPasswordHeightConstraint.constant = 0
            forgotPasswordHeightConstraint.constant = 34
            
        case .create:
            attributedTextView.hidden = false
            termsOfServiceLabel.hidden = false
            forgotPasswordLabel.hidden = true

            accountActionButton.setTitle("Sign Up", forState: .Normal)
            screenSwitchLabel.text = "Already have an account?"
            screenSwitchButton.setTitle("Sign In", forState: .Normal)
            
            confirmPasswordHeightConstraint.constant = 40
            forgotPasswordHeightConstraint.constant = 0
            
        }
        
        forgotPasswordLabel.layoutIfNeeded()
    }

    @IBAction func screenTypeChangeButton(sender: UIButton) {
        switch screenType! {
        case .create:
            screenType = .login
        case .login:
            screenType = .create
        }
        
        let viewArray = [onelinkLogoImageView, emailTextField, passwordTextField, confirmPasswordTextField, attributedTextView, termsOfServiceLabel, forgotPasswordLabel, accountActionButton, screenSwitchButton, screenSwitchLabel]
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            for testView in viewArray {
                testView.alpha = 0.0
            }
            
            //hide error image and label when user swaps screens if they are visible.
            if !self.errorLabel.hidden {
                self.errorLabel.hidden = true
            }
            if !self.errorImage.hidden {
                self.errorImage.hidden = true
            }
            
            }, completion: { (completion) -> Void in
                if completion {
                    self.reloadScreen()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        for testView in viewArray {
                            testView.alpha = 1.0
                        }
                })
            }
        })
    }
    
    @IBAction func didTapAttributedLabel(sender: UITapGestureRecognizer) {
        let textView = attributedTextView
        
        let layoutManager = textView.layoutManager
        
        var location = sender.locationInView(textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < textView.textStorage.length && characterIndex != 0 && characterIndex != (textView.textStorage.length) {
            let value = textView.attributedText.attributesAtIndex(characterIndex, effectiveRange:nil)
            
            if let identifier = value["identifier"] as? String {
                performSegueWithIdentifier("WebURLSegue", sender: self)
                if identifier == "termsOfService" {
                    UIAlertController.stub(presentFrom: self, text: "Clicked terms!")
                    return
                }
                
                if identifier == "privacyPolicy" {
                    UIAlertController.stub(presentFrom: self, text: "Clicked privacy!")
                    return
                }
            }
            UIAlertController.stub(presentFrom: self, text: "Clicked and!")
        }
    }

    func reloadScreen() {
        configureLabels()
    }
    
    @IBAction func unwindToSignInScreen(segue:UIStoryboardSegue) {
        screenType = .login
        self.reloadScreen()
    }
    
    @IBAction func unwindToSignUpScreen(segue:UIStoryboardSegue) {
        screenType = .create
        self.reloadScreen()
    }
    
    func buildAttributedTextLabel() {
        let font = UIFont.withFace(.GothamBook, size: 16.0)
        let test = [NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle]
        let attributes = ["testTag" : true, NSFontAttributeName : font, NSForegroundColorAttributeName : JardenColor.teal, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
        var attributedString = NSMutableAttributedString(string:"Terms of Service", attributes: ["identifier" : "termsOfService", NSFontAttributeName : font, NSForegroundColorAttributeName : JardenColor.teal, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue])
        attributedString.appendAttributedString(NSAttributedString(string:" and ", attributes: [NSFontAttributeName : font]))
        let privacyPolicy = NSAttributedString(string: "Privacy Policy", attributes: ["identifier" : "privacyPolicy", NSFontAttributeName : font, NSForegroundColorAttributeName : JardenColor.teal, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue])
        attributedString.appendAttributedString(privacyPolicy)
        
        attributedTextView.attributedText = attributedString
    }
    
    @IBAction func accountActionButtonPressed(sender: UIButton) {
        switch screenType! {
        case .login:
            performSegueWithIdentifier("PairingSegue", sender: self)
        case .create:
            performSegueWithIdentifier("VerificationSegue", sender: self)
        }
    }

    func registerAccount() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch (screenType!) {
        case .login:
            if textField == emailTextField { passwordTextField.becomeFirstResponder() }
            if textField == passwordTextField { passwordTextField.resignFirstResponder() }
        case .create:
            if textField == emailTextField { passwordTextField.becomeFirstResponder() }
            if textField == passwordTextField { confirmPasswordTextField.becomeFirstResponder() }
            if textField == confirmPasswordTextField {
                confirmPasswordTextField.resignFirstResponder()
            }
        default: break
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == confirmPasswordTextField {
            let comparisonString:String
            if range.length == 0 {
                comparisonString = textField.text.stringByAppendingString(string)
            } else {
                let weirdStringConversion = textField.text as NSString
                comparisonString = weirdStringConversion.substringToIndex(range.location) as String
            }
            confirmPasswordMatch(comparisonString)
            
        } else if textField == passwordTextField {
            if confirmPasswordTextField.text == "" {
                clearError()
            }
        } else if textField == emailTextField {
            let comparisonString:String
            if range.length == 0 {
                comparisonString = textField.text.stringByAppendingString(string)
            } else {
                let weirdStringConversion = textField.text as NSString
                comparisonString = weirdStringConversion.substringToIndex(range.location) as String
            }
            let emailPredicateText = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
            
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [emailPredicateText])
            
            if emailPredicate.evaluateWithObject(comparisonString) {
                clearError()
            } else {
                
                handleError(errorString: "Email address not valid", failedTextFields: [emailTextField])
            }
            
        }
        return true
    }
    
    func doesPasswordsMatch(newPassword password:String) -> Bool{
        return passwordTextField.text == password
    }
    
    //Use this function to visually represent an error on this screen. Pass in each textField you want to activate "error state" for. Error state is configured in the didSet.
    func handleError(errorString string:String, failedTextFields textFields:[OnboardingTextField]) {
        errorLabel.hidden = false
        errorImage.hidden = false
        errorLabel.text = string
        for textField in textFields {
            textField.triggerError?()
        }
    }
    
    //Use this function to attempt a clear-all of any errors visibly being displayed currently.
    func clearError() {
        errorLabel.hidden = true
        errorImage.hidden = true
//        errorLabel.text = ""
        if emailTextField.errored { emailTextField.resolveError?() }
        if passwordTextField.errored { passwordTextField.resolveError?() }
        if confirmPasswordTextField.errored { confirmPasswordTextField.resolveError?() }
    }
    
    //This method will do a pattern match on both password textFields then prompt an error on both textFields if they do not match. This should not be used on login state as it will not work and would be an invalid representation.
    func confirmPasswordMatch(string:String) {
        if doesPasswordsMatch(newPassword: string) && screenType != .login {
            clearError()
        } else {
            handleError(errorString: "Passwords do not match!", failedTextFields: [passwordTextField, confirmPasswordTextField])
        }
    }
}

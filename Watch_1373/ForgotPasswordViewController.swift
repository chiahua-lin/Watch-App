//
//  ForgotPasswordViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/18/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: OnboardingTextField! {
        didSet {
            emailTextField.imageNameForLeftView("SVG-uncategorized_contact_grey")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ForgotPasswordCompletedSegue" {
            let destination = segue.destinationViewController as! ForgotPasswordCompleteViewController
            
            destination.email = emailTextField.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

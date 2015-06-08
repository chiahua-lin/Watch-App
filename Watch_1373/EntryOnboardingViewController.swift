//
//  EntryOnboardingViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/1/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class EntryOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToRoot(segue:UIStoryboardSegue) {
//        if segue.sourceViewController.isKindOfClass(CreateAccountViewController) {
//            performSegueWithIdentifier("CreateAccountSegue", sender: self)
//        } else {
//            performSegueWithIdentifier("LoginAccountSegue", sender: self)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! AccountViewController
        if segue.identifier == "LoginSegue" {
            
            destinationController.screenType = .login
        } else {
            destinationController.screenType = .create
        }
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

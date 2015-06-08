//
//  ContactMessageSentViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/1/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ContactMessageSentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Normal)
            if let appDelegate = UIApplication.sharedApplication().delegate {
                let storyboard = UIStoryboard(name: "RootTabBar", bundle: nil)
                if let viewController = storyboard.instantiateInitialViewController() as? UIViewController {
                    if let window = appDelegate.window {
                        window?.rootViewController = viewController
                        window?.makeKeyAndVisible()
                    }
                }
            }
//            appDelegate?.window.
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

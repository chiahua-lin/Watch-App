//
//  SessionProgressViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 5/13/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SessionProgressViewController: UIViewController {

    var segueCallback:(() -> Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func triggerHeartRateZoneSegue(sender: UITapGestureRecognizer) {
        if let callback = segueCallback {
            callback()
        }
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

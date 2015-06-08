//
//  VerificationEmailPromptViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class VerificationEmailPromptViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
//        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
//        navigationController?.navigationBar.tintColor = JardenColor.teal
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : JardenColor.teal]
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : JardenColor.teal], forState: .Normal)
//        navigationController?.setNavigationBarHidden(false, animated: false)
        continueButton.layer.cornerRadius = continueButton.bounds.size.width / 2
//        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        if isMovingFromParentViewController() {
//            navigationController?.setNavigationBarHidden(true, animated: false)
//        }
    }

}

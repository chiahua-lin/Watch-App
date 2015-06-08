//
//  SetPasscodePrimerViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/20/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SetPasscodePrimerViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        continueButton.layer.cornerRadius = continueButton.bounds.size.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  ForgotPasswordCompleteViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/18/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ForgotPasswordCompleteViewController: UIViewController {
    
    var email:String = ""

    @IBOutlet weak var sentEmailLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton! {
        didSet {
            returnButton.layer.cornerRadius = returnButton.bounds.size.width / 2
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont.withFace(.GothamBook, size: 16.0)
        let boldFont = UIFont.withFace(.GothamBold, size: 16.0)
        let attributedText = NSMutableAttributedString(string: "We sent a link to reset your password to your ", attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : JardenColor.lightGrey])
        attributedText.appendAttributedString(NSAttributedString(string:email, attributes: [NSFontAttributeName : boldFont, NSForegroundColorAttributeName : JardenColor.darkGrey]))
        attributedText.appendAttributedString(NSAttributedString(string: " email.", attributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : JardenColor.lightGrey]))
        sentEmailLabel.attributedText = attributedText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

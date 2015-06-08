//
//  ContactTableViewCell.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/23/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
            profileImageView.layer.borderColor = JardenColor.darkGrey.CGColor
            profileImageView.layer.borderWidth = 2.0
            profileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBOutlet weak var maleButton: UIButton! {
        didSet {
            maleButton.layer.borderWidth = 1.0
            maleButton.layer.borderColor = JardenColor.lightGrey.CGColor
            maleButton.layer.cornerRadius = 3
            maleButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var femaleButton: UIButton! {
        didSet {
            femaleButton.layer.borderWidth = 1.0
            femaleButton.layer.borderColor = JardenColor.lightGrey.CGColor
            femaleButton.layer.cornerRadius = 3
            femaleButton.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didSelectGender(sender: UIButton) {
        
        if sender == maleButton {
            if sender.selected {
//                sender.selected = false
//                sender.backgroundColor = UIColor.whiteColor()
            } else {
                sender.selected = true
                sender.backgroundColor = JardenColor.teal
                if femaleButton.selected {
                    femaleButton.selected = false
                    femaleButton.backgroundColor = UIColor.whiteColor()
                }
            }
        } else {
            if sender.selected {
//                sender.selected = false
//                sender.backgroundColor = UIColor.whiteColor()
            } else {
                sender.selected = true
                sender.backgroundColor = JardenColor.teal
                
                if maleButton.selected {
                    maleButton.selected = false
                    maleButton.backgroundColor = UIColor.whiteColor()
                }
            }
        }
    }
}

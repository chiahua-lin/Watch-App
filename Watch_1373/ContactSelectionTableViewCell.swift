//
//  ContactSelectionTableViewCell.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/30/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ContactSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var selectionCircle: UIView! {
        didSet {
            selectionCircle.layer.borderWidth = 1
            selectionCircle.layer.cornerRadius = selectionCircle.bounds.width / 2
            selectionCircle.layer.borderColor = JardenColor.darkGrey.CGColor
            selectionCircle.hidden = true
        }
    }
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView! {
        didSet {
            contactImage.layer.cornerRadius = contactImage.bounds.size.width / 2
            contactImage.layer.borderColor = JardenColor.darkGrey.CGColor
            contactImage.layer.borderWidth = 2.0
            contactImage.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectionCircle.backgroundColor = JardenColor.darkGrey
        } else {
            selectionCircle.backgroundColor = UIColor.whiteColor()
        }
        // Configure the view for the selected state
    }
    
    func showSelectionCircle(show:Bool) {
        selectionCircle.hidden = !show
    }
}

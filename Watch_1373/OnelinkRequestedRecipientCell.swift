//
//  OnelinkRequestedRecipientCell.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/15/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class OnelinkRequestedRecipientCell: UITableViewCell {

    @IBOutlet weak var avatarBorderView: UIView!

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.clipsToBounds = true
        }
    }

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    var acceptAction: VoidCallback?
    var ignoreAction: VoidCallback?

    @IBAction func acceptButtonTapped(sender: AnyObject) {
        acceptAction?()
    }

    @IBAction func ignoreButtonTapped(sender: AnyObject) {
        ignoreAction?()
    }

}

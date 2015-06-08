//
//  OnelinkRecipientCell.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/10/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum OnelinkRecipientCellMessageState {
    case None
    case TealNewMessage
    case TealMessageRead
    case RedNewMessage
    case RedMessageRead

    var label: String? { switch self {
        case .None:                             return nil
        case .TealNewMessage,  .RedNewMessage:  return "NEW MESSAGE"
        case .TealMessageRead, .RedMessageRead: return "MESSAGE READ"
    }}

    var backgroundColor: UIColor { switch self {
        case .None, .TealMessageRead, .RedMessageRead: return UIColor.whiteColor()
        case .TealNewMessage:                          return JardenColor.teal
        case .RedNewMessage:                           return JardenColor.alarmSent
    }}

    var accentColor: UIColor { switch self {
        case .None:                             return UIColor.whiteColor()
        case .TealNewMessage, .TealMessageRead: return JardenColor.teal
        case .RedNewMessage,  .RedMessageRead:  return JardenColor.alarmSent
    }}
}

class OnelinkRecipientCell: UITableViewCell {

    @IBOutlet weak var avatarBorderView: UIView!

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.clipsToBounds = true
        }
    }

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var accessoryLabel: UILabel!

    var messageState: OnelinkRecipientCellMessageState = .None {
        didSet {
            displayMessageState(text: messageState.label, backgroundColor: messageState.backgroundColor, accentColor: messageState.accentColor)
        }
    }

    private final func displayMessageState(#text: String?, backgroundColor: UIColor, accentColor: UIColor) {
        accessoryLabel.text = text
        accessoryLabel.backgroundColor = backgroundColor
        accessoryLabel.textColor = backgroundColor == UIColor.whiteColor() ? accentColor : UIColor.whiteColor()
        accessoryLabel.layer.borderColor = accentColor.CGColor
    }

}

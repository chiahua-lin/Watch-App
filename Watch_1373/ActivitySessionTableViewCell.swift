//
//  ActivitySessionTableViewCell.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/4/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class ActivitySessionTableViewCell: UITableViewCell {

    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

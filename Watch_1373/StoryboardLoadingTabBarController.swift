//
//  JSSStoryboardLoadingTabBarController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/24/15.
//  Copyright (c) 2015 Robert Haworth. All rights reserved.
//

import UIKit

class StoryboardLoadingTabBarController: UITabBarController {
    let storyboardNames = ["DashboardTab", "SessionsTab", "SafetyTab", "ProfileTab", "SettingsTab"]
    
    override func awakeFromNib() {
        self.viewControllers = storyboardNames.map() {
            let storyboard = UIStoryboard(name: $0, bundle: nil)
            
            return storyboard.instantiateInitialViewController()
        }
    }
}
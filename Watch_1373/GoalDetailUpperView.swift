//
//  GoalDetailUpperView.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/4/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class GoalDetailUpperView: UIView {
    
//    @IBOutlet weak var pieChart:ShinobiChart! {
//        didSet {
//            pieChart.licenseKey = licenseKey
//            pieChartController = PieChartController(chart: pieChart)
//            pieChart.datasource = pieChartController
//
//        }
//    }
    @IBOutlet weak var donutView: DonutView!
    @IBOutlet weak var borderedView: BorderedView! {
        didSet {
            borderedView.borderSides = .Bottom
            borderedView.borderColor = JardenColor.darkGrey
            borderedView.borderWidth = 0.5
            borderedView.shape = .Rectangle

        }
    }
    
    @IBOutlet weak var leftLabelDescriptorLabel:UILabel!
    @IBOutlet weak var leftLabelValueLabel:UILabel!
    
    @IBOutlet weak var rightLabelDescriptorLabel:UILabel!
    @IBOutlet weak var rightLabelValueLabel:UILabel!
    @IBOutlet weak var rightLabelDateLabel: UILabel!
    
    @IBOutlet weak var centerLabelRemainderLabel:UILabel!
    
    @IBOutlet weak var pieChartLabel:UILabel!
    
//    var pieChartController:PieChartController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.subviews.count == 0 {
            let borderedView:GoalDetailUpperView = NSBundle.mainBundle().loadNibNamed("GoalDetailUpperView", owner: self, options: nil).first as! GoalDetailUpperView
            addSubview(borderedView)
        }
    }

}

//
//  HeartRateZoneDetailViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 5/5/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class HeartRateZoneDetailViewController: UIViewController, SChartDatasource, SChartDelegate {

    @IBOutlet weak var widthBackgroundContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightBackgroundContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBackgroundContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingBackgroundContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundContainerView: UIView!
    var previousDataPoint:SChartDataPoint? = nil
    let backgroundView = UIView()
    
    var secondaryAxis:SChartAxis? = nil
    
    var redrawnChart = false
    
    var maxHRValue = 0
    var lowestHeartRate = 220
    
    var age:Int {
        didSet {
            maxHRValue = (220 - age)
        }
    }
    
    @IBOutlet weak var athleticView: UIView!
    @IBOutlet weak var unlabledView: UIView!
    @IBOutlet weak var chart: ShinobiChart! {
        didSet {
            chart.licenseKey = licenseKey
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        age = 25
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        age = 25
        let addedProportion = (ceil(((220.0-195) / 220) * 100) / 100) + 0.1
        let constraint = NSLayoutConstraint(item: backgroundContainerView, attribute: .Height, relatedBy: .Equal, toItem: athleticView, attribute: .Height, multiplier: CGFloat(1.0 / addedProportion), constant: 0.0)
        let anotherConstraint = NSLayoutConstraint(item: backgroundContainerView, attribute: .Height, relatedBy: .Equal, toItem: unlabledView, attribute: .Height, multiplier: CGFloat(1.0 / (0.6 - addedProportion)), constant: 0.0)
        backgroundContainerView.addConstraint(constraint)
        backgroundContainerView.addConstraint(anotherConstraint)
        
        chart.delegate = self
        chart.datasource = self
        chart.canvasInset = UIEdgeInsetsMake(20, 10, 0, 10)
        chart.plotAreaBackgroundColor = UIColor.clearColor()
        chart.canvasAreaBackgroundColor = UIColor.clearColor()
        chart.backgroundColor = UIColor.clearColor()

        buildXAxis()
        buildYAxis()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let chartFrame = chart.getPlotAreaFrame()
        var convertedFrame = view.convertRect(chartFrame, fromView: chart)
        
        //Offsetting for the canvas inset
        convertedFrame.offset(dx: 10, dy: 20)
        updateBackgroundViewConstraints(convertedFrame)
        
    }
    
    func updateBackgroundViewConstraints(convertedRect:CGRect) {
        topBackgroundContainerViewConstraint.constant = convertedRect.origin.y
        leadingBackgroundContainerViewConstraint.constant = convertedRect.origin.x
        heightBackgroundContainerViewConstraint.constant = convertedRect.size.height
        widthBackgroundContainerViewConstraint.constant = convertedRect.size.width
        
        backgroundContainerView.setNeedsLayout()
        
    }
    
    func buildYAxis() {
        
        let numberRange = SChartNumberRange(minimum: 0, andMaximum: 220)
        let yAxis = SChartDiscontinuousNumberAxis(range: numberRange)
        yAxis.majorTickFrequency = 20
        yAxis.style.lineWidth = 0.5
        yAxis.discontinuousTickLabelClipping = SChartDiscontinuousTickLabelClippingLow
        chart.yAxis = yAxis
        
        let secondaryYAxis = SChartDiscontinuousNumberAxis(range:numberRange)
        secondaryYAxis.axisPosition = SChartAxisPositionReverse
        
        secondaryYAxis.style.majorGridLineStyle.showMajorGridLines = true
        secondaryYAxis.style.majorGridLineStyle.lineColor = UIColor.whiteColor()
        secondaryYAxis.style.majorTickStyle.textAlignment = .Right
        secondaryYAxis.style.lineWidth = 0
        
        secondaryAxis = secondaryYAxis
        
        chart.addYAxis(secondaryYAxis)
        
    }
    
    func buildXAxis() {
        let xAxis = SChartNumberAxis()
        xAxis.majorTickFrequency = 10
        xAxis.style.lineWidth = 0.5
        chart.xAxis = xAxis
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    @objc func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let dataPoint = SChartDataPoint()
        dataPoint.xValue = dataIndex
        var yValue = 0
        if let oldDataPoint = previousDataPoint {
            let previousY = oldDataPoint.yValue as! Int
            let randomValue = Int(arc4random_uniform(8))
            let walkingNewYValue = previousY + (randomValue - 4)
            if walkingNewYValue < 60 {
                yValue = 60
            } else {
                yValue = walkingNewYValue
            }
        } else {
            yValue = Int(arc4random_uniform(UInt32(maxHRValue)) + 60)
        }
        
        if yValue > maxHRValue {
            yValue = maxHRValue
        }
        
        if yValue < lowestHeartRate {
            lowestHeartRate = yValue
        }
        
        dataPoint.yValue = yValue
        self.previousDataPoint = dataPoint
        
        return dataPoint
    }
    
    @objc func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        switch seriesIndex {
        case 0: return 85
        default: return 0
        }
    }
    
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineColor = UIColor.whiteColor()
        return lineSeries
    }
    
    func sChart(chart: ShinobiChart!, majorTickValuesForAxis axis: SChartAxis!) -> [AnyObject]! {
        if chart.yAxis == axis {
            return [70, 90, 110, 130, 150, 170, 190, 200, 220]
        } else if chart.xAxis == axis {
            return [0, 20, 30, 40, 50, 60, 70, 80]
        } else {
            return [lowestHeartRate, maxHRValue]
        }
    }
    
    func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!, beforeAddingToAxis axis: SChartAxis!) {
        if !axis.isXAxis() && axis != chart.yAxis {
            if let label = tickMark.tickLabel {
                if Int(tickMark.value) == lowestHeartRate {
                    label.frame = CGRectOffset(label.frame, 0, +8)
                    label.text = "MIN"
                } else {
                    label.text = "MAX"
                    label.frame = CGRectOffset(label.frame, 0, -8)
                }
                label.textColor = UIColor.whiteColor()
            }
        }
    }
    
    func sChartRenderFinished(chart: ShinobiChart!) {
        
        if !redrawnChart {
            redrawnChart = true
            
            if let yAxis = secondaryAxis {
                let spaceRequired = yAxis.spaceRequiredToDrawWithTitle(false)
                
                yAxis.style.majorTickStyle.tickGap = -spaceRequired
                chart.redrawChart()
            }
        }
    }
}

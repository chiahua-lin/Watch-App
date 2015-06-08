//
//  JSSPieChartController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/25/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

enum threshold: Double {
    case red = 0.49
    case yellow = 0.99
}

class PieChartController: NSObject, SChartDatasource {
    
    var isPie = true
    var dataPoints:[SChartDataPoint]
    var chart:ShinobiChart
    var animatableValuesProperty:POPAnimatableProperty
   
    override init() {
        dataPoints = []
        chart = ShinobiChart()
        animatableValuesProperty = POPAnimatableProperty()
        super.init()
        initializeDatapoints(2)
        animatableValuesProperty = buildPopProperties()
    }
    
    init(chart:ShinobiChart) {
        self.chart = chart
        dataPoints = []
        animatableValuesProperty = POPAnimatableProperty()
        super.init()
        initializeDatapoints(2)
        animatableValuesProperty = buildPopProperties()
    }
    
    func updatePieGraph(percentage:Double) {
        let currentPercentage = (percentage > 100) ? 100 : percentage
        animate(currentPercentage, remainingPercentage: (100 - currentPercentage))
    }
    
    func animate(currentPercentage:Double, remainingPercentage:Double) {
        
        
        for (index, dataPoint:SChartDataPoint) in enumerate(dataPoints) {
            let animation = POPBasicAnimation.easeInEaseOutAnimation()
            
            animation.property = animatableValuesProperty
            
            animation.fromValue = dataPoint.yValue
            
            animation.toValue = (index == 0) ? currentPercentage : remainingPercentage
            animation.duration = 1.3
            
            dataPoint.pop_addAnimation(animation, forKey: "ValueChangedAnimation")
        }
    }
    
    func buildPopProperties() -> POPAnimatableProperty {
        return POPAnimatableProperty.propertyWithName("com.shinobicontrols.test.animatingpiechartdatasource", initializer: { (prop:POPMutableAnimatableProperty!) -> Void in
            prop.readBlock = {datapoint, unsafeValues in
                if let datapoint = datapoint as? SChartDataPoint {
                    let values = UnsafePointer<CGFloat>(unsafeValues).memory
                    datapoint.yValue = values
                }
            }
            
            prop.writeBlock = { datapoint, unsafeValues in
                if let datapoint:SChartDataPoint = datapoint as? SChartDataPoint {
                    datapoint.yValue = max(UnsafePointer<CGFloat>(unsafeValues).memory, 0)
                    self.chart.reloadData()
                    self.chart.redrawChart()
                }
            }
            prop.threshold = 0.01
            
        }) as! POPAnimatableProperty
    }
    
    @objc func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return 2
    }
    
    @objc func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        return dataPoints[dataIndex]
    }
    
    @objc func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 1
    }
    
    @objc func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let currentGoalValue = dataPoints[0].yValue as! Double
        let goalColor = colorForValue(currentGoalValue)
        
        if isPie {
            let pieSeries = SChartPieSeries()
            pieSeries.style().showCrust = false
            pieSeries.labelFormatString = ""
            pieSeries.drawDirection = SChartRadialSeriesDrawDirectionClockwise
            
            pieSeries.style().flavourColors = [goalColor, JardenColor.darkGrey]
            
            return pieSeries
        } else {
            let donutSeries = SChartDonutSeries()
            
            donutSeries.style().showCrust = false
            donutSeries.labelFormatString = ""
            donutSeries.drawDirection = SChartRadialSeriesDrawDirectionClockwise
            
            donutSeries.style().flavourColors = [goalColor, JardenColor.darkGrey]
            
            return donutSeries
        }
    }
    
    func colorForValue(value:Double) -> UIColor {
        let goalValue = 100.0

        if value > (goalValue * threshold.yellow.rawValue) {
            return JardenColor.teal
        } else if value > goalValue * threshold.red.rawValue {
            return JardenColor.yellow
        } else {
            return JardenColor.red
        }
    }
    
    func initializeDatapoints(numberOfPoints:Int) {
        for index in 0..<numberOfPoints {
            let datapoint = SChartDataPoint()
            datapoint.xValue = "Datapoint \(index)"
            datapoint.yValue = ((100 * index) == 0) ? 0 : 100
            dataPoints.append(datapoint)
        }
    }
    
}

//
//  SleepViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 3/9/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class SleepViewController: UIViewController, SChartDatasource {
    
    var fakeData:[SChartDataPoint] = []
    let fakeDataIndexMatcher:[(yValue:Int, numberOfDatapoints:Int)] = [(60, 33), (70, 33), (85, 5), (90, 21), (100, 5)]
    let fakeIndexOrderArray = [3, 1, 0, 2, 0, 4, 3, 0, 2, 0, 2, 0, 2, 0, 1, 3, 0, 2, 0, 2, 0, 1, 4, 3]

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var lightSleepTimeLabel: UILabel!
    @IBOutlet weak var lightSleepTimePercentageLabel: UILabel!
    @IBOutlet weak var deepSleepTimeLabel: UILabel!
    @IBOutlet weak var deepSleepTimePercentageLabel: UILabel!
    @IBOutlet weak var remSleepTimeLabel: UILabel!
    @IBOutlet weak var remSleepTimePercentageLabel: UILabel!
    @IBOutlet weak var interruptionsLabel: UILabel!
    @IBOutlet weak var tossingTurningLabel: UILabel!
    @IBOutlet weak var totalSleepTimeLabel: UILabel!
    @IBOutlet weak var pieChartLabel: UILabel! {
        didSet {
            pieChartLabel.text = "85%"
        }
    }
    
    @IBOutlet weak var timeNavigationBar: TimeNavigationView!
    @IBOutlet weak var sleepGraph: ShinobiChart! {
        didSet {
            sleepGraph.datasource = self
            sleepGraph.canvasInset = UIEdgeInsetsMake(0, -5, -5, 0)
            buildXAxis()
            buildYAxis()
        }
    }
    
    var pieChartController:PieChartController!
    
    @IBOutlet weak var pieChart: ShinobiChart! {
        didSet {
            pieChart.licenseKey = licenseKey
            pieChartController = PieChartController(chart: pieChart)
            pieChart.datasource = pieChartController
            pieChartController.updatePieGraph(85)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        generateFakeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let datapoint = fakeData[dataIndex]
        if fakeDataIndexMatcher[seriesIndex].yValue == datapoint.yValue as! Int {
            return datapoint
        } else {
            let test = SChartDataPoint()
            test.xValue = datapoint.xValue
            test.yValue = nil
            return test
        }
    }

    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return fakeData.count
    }
    
    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let lineSeries = SChartLineSeries()
        lineSeries.style().showFill = true
        lineSeries.style().fillWithGradient = false
        let color = [JardenColor.teal, JardenColor.blue, JardenColor.darkGrey, JardenColor.yellow, JardenColor.green][index]
        lineSeries.style().areaLineColor = color
        lineSeries.style().areaColor = color
        
        return lineSeries
    }
    
    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return 5
    }
    
    func buildXAxis() {
        let xAxis = SChartDateTimeAxis()
        xAxis.majorTickFrequency = SChartDateFrequency(minute: 1)
        xAxis.style.majorTickStyle.showLabels = false
        xAxis.style.majorTickStyle.showTicks = false
        xAxis.style.lineWidth = 0
        sleepGraph.xAxis = xAxis
    }
    
    func buildYAxis() {
        let yAxis = SChartNumberAxis(range: SChartNumberRange(minimum: 0, andMaximum: 100))
        yAxis.style.majorTickStyle.showLabels = false
        yAxis.style.majorTickStyle.showTicks = false
        yAxis.style.lineWidth = 0
        sleepGraph.yAxis = yAxis
    }

    func generateFakeData() {
        var components = NSDateComponents()
        components.hour = 22
        components.minute = 30
        if let startDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate(), options: NSCalendarOptions(0)) {
            fakeData = []
            var iterations = 0
            for index in fakeIndexOrderArray {
                let fakeDataValue = fakeDataIndexMatcher[index].yValue
                let iterationTimes = fakeDataIndexMatcher[index].numberOfDatapoints
                for iterationTimesIndex in 0..<iterationTimes {
                    if iterationTimesIndex == 0 {
                        iterations--
                    }
                    iterations++
                    if let dataDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: iterations, toDate: startDate, options: NSCalendarOptions(0)) {
                        let datapoint = SChartDataPoint()
                        datapoint.yValue = fakeDataValue
                        datapoint.xValue = dataDate
                        fakeData.append(datapoint)
                        
                    }
                }
            }
            updateLabels()
        }
        
    }
    
    func updateLabels() {
        remLabelUpdate()
        lightLabelUpdate()
        deepLabelUpdate()
        interruptionsLabelUpdate()
        tossingTurningLabelUpdate()
        sleepLabelUpdate()
    }
    
    func remLabelUpdate() {
        let remDatapointArray = fakeData.filter { return $0.yValue as! Int == self.fakeDataIndexMatcher[1].yValue}
        remSleepTimeLabel.text = "\(remDatapointArray.count / 60)h \(remDatapointArray.count % 60)m"
        remSleepTimePercentageLabel.text = "\(Int((Double(remDatapointArray.count) / Double(fakeData.count)) * 100))%"
    }
    
    func lightLabelUpdate() {
        let remDatapointArray = fakeData.filter { return $0.yValue as! Int == self.fakeDataIndexMatcher[3].yValue}
        lightSleepTimeLabel.text = "\(remDatapointArray.count / 60)h \(remDatapointArray.count % 60)m"
        lightSleepTimePercentageLabel.text = "\(Int((Double(remDatapointArray.count) / Double(fakeData.count)) * 100))%"
    }
    
    func deepLabelUpdate() {
        let remDatapointArray = fakeData.filter { return $0.yValue as! Int == self.fakeDataIndexMatcher[0].yValue}
        deepSleepTimeLabel.text = "\(remDatapointArray.count / 60)h \(remDatapointArray.count % 60)m"
        deepSleepTimePercentageLabel.text = "\(Int((Double(remDatapointArray.count) / Double(fakeData.count)) * 100))%"
    }
    
    func interruptionsLabelUpdate() {
        let remDatapointArray = fakeData.filter { return $0.yValue as! Int == self.fakeDataIndexMatcher[4].yValue}
        interruptionsLabel.text = "\(remDatapointArray.count / fakeDataIndexMatcher[4].numberOfDatapoints) Times"
    }
    
    func tossingTurningLabelUpdate() {
        let remDatapointArray = fakeData.filter { return $0.yValue as! Int == self.fakeDataIndexMatcher[2].yValue}
        tossingTurningLabel.text = "\(remDatapointArray.count / fakeDataIndexMatcher[2].numberOfDatapoints) Times"
    }
    
    func sleepLabelUpdate() {
        
        let dateComponents = NSCalendar.currentCalendar().components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: fakeData.first?.xValue as! NSDate, toDate: fakeData.last?.xValue as! NSDate, options: NSCalendarOptions(0))
        let stringForMinutes = NSString(format: "%.2f", (Double(dateComponents.hour) + Double(dateComponents.minute) / 60))
        totalSleepTimeLabel.text = "\(stringForMinutes) hours"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        startTimeLabel.text = dateFormatter.stringFromDate(fakeData.first?.xValue as! NSDate)
        stopTimeLabel.text = dateFormatter.stringFromDate(fakeData.last?.xValue as! NSDate)
    }
}

//
//  GoalsDetailsViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 2/26/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class GoalsDetailsViewController: UIViewController, SChartDatasource, SChartDelegate {
    
    @IBOutlet weak var segmentedController:HMSegmentedControl! {
        didSet {
            segmentedController.selectedSegmentIndex = 0
            segmentedController.backgroundColor = JardenColor.darkGrey
            segmentedController.textColor = UIColor.whiteColor()
            segmentedController.selectedTextColor = UIColor.whiteColor()
            segmentedController.selectionIndicatorColor = JardenColor.teal
            segmentedController.selectionIndicatorHeight = 0
            segmentedController.selectionIndicatorBoxOpacity = 1.0
            segmentedController.font = UIFont.withFace(.GothamMedium, size: 16.0)
            segmentedController.borderWidth = 0.5
            segmentedController.borderColor = UIColor.whiteColor()
            segmentedController.borderType = .Left | .Right
            segmentedController.selectionStyle = HMSegmentedControlSelectionStyleBox
            segmentedController.sectionTitles = ["Day", "Week", "Month", "Year"]
            segmentedController.indexChangeBlock = {index in
                if let timeScale = TimeScale(rawValue: index) {
                    self.timeNavigationBar.currentTimeScale = timeScale
                    self.reloadGraphInputs()
                }
            }
        }
    }
    
    @IBOutlet weak var timeNavigationBar: TimeNavigationView! {
        didSet {
            timeNavigationBar.updateAction = {
                self.reloadAllData()
            }
            relativeGraphDate = timeNavigationBar.dateManager.currentDate
        }
    }

    @IBOutlet weak var goalChart:ShinobiChart! {
        didSet {
            goalChart.licenseKey = licenseKey
            goalChart.autoresizingMask = ~UIViewAutoresizing.None
            goalChart.datasource = self
            goalChart.delegate = self
            goalChart.backgroundColor = JardenColor.cream
            goalChart.canvasAreaBackgroundColor = JardenColor.cream
            goalChart.plotAreaBackgroundColor = JardenColor.cream
            goalChart.canvasInset = UIEdgeInsets(top: 10, left: 2, bottom: 0, right: 0)

            buildXAxis()
            buildYAxis()
            
        }
    }
    
    @IBOutlet weak var topSectionBorderedView:GoalDetailUpperView!
    
    @IBOutlet weak var centerLabelGoalTotalLabel:UILabel!
    
    private var relativeGraphDate:NSDate = NSDate()

    var fakeData:[(Int, NSDate)] = []
    
    var goalValue:Int = 0
    var redrawnChart = false
    
    var metricDetailType:Goal! {
        didSet {
            goalValue = Int(metricDetailType!.currentGoalValue())
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        reloadAllData()
        super.viewWillAppear(animated)
    }
    
    func buildXAxis() {
        let xAxis = SChartDateTimeAxis()
        xAxis.majorTickFrequency = SChartDateFrequency(hour: 1)
        xAxis.labelFormatter.dateFormatter().dateFormat = "hh aaa"
        xAxis.style.lineWidth = 0
        goalChart.xAxis = xAxis
    }
    
    func buildYAxis() {
        let yAxis = SChartNumberAxis()
        
        yAxis.style.majorGridLineStyle.showMajorGridLines = true
        yAxis.rangePaddingHigh = 500
        yAxis.axisPosition = SChartAxisPositionReverse
        yAxis.style.majorTickStyle.showTicks = false
        yAxis.style.lineWidth = 0
        
        goalChart.yAxis = yAxis
        goalChart.yAxis.style.majorTickStyle.textAlignment = .Right
    }
    
    func updateXAxis() {
        let timeScale = timeNavigationBar.currentTimeScale
        let xAxis = goalChart.xAxis
        //neat
        switch timeScale {
        case .Day:
            xAxis.labelFormatter.dateFormatter().dateFormat = "hh aaa"
            xAxis.majorTickFrequency = SChartDateFrequency(minute: 15)
            xAxis.rangePaddingLow = SChartDateFrequency(hour: 1)
            xAxis.rangePaddingHigh = SChartDateFrequency(hour: 2)
        case .Week:
            xAxis.majorTickFrequency = SChartDateFrequency(day: 1)
            xAxis.rangePaddingHigh = SChartDateFrequency(day:1)
            xAxis.rangePaddingLow = nil
            xAxis.labelFormatter.dateFormatter().dateFormat = "dd"
        case .Month:
            xAxis.majorTickFrequency = SChartDateFrequency(day: 1)
            xAxis.rangePaddingHigh = SChartDateFrequency(day: 3)
            xAxis.rangePaddingLow = SChartDateFrequency(day:0)
            xAxis.labelFormatter.dateFormatter().dateFormat = "dd"
        case .Year:
            xAxis.majorTickFrequency = SChartDateFrequency(month: 1)
            xAxis.rangePaddingHigh = SChartDateFrequency(month: 1)
            xAxis.labelFormatter.dateFormatter().dateFormat = "MMM"
        default:
            println("test")
        }
    }
    
    func updateYAxis() {
        let yAxis = goalChart.yAxis
        switch (timeNavigationBar.currentTimeScale, metricDetailType!) {
        case (.Day, .Distance):
            yAxis.rangePaddingHigh = 2
        case (.Year, .ActiveMinutes):
            yAxis.rangePaddingHigh = 20
        case (_, .Distance):
            yAxis.rangePaddingHigh = 3
        case (_, .ActiveMinutes):
            yAxis.rangePaddingHigh = 5
        case (_, .CaloriesBurned):
            yAxis.rangePaddingHigh = 10
        case (.Year, _):
            yAxis.rangePaddingHigh = 2000
        default:
            yAxis.rangePaddingHigh = 500
            break
        }
    }
    
    @objc func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        switch timeNavigationBar.currentTimeScale {
        case .Day: return 4 * 24
        case .Week: return 7
        case .Month:
            if let days = numberOfDaysBetweenLastMonth(toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate()) {
                return days
            } else {
                return 30
            }
        case .Year: return 12
        }
    }
    
    @objc func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        if timeNavigationBar.currentTimeScale == .Year || timeNavigationBar.currentTimeScale == .Day {
            return 1
        }
        return 2
    }
    
    @objc func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let dataPoint = SChartDataPoint()
        

        let dataValue = fakeData[dataIndex].0
        
        if timeNavigationBar.currentTimeScale == .Year || timeNavigationBar.currentTimeScale == .Day {
            dataPoint.yValue = dataValue
        } else {
            
            if dataValue > goalValue {
                switch seriesIndex {
                case 1:
                    dataPoint.yValue = dataValue
                default:
                    dataPoint.yValue = 0
                }
            } else {
                switch seriesIndex {
                case 0:
                    dataPoint.yValue = dataValue
                default:
                    dataPoint.yValue = 0
                }
            }
        }
        
        dataPoint.xValue = fakeData[dataIndex].1
        
        return dataPoint
    }
    
    @objc func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let chartSeries = SChartColumnSeries()
        
        chartSeries.style().showAreaWithGradient = false
        chartSeries.selectedStyle().showAreaWithGradient = false
        chartSeries.stackIndex = 0
        chartSeries.selectionMode = SChartSelectionPoint

        
        switch index {
        case 0:
            chartSeries.style().areaColor = JardenColor.darkGrey
            chartSeries.selectedStyle().areaColor = JardenColor.darkGrey
        case 1:
            chartSeries.style().areaColor = JardenColor.teal
            chartSeries.selectedStyle().areaColor = JardenColor.teal
        default:
            break
        }
        return chartSeries
    }
    
    
    @objc func sChart(chart: ShinobiChart!, alterTickMark tickMark: SChartTickMark!, beforeAddingToAxis axis: SChartAxis!) {
        
        if !axis.isXAxis() {
            /* Set the  */
            if tickMark.value == Double(goalValue) && timeNavigationBar.currentTimeScale != .Year && timeNavigationBar.currentTimeScale != .Day {
                if let optionalView = tickMark.gridLineView as UIView? {
                    if let optionalLabel = tickMark.tickLabel as UILabel? {
                        optionalView.backgroundColor = JardenColor.teal
                        optionalLabel.textColor = JardenColor.teal
                    }
                }
            }
            if let label = tickMark.tickLabel {
                tickMark.tickLabel.frame = CGRectOffset(tickMark.tickLabel.frame, 0, -8)
            }
        } else {
            var addOperation = false
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            /* Create the date being used by the current tick mark */
            let tickMarkDate = NSDate(timeInterval: tickMark.value , sinceDate: relativeGraphDate)
            /* Grab the first visible date from the visible data set */
            let firstVisibleDataDate = fakeData[0].1
            /* Compare the tick mark's date to the first visible date to see if this is the first tick mark of the graph */
            let result = NSCalendar.currentCalendar().compareDate(tickMarkDate, toDate: firstVisibleDataDate, toUnitGranularity: .CalendarUnitDay)
            
            /* Create a beginning of the month date using the tick mark's date as the reference for future comparison */
            let beginningOfMonth = NSCalendar.currentCalendar().dateFromComponents(NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: tickMarkDate))!
            
            switch timeNavigationBar.currentTimeScale {
            case .Week, .Month:
                /* On week and month view, if the tick mark date is the first visible date, modify the label to add the short hand month text */
                if result == NSComparisonResult.OrderedSame {
                    //Beginning of chart
                    addOperation = true
                }
                
                
                
                if timeNavigationBar.currentTimeScale == .Month {
//                    /*Magic #'s are number of days in week times hours, times minutes, times seconds */
                    let lastWeekDate = NSDate(timeInterval: tickMark.value - 7 * 24 * 60 * 60, sinceDate: relativeGraphDate)
                    
                    let thisWeekCompare = beginningOfMonth.earlierDate(tickMarkDate)
                    let lastWeekCompare = beginningOfMonth.laterDate(lastWeekDate)
                    
                    /* If the current tick mark's week is after the 1st of the month, but the prior week's tick mark is BEFORE the 1st of the month, add the short hand month text to the current tick mark. */
                    if thisWeekCompare.isEqualToDate(lastWeekCompare) {
                        addOperation = true
                    }
                }
            default:
                break
            }
            
            /* Modify label if the tickMarkDate is the beginning of the month matched on the Day */
            let results = NSCalendar.currentCalendar().compareDate(tickMarkDate, toDate: beginningOfMonth, toUnitGranularity: .CalendarUnitDay)
            
            if results == NSComparisonResult.OrderedSame {
                addOperation = true
            }
            
            /* Handle modification of matched texts*/
            if addOperation {
                if let label = tickMark.tickLabel {
                    label.text = dateFormatter.stringFromDate(tickMarkDate)
                    label.sizeToFit()
                }
                
            }
        }
    }
    
    func sChartRenderFinished(chart: ShinobiChart!) {
        
        if !redrawnChart {
            redrawnChart = true
            
            let yAxis = chart.yAxis
            let spaceRequired = yAxis.spaceRequiredToDrawWithTitle(false)
            
            yAxis.style.majorTickStyle.tickGap = -spaceRequired
            chart.redrawChart()
        }
    }
    
    func sChart(chart: ShinobiChart!, majorTickValuesForAxis axis: SChartAxis!) -> [AnyObject]! {
        if !axis.isXAxis() {
            let maxValue = fakeData.map { (value, _) in return value}.reduce(Int.min, combine:{ max($0, $1)})
            var maxMajorTick = 0
            switch (timeNavigationBar.currentTimeScale, metricDetailType!) {
            case (_, .ActiveMinutes), (_, .Distance), (_, .CaloriesBurned):
                maxMajorTick = (5 + maxValue) - (maxValue % 5)
            default:
                maxMajorTick = (500 + maxValue) - (maxValue % 500)
            }
            
            if timeNavigationBar.currentTimeScale != .Year && timeNavigationBar.currentTimeScale != .Day {
                return [0, goalValue, maxMajorTick]
            } else {
                return [0, maxMajorTick]
            }
        } else {
            var dateArray:[NSDate] = []
            
            switch timeNavigationBar.currentTimeScale {
            case .Day:
                for index in 0..<3 {
                    let offsetTime = 12 * index
                    if let date = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitHour, value: offsetTime, toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate(), options: NSCalendarOptions(0)) {
                        dateArray.append(date)
                    }
                }
            case .Month:
                    let toDate = timeNavigationBar.dateManager.beginningOfDateFromRelativeDate()
                    if let fromDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: -1, toDate: toDate, options: NSCalendarOptions(0)) {
                        let dateComponents = NSCalendar.currentCalendar().components(.CalendarUnitDay, fromDate: fromDate, toDate: toDate, options: NSCalendarOptions(0))
                        let numberOfDatapoints = Double(dateComponents.day)
                        println(numberOfDatapoints)
                        //0%, 20%, 50%, 80%, 100%
                        var tickLabels:[NSDate] = []
                        for index in [0, 25, 50, 75, 100] as [Double] {
                            let offsetTime = Int(floor(numberOfDatapoints * (index / 100)))
                            if let date = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: offsetTime * -1, toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate(), options: NSCalendarOptions(0)) {
                                dateArray.append(date)
                            }
                        }
                        
                    }
            default:
                return fakeData.map({(_, date) in date})
            }
            return dateArray
        }
    }
    
    func sChart(chart: ShinobiChart!, toggledSelectionForPoint dataPoint: SChartDataPoint!, inSeries series: SChartSeries!, atPixelCoordinate pixelPoint: CGPoint) {
        if dataPoint.selected {
            chart.removeAllAnnotations()
            let font = UIFont.withFace(.GothamBook, size: 14.0)
            let annotation = SChartAnnotation(text: "\(dataPoint.yValue)", andFont: font, withXAxis: chart.xAxis, andYAxis: chart.yAxis, atXPosition: dataPoint.xValue, andYPosition: dataPoint.yValue, withTextColor: UIColor.darkGrayColor(), withBackgroundColor: UIColor.clearColor())
            
            //floating the label just above the bar.
            annotation.label.frame.offset(dx: 0, dy: -8)
            chart.addAnnotation(annotation)

        } else {
            chart.removeAllAnnotations()
        }
        
    }
    
    func reloadGraphInputs() {
        fakeDataGenerator()
        updateXAxis()
        updateYAxis()
        goalChart.reloadData()
        goalChart.redrawChart()
        goalChart.removeAllAnnotations()
    }
    
    func reloadAllData() {
        reloadGraphInputs()
        updateLabels()
    }
    
    func updateLabels() {
        let allValues: [Int] = fakeData.map { (value, _) in return value}
        let allDates: [NSDate] = fakeData.map { (_, date) in return date }
        var maxValue = allValues.reduce(Int.min, combine:{ max($0, $1)})
        
        if timeNavigationBar.currentTimeScale == .Year {
            let dataTuple = fakeData.filter { (value, date) in return maxValue == value}
            maxValue = maxValue / numberOfDaysBetweenLastMonth(toDate:dataTuple[0].1)!
        }
        if topSectionBorderedView.rightLabelDateLabel != nil {
            formatDateLabel(allValues)
        }
        
        topSectionBorderedView.rightLabelValueLabel.text = "\(maxValue)"
        topSectionBorderedView.leftLabelValueLabel.text = "\(allValues.reduce(0, combine:{$0 + $1}) / fakeData.count)"
        centerLabelGoalTotalLabel.text = "\(goalValue)"
        if let lastValue = allValues.last {
            if let lastDate = allDates.last {
                var dayValue:Int
                if timeNavigationBar.currentTimeScale == .Year {
                    dayValue = lastValue / numberOfDaysBetweenLastMonth(toDate: lastDate)!
                } else {
                    dayValue = lastValue
                }
                topSectionBorderedView.pieChartLabel.text = "\(dayValue)"
                
                let percentage = (Double(dayValue) / Double(goalValue))
                //UPDATE PIE DONUT HERE
                topSectionBorderedView.donutView.fillPercentage = percentage
                topSectionBorderedView.donutView.animateCircle(1.0)
                topSectionBorderedView.pieChartLabel.textColor = topSectionBorderedView.donutView.colorForPercentage(percentage)
            }
        }
        
        if let dayValue = allValues.last {
            let remainingSteps = (dayValue > goalValue) ? 0 : (goalValue - dayValue)

            let remainderLabelString: String
            switch metricDetailType! {
//                case .Steps:          remainderLabelString = "steps remaining"
//                case .CaloriesBurned: remainderLabelString = "calories to burn"
//                case .ActiveMinutes:  remainderLabelString = "minutes remaining"
//                case .Distance:       remainderLabelString = "miles remaining"
                default:              remainderLabelString = ""
            }

            topSectionBorderedView.centerLabelRemainderLabel.text = "\(remainingSteps) \(remainderLabelString)"
        }
    }
    
    func formatDateLabel(allValues:[Int]) {
        let maxValue = allValues.reduce(Int.min, combine:{ max($0, $1)})
        let matchedDates = fakeData.filter { (value, date) in
            return value == maxValue
        }
        let maxValueDate = matchedDates[0].1
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "(MMM-dd)"
        
        topSectionBorderedView.rightLabelDateLabel.text = dateFormatter.stringFromDate(maxValueDate)
    }
    
    func fakeDataGenerator() {
        let calendarUnit = timeNavigationBar.currentTimeScale.asNSCalendarUnit()

        let sizeOfDataset = returnSizeOfDataset()
        let randomValueLimit = returnRandomValueLimit()
        let randomizerModifier = returnRandomizerValue()
        let timeInterval = returnTimeInterval()

        fakeData = []

        for index in 0...sizeOfDataset {
            if timeNavigationBar.currentTimeScale == .Day {
                if let date = NSCalendar.currentCalendar().dateByAddingUnit(calendarUnit, value: (index * timeInterval), toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate(), options: NSCalendarOptions(0)) {
                    fakeData.append(randomUniform(randomValueLimit), date)
                }
            } else if timeNavigationBar.currentTimeScale == .Year {
                if let date = NSCalendar.currentCalendar().dateByAddingUnit(calendarUnit, value: index - sizeOfDataset, toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate(), options: NSCalendarOptions(0)) {
                    var dayMultiplier = 1
                    if let  multiplier = numberOfDaysBetweenLastMonth(toDate: date) {
                        dayMultiplier = multiplier
                    }
                    fakeData.append(randomUniform(randomValueLimit * randomizerModifier) * dayMultiplier, date)
                }
            } else {
                if let date = NSCalendar.currentCalendar().dateByAddingUnit(calendarUnit, value: index - sizeOfDataset, toDate: timeNavigationBar.dateManager.beginningOfDateFromRelativeDate(), options: NSCalendarOptions(0)) {
                    fakeData.append(randomUniform(randomValueLimit * randomizerModifier), date)
                }
            }
        }
        
    }
    
    func returnRandomValueLimit() -> Int {
        if let metric = metricDetailType {
            switch metric {
            case .Steps: return 3000
            case .ActiveMinutes: return 15
            case .Distance: return 5
            case .CaloriesBurned: return 200
            default: return 1000
            }
        } else {
            return 1
        }
    }
    
    func returnRandomizerValue() -> Int {
        if let metric = metricDetailType {
            switch metric {
            case .Steps: return 4
            case .ActiveMinutes: return 3
            case .Distance: return 2
            case .CaloriesBurned: return 14
            default: return 1
            }
        }
        return 1
    }
    
    func returnTimeInterval() -> Int {
        switch timeNavigationBar.currentTimeScale {
        case .Day: return 15
        default: return 1
        }
    }
    
    func returnSizeOfDataset() -> Int {
        switch timeNavigationBar.currentTimeScale {
        case .Day: return 24 * 4
        case .Week: return 6
        case .Month:
            if let numberOfDays = numberOfDaysBetweenLastMonth(toDate: timeNavigationBar.dateManager.currentDate) {
                return numberOfDays
            } else {
                return 30
            }
        case .Year:
            return 12
        }
    }
    
    func numberOfDaysBetweenLastMonth(#toDate:NSDate) -> Int? {
        if let fromDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: -1, toDate: toDate, options: NSCalendarOptions(0)) {
            let dateComponents = NSCalendar.currentCalendar().components(.CalendarUnitDay, fromDate: fromDate, toDate: toDate, options: NSCalendarOptions(0))
            return dateComponents.day
        } else {
            return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! ActivityDetailsTableViewController

        let goalTextIdentifier: String
        switch metricDetailType! {
            case .Steps:          goalTextIdentifier = "steps"
            case .Distance:       goalTextIdentifier = "miles"
            case .ActiveMinutes:  goalTextIdentifier = "minutes"
            case .CaloriesBurned: goalTextIdentifier = "calories"
            default:              goalTextIdentifier = ""
        }

        destinationController.goalTextIdentifier = goalTextIdentifier
        destinationController.navigationItem.title = navigationItem.title
        destinationController.goalValue = goalValue
        let maxValue = Int(metricDetailType!.currentGoalValue())
        destinationController.maxValueLimiter = goalValue + Int((Double(maxValue) * 0.4))
    }
}

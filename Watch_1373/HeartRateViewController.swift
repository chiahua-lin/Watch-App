//
//  HeartRateViewController.swift
//  Watch_1373
//
//  Created by William LaFrance on 3/6/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit

class HeartRateViewController: UIViewController, SChartDatasource {

    let dataDensityFactor = 1000

    //MARK: IBOutlets

    @IBOutlet weak var timeNavigator: TimeNavigationView! {
        didSet {
            timeNavigator.updateAction = { [weak self] in
                self?.heartRateChart.reloadData()
                self?.heartRateChart.redrawChart()
            }
        }
    }

    @IBOutlet weak var bpmBackgroundView: RoundedCornerView!
    @IBOutlet weak var spo2BackgroundView: RoundedCornerView!
    @IBOutlet weak var heartRateDetailLabelBackground: RoundedCornerView!
    @IBOutlet weak var spo2DetailLabelBackground: RoundedCornerView!

    @IBOutlet var heartRateChart: ShinobiChart! {
        didSet {
            heartRateChart.datasource = self

            heartRateChart.xAxis = SChartDateTimeAxis()
            heartRateChart.xAxis.majorTickFrequency = SChartDateFrequency(hour: 12)
            heartRateChart.xAxis.labelFormatString = "h aaa"
            heartRateChart.xAxis.style.lineWidth = 0
            heartRateChart.xAxis.rangePaddingLow = SChartDateFrequency(hour: 1)
            heartRateChart.xAxis.rangePaddingHigh = SChartDateFrequency(hour: 1)

            func createYAxisWithPosition(position: SChartAxisPosition) -> SChartNumberAxis {
                let axis = SChartNumberAxis(range: SChartNumberRange(minimum: 0, andMaximum: 130))
                axis.majorTickFrequency = 30
                axis.style.lineWidth = 1
                axis.style.lineColor = UIColor.lightGrayColor()
                axis.axisPosition = position
                axis.style.majorTickStyle.textAlignment = .Center
                axis.style.majorGridLineStyle.showMajorGridLines = true
                return axis
            }

            heartRateChart.yAxis = createYAxisWithPosition(SChartAxisPositionNormal)
            heartRateChart.addYAxis(createYAxisWithPosition(SChartAxisPositionReverse))

            heartRateChart.canvasAreaBackgroundColor = UIColor.whiteColor()
        }
    }

    //MARK: UIViewController overrides

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bpmBackgroundView.cornerRadius = bpmBackgroundView.frame.size.height / 2.0
        spo2BackgroundView.cornerRadius = spo2BackgroundView.frame.size.height / 2.0

        heartRateDetailLabelBackground.cornerRadius = heartRateDetailLabelBackground.frame.size.height / 2.0
        spo2DetailLabelBackground.cornerRadius = spo2DetailLabelBackground.frame.size.height / 2.0
    }

    //MARK: SChartDatasource compliance

    struct HeartRateChartSeriesIndex {
        static let HeartRate = 0
        static let SPO2      = 1
        static let Count     = 2
    }

    func numberOfSeriesInSChart(chart: ShinobiChart!) -> Int {
        return HeartRateChartSeriesIndex.Count
    }

    func sChart(chart: ShinobiChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return 86400 / dataDensityFactor
    }

    func sChart(chart: ShinobiChart!, seriesAtIndex index: Int) -> SChartSeries! {
        let title: String?
        switch index {
            case HeartRateChartSeriesIndex.HeartRate: title = "Heart Rate"
            case HeartRateChartSeriesIndex.SPO2:      title = "SpO₂"
            default:                                  title = nil
        }

        let series = SChartLineSeries()
        series.title = title
        return series
    }

    func sChart(chart: ShinobiChart!, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData! {
        let datapoint = SChartDataPoint()
        datapoint.xValue = NSDate(timeInterval: Double(dataDensityFactor * dataIndex), sinceDate: NSDate().dateByGoingBackToBeginningOfDay())
        switch seriesIndex {
            case HeartRateChartSeriesIndex.HeartRate: datapoint.yValue = 60 + randomUniform(34)
            case HeartRateChartSeriesIndex.SPO2:      datapoint.yValue = 95 + randomUniform(4)
            default: break
        }
        return datapoint
    }

}

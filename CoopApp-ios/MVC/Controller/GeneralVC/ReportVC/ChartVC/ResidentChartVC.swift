//
//  ResidentChartVC.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import UIKit
import Charts

protocol ResidentChartVCDelegate {
    func chartTranslated(chartView: BarChartView)
}
class ResidentChartVC: BaseViewController {
    
    @IBOutlet var chartView: BarChartView!
    var parentView : MonthyReportTVC?
    var chartData : [ChartDataModel] = [ChartDataModel]()
    var delegate : ResidentChartVCDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserverNotification()
        self.initChartView()
        self.setDataToChart(chartDatas: self.chartData)

        chartView.setVisibleXRangeMaximum(12.0)
        chartView.setVisibleXRangeMinimum(12.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        chartView.animate(yAxisDuration: 0.5)
    }

    //MARK: - Private method
    private func addObserverNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.chooseYear(notification:)), name: NSNotification.Name("ChooseYear"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.backYear(notification:)), name: NSNotification.Name("BackYear"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.nextYear(notification:)), name: NSNotification.Name("NextYear"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.chartDrag(notification:)), name: NSNotification.Name("LineChartDrag"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.chartDrag(notification:)), name: NSNotification.Name("OccupancyRateChartDrag"), object: nil)
    }
    
    @objc private func chartDrag(notification: NSNotification){
        if let dragedXValue = notification.object as? Double {
            chartView.moveViewToX(dragedXValue)
        }
    }
    
    @objc private func backYear(notification: NSNotification){
        let lowestVisibleX = Int(chartView.lowestVisibleX)
        var xSubtractionValue : Double = 0.0
        if lowestVisibleX % 12 == 0 {
            xSubtractionValue = 11.5
        }
        else {
            xSubtractionValue = Double(lowestVisibleX % 12) - 0.5
        }
        chartView.moveViewToAnimated(xValue: Double(lowestVisibleX) - xSubtractionValue, yValue: 0, axis: YAxis.AxisDependency.left, duration: 0.5)
    }
    
    @objc private func nextYear(notification: NSNotification){
        let lowestVisibleX = Int(chartView.lowestVisibleX)
        var xAdditionValue : Double = 0.0
        if lowestVisibleX % 12 == 0 {
            xAdditionValue = 12.5
        }
        else {
            xAdditionValue = 12.5 - Double(lowestVisibleX % 12)
        }
        chartView.moveViewToAnimated(xValue: Double(lowestVisibleX) + xAdditionValue, yValue: 0, axis: YAxis.AxisDependency.left, duration: 0.5)
    }
    
    @objc private func chooseYear(notification: NSNotification){
        if let year = notification.object as? UInt16 {
            var xValue : Double = 0.5
            for data in chartData {
                if data.year < year {
                    xValue += 1
                }
            }
            chartView.moveViewToX(xValue)
        }
    }
    
    private func initChartView(){
        chartView.delegate = self
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.extraTopOffset = 30
        chartView.extraLeftOffset = 17
        
        chartView.legend.enabled = false

        // Disable zoom in/out
        chartView.setScaleEnabled(false)
        chartView.dragEnabled = true
        
        // Horizontal line
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 14 * DISPLAY_SCALE)!
        xAxis.labelCount = 12
        xAxis.labelWidth = 20 * DISPLAY_SCALE
        xAxis.valueFormatter = DayAxisValueFormatter(firstYear: (self.chartData.first?.year)!)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = GRAY3_COLOR
        
        // Vertical line
        // Disable left line
        chartView.leftAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        
        // Label of chart
        chartView.legend.form = .none

        // Formater for right line
        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.minimumFractionDigits = 0
        rightAxisFormatter.maximumFractionDigits = 1
        rightAxisFormatter.positiveSuffix = "$"
        rightAxisFormatter.negativeSuffix = "$"
        
        chartView.rightAxis.enabled = true
        chartView.rightAxis.removeAllLimitLines()
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.labelTextColor = GRAY3_COLOR
        chartView.rightAxis.gridColor = UIColor(red: 244, green: 244, blue: 244)
        chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: rightAxisFormatter)
        chartView.rightAxis.minWidth = 40 * DISPLAY_SCALE
        chartView.rightAxis.xOffset = 9 * DISPLAY_SCALE
        chartView.rightAxis.maxWidth = 40 * DISPLAY_SCALE

        let marker = ResidentChartMarker(color: PRIMARY_COLOR, font: UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 17)!, textColor: .white)
        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 40, height: 40)
        chartView.marker = marker
    }
    
    private func setDataToChart(chartDatas: [ChartDataModel]){
        let start = 1
        let yVals = (1..<start + chartDatas.count).map { (i) -> BarChartDataEntry in
            let chartData : ChartDataModel = chartDatas[i-1]
            return BarChartDataEntry(x: Double(i), y: Double(chartData.value))
        }

        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.values = yVals

            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: "")
            set1.colors = [PRIMARY_COLOR]
            set1.barBorderColor = PRIMARY_COLOR
            
            set1.drawValuesEnabled = false
            set1.highlightColor = .clear

            let data = BarChartData(dataSet: set1)
            data.barWidth = 0.7

            chartView.data = data
        }
    }
}

extension ResidentChartVC : ChartViewDelegate {
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        self.delegate?.chartTranslated(chartView: self.chartView)
        NotificationCenter.default.post(name: NSNotification.Name("ResidentChartDrag"), object: self.chartView.lowestVisibleX)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.pushToViewController(storyboardName: "Dashboard", identifier: "historyRecordVC", animated: true)
//        self.pushToViewController(storyboardName: "Dashboard", identifier: "historyRecordVC", animated: true, withParameter: ["data":1]())
    }
}

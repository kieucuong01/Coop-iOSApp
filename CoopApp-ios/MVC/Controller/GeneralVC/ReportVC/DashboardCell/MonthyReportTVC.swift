//
//  MonthyReportTVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/29/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import Charts

class MonthyReportTVC: UITableViewCell {
    var parentVC : DashboardVC? = nil
    var residentChartData : [ChartDataModel] = [ChartDataModel]()
    var lineChartData : [ChartDataModel] = [ChartDataModel]()
    var occupancyChartData : [ChartDataModel] = [ChartDataModel]()
    
    var leftCurrentYear : UInt16 = 2000
    var rightCurrentYear : UInt16 = 2000
    var monthyReport: [MonthyDataModel] = Array()
    var pickerView : UIView? = nil
    var pickerComponentView : UIPickerView? = nil
    var yearDataPickerView : [UInt16] = Array()
    
    @IBOutlet weak var chartSegmentedControl: UIAppSegmentedControl!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var backgroundChartView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initChartView()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            // initial
            self.monthyReport = self.monthyReport.sorted(by: { ($0.year, $0.month) < ($1.year, $1.month) })
            self.initData()
            self.pickerView = self.createPicker()
            
            Util.topViewController()?.tabBarController?.view.addSubview(self.pickerView!)
        }
    }
    
    func createPicker() -> UIView{
        let backgroundPickerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT))
        backgroundPickerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundPickerView.isOpaque = false
        let buttonView = UIView(frame: CGRect(x: 0, y: SIZE_HEIGHT - 260 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 45 * DISPLAY_SCALE))
        buttonView.backgroundColor = .white
        buttonView.layer.borderColor = GRAY3_COLOR.cgColor
        buttonView.layer.borderWidth = 0.5
        
        // Init button
        let cancelButton : UIButton = UIButton(frame: CGRect(x: 10, y: 0, width: 90 * DISPLAY_SCALE, height: 45 * DISPLAY_SCALE))
        cancelButton.setTitle(NSLocalizedString("button_cancel_title", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 16 * DISPLAY_SCALE)
        cancelButton.titleLabel?.textColor = PRIMARY_COLOR
        cancelButton.setTitleColor(PRIMARY_COLOR, for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)

        let okButton : UIButton = UIButton(frame: CGRect(x: SIZE_WIDTH - 70 * DISPLAY_SCALE, y: 0, width: 90 * DISPLAY_SCALE, height: 45 * DISPLAY_SCALE))
        okButton.setTitle(NSLocalizedString("button_done_title", comment: ""), for: .normal)
        okButton.titleLabel?.font = UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 16 * DISPLAY_SCALE)
        okButton.setTitleColor(PRIMARY_COLOR, for: .normal)
        okButton.titleLabel?.textAlignment = .center
        okButton.addTarget(self, action: #selector(self.okButtonAction(_:)), for: .touchUpInside)
        
        buttonView.addSubview(cancelButton)
        buttonView.addSubview(okButton)
        
        let yearPicker : UIPickerView = UIPickerView(frame: CGRect(x: 0, y: SIZE_HEIGHT - 215 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 260 * DISPLAY_SCALE))
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.backgroundColor = .white
        yearPicker.tintColor = GRAY3_COLOR
        self.pickerComponentView = yearPicker
        
        backgroundPickerView.addSubview(yearPicker)
        backgroundPickerView.addSubview(buttonView)
        backgroundPickerView.isHidden = true
        
        return backgroundPickerView
    }
    
    private func initData(){
//        let sortedMonthyReport : [MonthyDataModel] = self.monthyReport.sorted(by: { ($0.year, $0.month) < ($1.year, $1.month) })
//        // Insert fake month before first month
//        if sortedMonthyReport.first?.month != 1 {
//            for index in UInt8(1)..<(sortedMonthyReport.first?.month)!{
//                let fakeData : ChartDataModel = ChartDataModel(value: -1, month: index, year: (sortedMonthyReport.first?.year)!)
//
//                self.residentChartData.append(fakeData)
//                self.lineChartData.append(fakeData)
//                self.occupancyChartData.append(fakeData)
//            }
//        }
//
//        for i in 0..<sortedMonthyReport.count{
//            let monthyData : MonthyDataModel = sortedMonthyReport[i]
//            let residentData : ChartDataModel = ChartDataModel(value: monthyData.residentsTotal, month: monthyData.month, year: monthyData.year)
//            let roomData : ChartDataModel = ChartDataModel(value: monthyData.roomsTotal, month: monthyData.month, year: monthyData.year)
//            let occupancyData : ChartDataModel = ChartDataModel(value: monthyData.tenancyRate, month: monthyData.month, year: monthyData.year)
//            self.residentChartData.append(residentData)
//            self.lineChartData.append(roomData)
//            self.occupancyChartData.append(occupancyData)
//        }
//
//        // Insert fake month after last month
//        if sortedMonthyReport.last?.month != 12 {
//            for index in ((sortedMonthyReport.last?.month)! + 1)...12{
//                let fakeData : ChartDataModel = ChartDataModel(value: -1, month: index, year: (sortedMonthyReport.last?.year)!)
//
//                self.residentChartData.append(fakeData)
//                self.lineChartData.append(fakeData)
//                self.occupancyChartData.append(fakeData)
//            }
//        }
        
        
        // fake data
        self.getChartData()

        
        // init Year Data
        for monthyData in self.residentChartData{
            if self.yearDataPickerView.count == 0 || (self.yearDataPickerView.last! != monthyData.year){
                self.yearDataPickerView.append(monthyData.year)
            }
        }

        self.initYearPicker()

        self.add(asChildViewController: residentChartVC)
        self.add(asChildViewController: lineChartVC)
        self.add(asChildViewController: occupancyRateChartVC)
        self.remove(asChildViewController: lineChartVC)
        self.remove(asChildViewController: occupancyRateChartVC)
    }
    
    private func initYearPicker(){
        // Set year
        if let currentYear = self.monthyReport.first?.year {
           // self.yearButton.setTitle(String(format: "%d年", currentYear), for: .normal)
            self.yearButton.setTitle(String(format: "%d%@%d%@ ~ %d%@%d%@",
                                            currentYear, NSLocalizedString("year", comment: ""),
                                            1, NSLocalizedString("month", comment: ""),
                                            currentYear, NSLocalizedString("year", comment: ""),
                                            12, NSLocalizedString("month", comment: "")),
                                     for: .normal)

            self.leftCurrentYear = currentYear
            self.rightCurrentYear = currentYear
        }
    }

    
    private lazy var residentChartVC: ResidentChartVC = {
        let vcClass = ResidentChartVC.self as UIViewController.Type
        let vc : ResidentChartVC = vcClass.init() as! ResidentChartVC
        vc.parentView = self
        vc.delegate = self
        vc.chartData = self.residentChartData
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)
        
        return vc
    }()
    
    private lazy var occupancyRateChartVC: OccupancyRateChartVC = {
        let vcClass = OccupancyRateChartVC.self as UIViewController.Type
        let vc : OccupancyRateChartVC = vcClass.init() as! OccupancyRateChartVC
        vc.parentView = self
        vc.delegate = self
        vc.chartData = self.occupancyChartData
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)
        
        return vc
    }()
    
    private lazy var lineChartVC: LineChart1ViewController = {
        let vcClass = LineChart1ViewController.self as UIViewController.Type
        let vc : LineChart1ViewController = vcClass.init() as! LineChart1ViewController
        vc.parentView = self
        vc.delegate = self
        vc.chartData = self.lineChartData
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)
        
        return vc
    }()
    
    private func initChartView(){
        self.chartSegmentedControl.setTitle(NSLocalizedString("Đơn hàng", comment: ""), forSegmentAt: 0)
        self.chartSegmentedControl.setTitle(NSLocalizedString("Doanh thu", comment: ""), forSegmentAt: 1)
        self.chartSegmentedControl.setTitle(NSLocalizedString("Tỷ lệ lỗi", comment: ""), forSegmentAt: 2)
        self.backgroundChartView.applySketchShadow(x: 0, y: 0, blur: 4, spread: 0)
        self.yearButton.setTitleColor(GRAY1_COLOR, for: .normal)
        self.yearButton.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 20 * DISPLAY_SCALE)

    }
    
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        self.parentVC?.addChildViewController(viewController)
        
        // Add Child View as Subview
        self.chartView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = self.chartView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self.parentVC)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    
    private func getChartData(){
        let year : UInt16 = 2016
//        let year : UInt16 = (self.monthyReport.last?.year)!
        for j in 0...4{
            for index in 1...12{
                let yearx = year + UInt16(j)
                let data1 : ChartDataModel = ChartDataModel(value: Int(arc4random_uniform(100)), month: UInt8(index), year: yearx)
                
                self.residentChartData.append(data1)
                self.lineChartData.append(data1)
                self.occupancyChartData.append(data1)
            }
        }
    }
    
    //MARK: - Action
    @IBAction func chartSegmentedControlAction(_ sender:  UIAppSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.remove(asChildViewController: lineChartVC)
            self.remove(asChildViewController: occupancyRateChartVC)
            add(asChildViewController: residentChartVC)
        }
        else if sender.selectedSegmentIndex == 1 {
            self.remove(asChildViewController: occupancyRateChartVC)
            self.remove(asChildViewController: residentChartVC)
            add(asChildViewController: lineChartVC)
        }
        else {
            self.remove(asChildViewController: residentChartVC)
            self.remove(asChildViewController: lineChartVC)
            add(asChildViewController: occupancyRateChartVC)
        }
    }
    
    @IBAction func chooseYearBtnAction(_ sender: Any) {
        self.pickerView?.isHidden = false
    }
    
    @IBAction func backYearBtnAction(_ sender: Any) {
        let sortedMonthyReport : [MonthyDataModel] = self.monthyReport.sorted(by: { ($0.year, $0.month) < ($1.year, $1.month) })

        let minYear : UInt16 = (sortedMonthyReport.first?.year)!
        if minYear <= self.leftCurrentYear {
            if (self.leftCurrentYear == self.rightCurrentYear) && (minYear != self.leftCurrentYear){
                self.leftCurrentYear -= 1
                self.rightCurrentYear -= 1
            }
            else {
                if self.rightCurrentYear > minYear{
                    self.rightCurrentYear -= 1
                }
            }
            //self.yearButton.setTitle(String(format: "%d%@",self.leftCurrentYear, NSLocalizedString("year", comment: "")), for: .normal)
            self.yearButton.setTitle(String(format: "%d%@%d%@ ~ %d%@%d%@",
                                            self.leftCurrentYear, NSLocalizedString("year", comment: ""),
                                            1, NSLocalizedString("month", comment: ""),
                                            self.leftCurrentYear, NSLocalizedString("year", comment: ""),
                                            12, NSLocalizedString("month", comment: "")),
                                     for: .normal)

            NotificationCenter.default.post(name: NSNotification.Name("BackYear"), object: nil)
        }
    }
    
    @IBAction func nextYearBtnAction(_ sender: Any) {
        let sortedMonthyReport : [MonthyDataModel] = self.monthyReport.sorted(by: { ($0.year, $0.month) < ($1.year, $1.month) })

        let maxYear : UInt16 = (sortedMonthyReport.last?.year)!
        if maxYear >= self.rightCurrentYear {
            if (self.leftCurrentYear == self.rightCurrentYear) && maxYear != self.rightCurrentYear{
                self.leftCurrentYear += 1
                self.rightCurrentYear += 1
            }
            else {
                if self.leftCurrentYear < maxYear{
                    self.leftCurrentYear += 1
                }
            }
            self.yearButton.setTitle(String(format: "%d%@%d%@ ~ %d%@%d%@",
                                            self.rightCurrentYear, NSLocalizedString("year", comment: ""),
                                            1, NSLocalizedString("month", comment: ""),
                                            self.rightCurrentYear, NSLocalizedString("year", comment: ""),
                                            12, NSLocalizedString("month", comment: "")),
                                     for: .normal)
            //self.yearButton.setTitle(String(format: "%d%@",self.rightCurrentYear, NSLocalizedString("year", comment: "")), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name("NextYear"), object: nil)
        }
    }
    
    @objc func okButtonAction(_ sender: UIButton){
        self.hideForegroundContainPickerView()
        if let yearIndex = self.pickerComponentView?.selectedRow(inComponent: 0){
            //let yearString = String(format: "%d%@", self.yearDataPickerView[yearIndex], NSLocalizedString("year", comment: ""))
//            self.yearButton.setTitle(yearString, for: .normal)

            self.yearButton.setTitle(String(format: "%d%@%d%@ ~ %d%@%d%@",
                                            self.yearDataPickerView[yearIndex], NSLocalizedString("year", comment: ""),
                                            1, NSLocalizedString("month", comment: ""),
                                            self.yearDataPickerView[yearIndex], NSLocalizedString("year", comment: ""),
                                            12, NSLocalizedString("month", comment: "")),
                                     for: .normal)

            NotificationCenter.default.post(name: NSNotification.Name("ChooseYear"), object: self.yearDataPickerView[yearIndex])
        }
    }
    
    @objc func cancelButtonAction(_ sender: UIButton){
        self.hideForegroundContainPickerView()
    }
    
    func hideForegroundContainPickerView() {
        self.pickerView?.isHidden = true
    }
}

extension MonthyReportTVC : LineChartVCDelegate{
    func chartTranslated(chartView: LineChartView) {
        let lowestVisibleX : Double = chartView.lowestVisibleX - 0.5
        let highestVisibleX : Double = chartView.highestVisibleX - 1
        let lowestVisibleData : ChartDataModel = self.lineChartData[Int(lowestVisibleX)]
        let highestVisibleData : ChartDataModel = self.lineChartData[Int(highestVisibleX)]

        if lowestVisibleData.year == highestVisibleData.year {
            UIView.performWithoutAnimation {
                self.yearButton.setTitle(String(format: "%d%@",
                                                lowestVisibleData.year,
                                                NSLocalizedString("year", comment: "")),for: .normal)
                self.yearButton.layoutIfNeeded()
            }
        }
        else {
            UIView.performWithoutAnimation {
                self.yearButton.setTitle(String(format: "%d%@%d%@ ~ %d%@%d%@",
                                                lowestVisibleData.year, NSLocalizedString("year", comment: ""),
                                                lowestVisibleData.month, NSLocalizedString("month", comment: ""),
                                                highestVisibleData.year, NSLocalizedString("year", comment: ""),
                                                highestVisibleData.month, NSLocalizedString("month", comment: "")),
                                         for: .normal)
                self.yearButton.layoutIfNeeded()
            }
        }
    }
}

extension MonthyReportTVC : ResidentChartVCDelegate, OccupancyRateChartVCDelegate  {
    func chartTranslated(chartView: BarChartView) {
        let lowestVisibleX : Double = chartView.lowestVisibleX
        let highestVisibleX : Double = chartView.highestVisibleX - 1
        let lowestVisibleData : ChartDataModel = self.residentChartData[Int(lowestVisibleX)]
        let highestVisibleData : ChartDataModel = self.residentChartData[Int(highestVisibleX)]
        if lowestVisibleData.year == highestVisibleData.year {
            UIView.performWithoutAnimation {
                self.yearButton.setTitle(String(format: "%d%@",
                                                lowestVisibleData.year,
                                                NSLocalizedString("year", comment: "")),for: .normal)
                self.yearButton.layoutIfNeeded()
            }
        }
        else {
            UIView.performWithoutAnimation {
                self.yearButton.setTitle(String(format: "%d%@%d%@ ~ %d%@%d%@",
                                                lowestVisibleData.year, NSLocalizedString("year", comment: ""),
                                                lowestVisibleData.month, NSLocalizedString("month", comment: ""),
                                                highestVisibleData.year, NSLocalizedString("year", comment: ""),
                                                highestVisibleData.month, NSLocalizedString("month", comment: "")),
                                         for: .normal)
                self.yearButton.layoutIfNeeded()
            }
        }
        self.leftCurrentYear = lowestVisibleData.year
        self.rightCurrentYear = highestVisibleData.year
    }
}

extension MonthyReportTVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.yearDataPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format : "%d%@",self.yearDataPickerView[row], NSLocalizedString("year", comment: ""))
    }
}

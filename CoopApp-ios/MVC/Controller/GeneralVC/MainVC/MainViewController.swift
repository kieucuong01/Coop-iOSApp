//
//  MainViewController.swift
//  MMDrawController
//
//  Created by Millman YANG on 2017/3/30.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import MMDrawController
import FSCalendar

class MainViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var toogleBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var functionView1: UIView!
    @IBOutlet weak var functionView2: UIView!
    @IBOutlet weak var functionView3: UIView!
    @IBOutlet weak var functionView4: UIView!
    @IBOutlet weak var functionView5: UIView!
    @IBOutlet weak var functionView6: UIView!
    @IBOutlet weak var functionView7: UIView!
    @IBOutlet weak var functionView8: UIView!
    @IBOutlet weak var functionView9: UIView!
    
    var selectedDate : Date = Date()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewByRole(role: GlobalQuick.userLogin?.rule ?? "Supplier")
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.select(Date())
        self.calendar.scope = .month
//        self.calendarHeightConstraint.constant = 220 * DISPLAY_SCALE
        self.calendar.backgroundColor = PRIMARY_COLOR
        self.toogleBtn.tintColor = .white
        self.toogleBtn.backgroundColor = PRIMARY_COLOR

        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.scrollView.panGestureRecognizer.require(toFail: self.scopeGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupViewByRole(role:String) {
        self.configureView(view: self.functionView1, image: UIImage(named: "ic_news")! , title: "Tin Tức", action: #selector(self.newsAction(_:)))
        if role == UserRole.Supplier.rawValue {
            self.functionView6.isHidden = true
            self.functionView7.isHidden = true
            self.functionView8.isHidden = true
            self.functionView9.isHidden = true

            self.configureView(view: self.functionView2, image: UIImage(named: "ic_order")! , title: "Đơn Hàng", action: #selector(self.orderAction(_:)))

            self.configureView(view: self.functionView3, image: UIImage(named: "ic_transit")! , title: "Quản Lý Xe", action: #selector(self.vehicleAction(_:)))
            
            self.configureView(view: self.functionView4, image: UIImage(named: "ic_product")! , title: "Sản Phẩm", action: #selector(self.productAction(_:)))

            self.configureView(view: self.functionView5, image: UIImage(named: "ic_cart")! , title: "Sọt Hàng", action: #selector(self.basketAction(_:)))
        }
        else if role == UserRole.Warehouse.rawValue {
            self.functionView9.isHidden = true
            
            self.configureView(view: self.functionView2, image: UIImage(named: "ic_order")! , title: "Đơn Hàng", action: #selector(self.supermarketAction(_:)))
            
            self.configureView(view: self.functionView3, image: UIImage(named: "ic_transit")! , title: "Quản Lý Xe", action: #selector(self.vehicleAction(_:)))
            
            self.configureView(view: self.functionView4, image: UIImage(named: "ic_delivered")! , title: "Xác Nhận Xe", action: #selector(self.transportAction(_:)))

            self.configureView(view: self.functionView5, image: UIImage(named: "ic_cart")! , title: "Sọt Hàng", action: #selector(self.basketAction(_:)))
            
            self.configureView(view: self.functionView6, image: UIImage(named: "ic_verify")! , title: "Kiểm Định", action: #selector(self.confirmAction(_:)))
            
            self.configureView(view: self.functionView7, image: UIImage(named: "ic_devide")! , title: "Chia Hàng", action: #selector(self.devideAction(_:)))
            
            self.configureView(view: self.functionView8, image: UIImage(named: "ic_return")! , title: "Trả Sọt Hàng", action: #selector(self.basketManagementAction(_:)))

        }
        else {
            self.functionView5.isHidden = true
            self.functionView6.isHidden = true
            self.functionView7.isHidden = true
            self.functionView8.isHidden = true
            self.functionView9.isHidden = true

            self.configureView(view: self.functionView2, image: UIImage(named: "ic_order")! , title: "Đơn Hàng", action: #selector(self.orderAction(_:)))

            self.configureView(view: self.functionView3, image: UIImage(named: "ic_delivered")! , title: "Xác Nhận Xe", action: #selector(self.transportAction(_:)))
            
            self.configureView(view: self.functionView4, image: UIImage(named: "ic_verify")! , title: "Kiểm Định", action: #selector(self.confirmAction(_:)))
        }
    }
    
    func configureView(view: UIView, image:UIImage, title: String, action: Selector){
        (view.viewWithTag(11) as! UIButton).addTarget(self, action: action, for: .touchUpInside)
        (view.viewWithTag(12) as! UIImageView).image = image
        (view.viewWithTag(13) as! UILabel).text = title
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.scrollView.contentOffset.y <= -self.scrollView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    

    @IBAction func toggleClicked(sender: AnyObject) {
        if self.calendar.scope == .month {
//            self.calendarHeightConstraint.constant = 100 * DISPLAY_SCALE
            self.calendar.setScope(.week, animated: true)
            self.toogleBtn.setImage(UIImage(named: "expand"), for: .normal)
        } else {
//            self.calendarHeightConstraint.constant = 220 * DISPLAY_SCALE
            self.calendar.setScope(.month, animated: true)
            self.toogleBtn.setImage(UIImage(named: "colapse"), for: .normal)
        }
    }
    
    @objc func newsAction(_ sender: UIButton) {
        Util.showAlert("Đang phát triển")
//        self.pushToViewController(storyboardName: "News", identifier: "newsVC", animated: true)
    }
    
    @objc func orderAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Order", identifier: "ordersVC", animated: true, withParameter: ["date" : self.selectedDate])
    }
    
    @objc func vehicleAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Vehicle", identifier: "vehicleVC", animated: true)
    }

    @objc func transportAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Transport", identifier: "transportVehicleVC", animated: true)
    }
    
    @objc func productAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Product", identifier: "productVC", animated: true)
    }
    
    @objc func supermarketAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Order", identifier: "supermarketVC", animated: true, withParameter: ["date" : self.selectedDate])
    }
    
    @objc func confirmAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "ConfirmBasket", identifier: "confirmBasketVC", animated: true)
    }
    
    @objc func devideAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Devide", identifier: "devideVC", animated: true, withParameter:  ["date" : self.selectedDate])
    }
    
    @objc func basketAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Basket", identifier: "basketNContainerVC", animated: true)
    }
    
    @objc func basketManagementAction(_ sender: UIButton) {
        self.pushToViewController(storyboardName: "Basket", identifier: "supplierVC", animated: true, withParameter: ["date" : self.selectedDate])
    }

}

extension MainViewController : FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(calendar.currentPage)")
    }
}

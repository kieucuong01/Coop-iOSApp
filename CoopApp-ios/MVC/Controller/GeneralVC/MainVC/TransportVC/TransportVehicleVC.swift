//
//  TransportVehicleVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/26/19.
//  Copyright © 2019 Oceanize. All rights reserved.
//

import UIKit

class TransportVehicleVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchOrderTypeBtn: UIButton!
    @IBOutlet weak var searchTypeBtn: UIButton!
    
    @IBOutlet weak var widthSearchTypeConstraint: NSLayoutConstraint!
    
    var searchType : String = "code"
    var searchOrderType : Int = OrderType.Centralize.rawValue
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    
    var vehicles: [VehicleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initView(){
        self.title = NSLocalizedString("XÁC NHẬN XE", comment: "")
        
        if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            self.widthSearchTypeConstraint.constant = SIZE_WIDTH
            self.searchOrderTypeBtn.isHidden = true
        }
        else {
            self.widthSearchTypeConstraint.constant = SIZE_WIDTH/2
            self.searchOrderTypeBtn.isHidden = false
        }
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "VehicleTVC", bundle: nil), forCellReuseIdentifier: "vehicleTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIVehicleList(isReload: true)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIVehicleList(isReload: false)
            }
        }
    }
    
    // MARK: CALL API
    
    private func callAPIVehicleList(isReload: Bool, searchKey: String = "") {
        // Reset list of new
        if (isReload == true) { self.vehicles.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API WAREHOUSE
        let params = [self.searchType : searchKey] as [String : Any]
        if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            APIBase.sharedInstance()?.callAPITransportSearch(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIVehicleList(result: result, error: error)
            })
        }
            // CALL API SUPERMARTKET
        else if GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue {
            if self.searchOrderType == OrderType.Centralize.rawValue{
                APIBase.sharedInstance()?.callAPIWarehouseTransportSearch(isShowHUD: true, params: params, completionHandler: { (result, error) in
                    self.completionAPIVehicleList(result: result, error: error)
                })
            }
            else {
                APIBase.sharedInstance()?.callAPITransportSearch(isShowHUD: true, params: params, completionHandler: { (result, error) in
                    self.completionAPIVehicleList(result: result, error: error)
                })
            }
        }
    }
    
    private func completionAPIVehicleList(result : NSDictionary?, error : NSError?) {
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil {
            // Success
            let dics : Array<Dictionary<String,Any>> = result?["transport_list"] as! Array<Dictionary<String, Any>>
            self.totalPage = result?["total_page"] as! Int
            self.totalRecord = result?["total_record"] as! Int
            for dic in dics {
                self.vehicles.append( VehicleModel(dict: dic["vehicle"] as! Dictionary<String, Any>))
            }
            self.tableView.reloadData()
        }
        else {
            // Call API Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func callAPITransportFinish(transportId: Int){
        // Call API
        if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            let params = ["transport_id" : transportId] as [String : Any]
            
            APIBase.sharedInstance()?.callAPITransportFinish(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransportFinish(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Supermarket.rawValue {
            let params = ["transport_id" : transportId] as [String : Any]
            
            if self.searchOrderType == OrderType.Centralize.rawValue{
                APIBase.sharedInstance()?.callAPIWarehouseTransportFinish(isShowHUD: true, params: params, completionHandler: { (result, error) in
                    self.completionAPITransportFinish(result: result, error: error)
                })
            }
            else {
                APIBase.sharedInstance()?.callAPITransportFinish(isShowHUD: true, params: params, completionHandler: { (result, error) in
                    self.completionAPITransportFinish(result: result, error: error)
                })
            }
        }
    }
    
    private func completionAPITransportFinish(result : NSDictionary?, error : NSError?) {
        if error == nil && result != nil{
            // Success
            Util.showAlert("Xác nhận xe đến thành công", completion: {
                self.callAPIVehicleList(isReload: true)
            })
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    // - MARK: ACTION
    @objc func addBtnAction(_ sender: UIBarButtonItem){
        self.pushToViewController(storyboardName: "Vehicle", identifier: "addTransportVehicleVC", animated: true)
    }
    
    @IBAction func searchTypeBtnAction(_ sender: UIButton) {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(title: "Mã vận chuyển", style: UIAlertActionStyle.default)
        { action -> Void in
            self.searchType = SearchVehicleType.Code.rawValue
            self.searchTypeBtn.setTitle(action.title, for: .normal)
        })
        
        alert.addAction(UIAlertAction(title: "Biển số xe", style: UIAlertActionStyle.default)
        { action -> Void in
            self.searchType = SearchVehicleType.PlateNumber.rawValue
            self.searchTypeBtn.setTitle(action.title, for: .normal)
        })
        
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchOrderTypeBtnAction(_ sender: UIButton) {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(title: "Tập Trung", style: UIAlertActionStyle.default)
        { action -> Void in
            self.searchOrderType = OrderType.Centralize.rawValue
            self.searchOrderTypeBtn.setTitle(action.title, for: .normal)
        })
        
        alert.addAction(UIAlertAction(title: "Đa phương", style: UIAlertActionStyle.default)
        { action -> Void in
            self.searchOrderType = OrderType.Decentralize.rawValue
            self.searchOrderTypeBtn.setTitle(action.title, for: .normal)
        })
        
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension TransportVehicleVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    
    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 * DISPLAY_SCALE
    }
    
    // MARK: - UITableViewDataSource
    
    /*
     * Created by: cuongkt
     * Description: Number of section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     * Created by: cuongkt
     * Description: Number of row in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vehicles.count
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader : UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        viewHeader.textLabel?.text = String(format: "%@ %d", NSLocalizedString("Số lượng: ", comment: ""), self.totalRecord)

        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: VehicleTVC = tableView.dequeueReusableCell(withIdentifier: "vehicleTVC") as? VehicleTVC {
            // Update index
            if self.vehicles.indices.contains(indexPath.row){
                let model : VehicleModel = self.vehicles[indexPath.row]
                cell.updateViewCell(model: model)
            }
            // Return cell
            return cell
        }
        
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = self.vehicles[indexPath.row]
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Xem sọt hàng", style: UIAlertActionStyle.default)
        { action -> Void in
            if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
                self.pushToViewController(storyboardName: "Vehicle", identifier: "transportVC", animated: true, withParameter: ["transport" : vehicle.transport])
            }
            else if GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue {
                if self.searchOrderType == OrderType.Centralize.rawValue {
                    self.pushToViewController(storyboardName: "Transport", identifier: "warehouseTransportVC", animated: true, withParameter: ["transport" : vehicle.transport])
                }
                else {
                    self.pushToViewController(storyboardName: "Vehicle", identifier: "transportVC", animated: true, withParameter: ["transport" : vehicle.transport])
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Xác nhận đã đến", style: UIAlertActionStyle.default)
        { action -> Void in
            if let transport = vehicle.transport {
                    self.callAPITransportFinish(transportId: transport.id)
            }
            else {
                Util.showAlert("Xe chưa có transport")
            }
        })
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

extension TransportVehicleVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.callAPIVehicleList(isReload: true, searchKey: searchBar.text!)
        view.endEditing(true)
    }
}

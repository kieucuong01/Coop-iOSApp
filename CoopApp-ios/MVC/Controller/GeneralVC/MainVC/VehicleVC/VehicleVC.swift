//
//  VehicleVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/26/19.
//  Copyright © 2019 Oceanize. All rights reserved.
//

import UIKit

class VehicleVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTypeBtn: UIButton!

    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    var searchType : String = SearchVehicleType.Code.rawValue

    var vehicles: [VehicleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
    }                                                                                                                  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callAPIVehicleList(isReload: true)
    }
    
    private func initView(){
        self.title = NSLocalizedString("QUẢN LÝ XE", comment: "")
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addBtnAction(_:)))
        self.navigationItem.rightBarButtonItem = addButton
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
        
        // Call API SUPPLIER
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
            let params = ["supplier_id" : GlobalQuick.userLogin?.supplier_id ?? 0,
                          self.searchType: searchKey,
                          "active_flag": true,
                          "page": self.page] as [String : Any]

            APIBase.sharedInstance()?.callAPIVehicleList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIVehicleList(result: result, error: error)
            })
        }
        // CALL API WAREHOUSE
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            let params = [self.searchType: searchKey,
                          "page": self.page] as [String : Any]

            APIBase.sharedInstance()?.callAPIWarehouseVehicleList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIVehicleList(result: result, error: error)
            })
        }
    }
    
    private func completionAPIVehicleList(result : NSDictionary?, error : NSError?) {
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil {
            // Success
            let dics : Array<Dictionary<String,Any>> = result?["vehicle_list"] as! Array<Dictionary<String, Any>>
            self.totalPage = result?["total_page"] as! Int
            self.totalRecord = result?["total_record"] as! Int
            for dic in dics {
                self.vehicles.append( VehicleModel(dict: dic))
            }
            self.tableView.reloadData()
        }
        else {
            // Call API Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func callAPICreateCode(vehicleId: Int){
        // Call API SUPPLIER
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
        let params = ["supplier_vehicle_id" : vehicleId] as [String : Any]
        
        APIBase.sharedInstance()?.callAPITransportInsert(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.completionAPICreateCode(result: result, error: error)
        })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            let params = ["warehouse_vehicle_id" : vehicleId] as [String : Any]
            
            APIBase.sharedInstance()?.callAPIWarehouseTransportInsert(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPICreateCode(result: result, error: error)
            })
        }
    }
    
    private func completionAPICreateCode(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            Util.showAlert("Tạo mã thành công", completion: {
                self.callAPIVehicleList(isReload: true)
            })
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func callAPIDeleteVehicle(vehicleId: Int, index: Int){
        // Call API
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
        let params = ["vehicle_id" : vehicleId] as [String : Any]
        APIBase.sharedInstance()?.callAPIDeleteVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.completionAPIDeleteVehicle(result: result, error: error, index: index)
        })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            let params = ["vehicle_id" : vehicleId] as [String : Any]
            APIBase.sharedInstance()?.callAPIDeleteWarehouseVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIDeleteVehicle(result: result, error: error, index: index)
            })
        }
    }
    
    private func completionAPIDeleteVehicle(result : NSDictionary?, error : NSError?, index: Int){
        if error == nil{
            // Success
            Util.showAlert("Xóa thành công", completion: {
                self.totalRecord -= 1
                self.vehicles.remove(at: index)
                self.tableView.reloadData()
            })
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func callAPIStartVehicle(transportId: Int){
        // Call API
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
        let params = ["transport_id" : transportId] as [String : Any]
        
        APIBase.sharedInstance()?.callAPITransportStart(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.completionAPIStartVehicle(result: result, error: error)
        })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            let params = ["transport_id" : transportId] as [String : Any]
            
            APIBase.sharedInstance()?.callAPIStartWarehouseVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIStartVehicle(result: result, error: error)
            })
        }
    }
    
    private func completionAPIStartVehicle(result : NSDictionary?, error : NSError?) {
        if error == nil {
            // Success
            Util.showAlert("Di chuyển xe thành công", completion: {
                self.callAPIVehicleList(isReload: true)
//                self.pushToViewController(storyboardName: "Vehicle", identifier: "mapVC", animated: true)
            })
        }
        else {
            // Call API Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    // - MARK: ACTION
    @objc func addBtnAction(_ sender: UIBarButtonItem){
        self.pushToViewController(storyboardName: "Vehicle", identifier: "addVehicleVC", animated: true)
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

}

extension VehicleVC: UITableViewDelegate, UITableViewDataSource {
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
        viewHeader.contentView.backgroundColor = .white
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
        self.dismissKeyboard()
        let vehicle = self.vehicles[indexPath.row]
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Tạo mã vận chuyển", style: UIAlertActionStyle.default)
        { action -> Void in
            if let transport = vehicle.transport {
                if transport.code != "" {
                    Util.showAlert("Xe đã được tạo mã vận chuyển")
                }
                else {
                    self.callAPICreateCode(vehicleId: vehicle.id)
                }
            }
            else {
                self.callAPICreateCode(vehicleId: vehicle.id)
            }
        })
            alert.addAction(UIAlertAction(title: "Di chuyển", style: UIAlertActionStyle.default)
            { action -> Void in
                if let transport = vehicle.transport {
                        self.callAPIStartVehicle(transportId: transport.id)
                }
                else {
                    Util.showAlert("Xe chưa được tạo mã vận chuyển")
                }
            })
        alert.addAction(UIAlertAction(title: "Chi tiết", style: UIAlertActionStyle.default)
        { action -> Void in
            self.pushToViewController(storyboardName: "Vehicle", identifier: "detailVehicleVC", animated: true, withParameter: ["vehicleModel" : vehicle])
        })
        
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

extension VehicleVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.callAPIVehicleList(isReload: true, searchKey: searchBar.text!)
        view.endEditing(true)
    }
}

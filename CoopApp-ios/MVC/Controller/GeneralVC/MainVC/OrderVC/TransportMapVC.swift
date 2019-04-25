//
//  TransportMapVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/26/19.
//  Copyright © 2019 Oceanize. All rights reserved.
//

import UIKit

class TransportMapVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedTransactions : [TransactionModel] = []
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    
    var vehicles: [VehicleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedTransactions = self.data["transactions"] as? [TransactionModel] ?? []
        self.initView()
        self.initTableView()
        self.callAPIVehicleList(isReload: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initView(){
        self.title = NSLocalizedString("CHỌN XE VẬN CHUYỂN", comment: "")
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
    
    private func callAPIVehicleList(isReload: Bool, searchKey: String = "") {
        // Reset list of new
        if (isReload == true) { self.vehicles.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue{
        let params = ["supplier_id" : Util.getValueFromUserDefault(key: GlobalQuick.userIdKey) as? Int ?? 0,
                      "plate_number": searchKey,
                      "active_flag": true,
                      "page": self.page] as [String : Any]
        
        APIBase.sharedInstance()?.callAPITransportVehicleList(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.completionAPIVehicleList(result: result, error: error)
        })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            let params = ["plate_number": searchKey,
                          "page": self.page] as [String : Any]
            APIBase.sharedInstance()?.callAPIWarehouseTransportVehicleList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIVehicleList(result: result, error: error)
            })
        }
    }
    
    private func completionAPIVehicleList(result : NSDictionary?, error : NSError?){
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil{
            // Success
            var dics : Array<Dictionary<String,Any>> = Array()
            if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue {
                dics = result?["supplier_vehicle_list"]  as! Array<Dictionary<String, Any>>
            }
            else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
                dics = result?["warehouse_vehicle_list"]  as! Array<Dictionary<String, Any>>
            }
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
    
    private func callAPITransportMapping(vehicle_transport_id: Int, transaction_ids: [Int]) {
        // Call API
        var params = ["transaction_ids": transaction_ids] as [String : Any]
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue {
            params["supplier_vehicle_transport_id"] = vehicle_transport_id
            APIBase.sharedInstance()?.callAPITransportMapping(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransportMapping(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            params["warehouse_vehicle_transport_id"] = vehicle_transport_id
            APIBase.sharedInstance()?.callAPIWarehouseTransportMapping(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransportMapping(result: result, error: error)
            })
        }
    }
    
    private func completionAPITransportMapping(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            Util.showAlert("Mapping thành công", completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        else {
            // Call API Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
}

extension TransportMapVC: UITableViewDelegate, UITableViewDataSource {
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
        viewHeader.textLabel?.text = String(format: "%d %@", self.totalRecord, NSLocalizedString("Xe vận chuyển", comment: ""))
        
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
        let selectedVehicle : VehicleModel = self.vehicles[indexPath.row]
        var transactionIDs : [Int] = []
        
        for transaction in self.selectedTransactions{
            transactionIDs.append(transaction.id)
        }
        if let transport = selectedVehicle.transport {            
            self.callAPITransportMapping(vehicle_transport_id:transport.id, transaction_ids: transactionIDs)
        }
        else {
            Util.showAlert("Xe chưa được tạo mã vận chuyển")
        }
    }
}

extension TransportMapVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.callAPIVehicleList(isReload: true, searchKey: searchText)
    }
}

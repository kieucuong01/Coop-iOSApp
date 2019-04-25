//
//  DetailVehicleVC.swift
//  CoopApp-ios
//
//  Created by MAC on 3/20/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class DetailVehicleVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryLbl: UIButton!
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    var list: [TransactionModel] = []
    var transport : TransportModel?
    var vehicle: VehicleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initView(){
        self.title = NSLocalizedString("THÔNG TIN XE" , comment: "")
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "TẬP TRUNG", style: .plain, target: self, action: #selector(self.rightBarAction))
        //        self.callAPIGetCate()
        self.vehicle = self.data["vehicleModel"] as? VehicleModel
        self.transport = self.vehicle?.transport
        
        self.callAPIList(isReload: true)
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "VehicleInforTVC", bundle: nil), forCellReuseIdentifier: "vehicleInforTVC")
        self.tableView.register(UINib(nibName: "TransactionTVC", bundle: nil), forCellReuseIdentifier: "transactionTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIList(isReload: true)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIList(isReload: false)
            }
        }
    }
    
    private func callAPIList(isReload: Bool) {
        // Reset list of new
        if (isReload == true) { self.list.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        let params = ["transport_id" : self.transport?.id ?? 0,
                      "page": self.page] as [String : Any]
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue {
            APIBase.sharedInstance()?.callAPITransportTransaction(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIList(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue{
            APIBase.sharedInstance()?.callAPIWarehouseTransportTransaction(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIList(result: result, error: error)
            })
        }
    }
    
    private func completionAPIList(result : NSDictionary?, error : NSError?) {
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil && result != nil{
            // Success
            if result?["success"] as! Bool == true {
                let dics : Array<Dictionary<String,Any>> = result?["transaction_list"] as! Array<Dictionary<String, Any>>
                self.totalPage = result?["total_page"] as! Int
                self.totalRecord = result?["total_record"] as! Int
                for dic in dics {
                    self.list.append(TransactionModel(dict: dic))
                    
                }
                self.tableView.reloadData()
            }
            else {
                // Fail
                Util.showAlert(result?["detail"] as! String)
            }
        }
        else {
            // Call API Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
}

extension DetailVehicleVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    
    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40 * DISPLAY_SCALE
        }
        else {
            return 0
        }
    }
    
    // MARK: - UITableViewDataSource
    
    /*
     * Created by: cuongkt
     * Description: Number of section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /*
     * Created by: cuongkt
     * Description: Number of row in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.list.count
        }
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let viewHeader : UITableViewHeaderFooterView = UITableViewHeaderFooterView()
            viewHeader.textLabel?.text = String(format: "%d %@", self.totalRecord, NSLocalizedString("Sọt hàng", comment: ""))
            
            return viewHeader
        }
        else {return nil}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if let cell: TransactionTVC = tableView.dequeueReusableCell(withIdentifier: "transactionTVC") as? TransactionTVC {
                // Update index
                if self.list.indices.contains(indexPath.row){
                    let model : TransactionModel = self.list[indexPath.row]
                    cell.updateViewCell(model: model)
                }
                // Return cell
                return cell
            }
        }
        else if indexPath.section == 0 {
            if let cell: VehicleInforTVC = tableView.dequeueReusableCell(withIdentifier: "vehicleInforTVC") as? VehicleInforTVC {
                // Update index
                if let vehicleModel = self.vehicle {
                    cell.updateViewCell(model: vehicleModel)
                }
                cell.delegate = self
                // Return cell
                return cell
            }
        }
        
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DetailVehicleVC : VehicleInforTVCDelegate {
    func viewPositionBtnAction(sender: VehicleInforTVC) {
        if self.vehicle!.status != nil {
            if let vc = self.getViewController(storyboardName: "Vehicle", identifier: "mapVC") as? MapVC {
                vc.data = ["vehicleModel" : vehicle!]
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            Util.showAlert("Không có dữ liệu vị trí")
        }
    }
    
    func editBtnAction(sender: VehicleInforTVC) {
        if let vc = self.getViewController(storyboardName: "Vehicle", identifier: "editVehicleVC") as? EditVehicleVC {
            vc.data = ["Vehicle" : vehicle!]
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteBtnAction(sender: VehicleInforTVC) {
        self.callAPIDeleteVehicle(vehicleId: self.vehicle!.id)
    }
    
    private func callAPIDeleteVehicle(vehicleId: Int){
        // Call API
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
            let params = ["vehicle_id" : vehicleId] as [String : Any]
            APIBase.sharedInstance()?.callAPIDeleteVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIDeleteVehicle(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            let params = ["vehicle_id" : vehicleId] as [String : Any]
            APIBase.sharedInstance()?.callAPIDeleteWarehouseVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIDeleteVehicle(result: result, error: error)
            })
        }
    }
    
    private func completionAPIDeleteVehicle(result : NSDictionary?, error : NSError?){
        if error == nil{
            // Success
            Util.showAlert("Xóa thành công", completion: {
                self.popViewController(animated: false)
            })
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
}

extension DetailVehicleVC : EditVehicleVCDelegate {
    func editVehicleDone(editedVehicle: VehicleModel) {
        self.vehicle = editedVehicle
        self.tableView.reloadData()
    }
}

extension DetailVehicleVC : MapVCDelegate {
    func updatedStatusVehicle(statusID: VehicleStatus) {
        self.vehicle?.transport?.status_id = statusID.rawValue
    }
}

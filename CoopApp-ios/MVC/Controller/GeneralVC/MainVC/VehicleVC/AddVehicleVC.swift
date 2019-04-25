//
//  AddVehilceVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/11/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class AddVehicleVC: BaseViewController {
    @IBOutlet weak var plateNumberTf: UITextField!
    @IBOutlet weak var weightTf: UITextField!
    @IBOutlet weak var boxDimensionTf: UITextField!
    @IBOutlet weak var modelTf: UITextField!
    @IBOutlet weak var ownerTf: UITextField!
    @IBOutlet weak var driverTf: UITextField!
    @IBOutlet weak var mobileTf: UITextField!
    @IBOutlet weak var isActiveSw: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    private func initView() {
        self.title = "THÊM XE"
        
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue {
            self.ownerTf.text = GlobalQuick.userLogin?.supplier_name
            self.driverTf.text = GlobalQuick.userLogin?.full_name
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            self.ownerTf.text = "COOPMART"
            self.driverTf.text = "COOPMART"
        }
    }
    
    private func callAPIInsertVehicle() {
        // Call API
        var params = ["active_flag" : true,
                      "plate_number" : self.plateNumberTf.text!,
                      "box_dimension" : self.boxDimensionTf.text!,
                      "model" : self.modelTf.text!,
                      "owner" : self.ownerTf.text!,
                      "mobile" : self.mobileTf.text!,
                      "driver" : self.driverTf.text!] as [String : Any]
        
        if self.weightTf.text != ""{
            params["max_weight"] = self.weightTf.text
        }

        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
            params["supplier_id"] = GlobalQuick.userLogin?.supplier_id ?? 0

            APIBase.sharedInstance()?.callAPIInsertVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIInsertVehicle(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            APIBase.sharedInstance()?.callAPIInsertWarehouseVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIInsertVehicle(result: result, error: error)
            })
        }
    }
    
    private func completionAPIInsertVehicle(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            Util.showAlert("Thêm xe thành công", completion: {
                self.popViewController(animated: true)
            })
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    @IBAction func editBtnAction(_ sender: UIColorButton) {
        self.callAPIInsertVehicle()
    }
}

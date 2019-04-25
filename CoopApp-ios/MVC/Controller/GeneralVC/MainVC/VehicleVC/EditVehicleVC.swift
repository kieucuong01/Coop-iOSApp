//
//  EditVehicleVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/11/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

protocol EditVehicleVCDelegate : class {
    func editVehicleDone(editedVehicle : VehicleModel)
}

class EditVehicleVC: BaseViewController {
    
    var vehicle : VehicleModel?
    
    @IBOutlet weak var plateNumberTf: UITextField!
    @IBOutlet weak var weightTf: UITextField!
    @IBOutlet weak var boxDimensionTf: UITextField!
    @IBOutlet weak var modelTf: UITextField!
    @IBOutlet weak var ownerTf: UITextField!
    @IBOutlet weak var driverTf: UITextField!
    @IBOutlet weak var mobileTf: UITextField!
    @IBOutlet weak var isActiveSw: UISwitch!
    
    weak var delegate:EditVehicleVCDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vehicle = self.data["Vehicle"] as? VehicleModel {
            self.vehicle = vehicle
        }
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    private func initView() {
        self.title = "SỬA XE"
        
        self.plateNumberTf.text = self.vehicle?.plate_number
        self.weightTf.text = String(format: "%d", self.vehicle?.max_weight ?? 0)
        self.boxDimensionTf.text = self.vehicle?.box_dimension
        self.modelTf.text = self.vehicle?.model
        self.ownerTf.text = self.vehicle?.owner
        self.driverTf.text = self.vehicle?.driver_name
        self.mobileTf.text = self.vehicle?.mobile
    }
    
    private func callAPIEditVehicle() {
        // Call API
        var params = ["vehicle_id" : self.vehicle?.id ?? 0,
                      "plate_number" : self.plateNumberTf.text!,
                      "box_dimension" : self.boxDimensionTf.text!,
                      "model" : self.modelTf.text!,
                      "owner" : self.ownerTf.text!,
                      "driver" : self.driverTf.text!,
                      "mobile" : self.mobileTf.text!] as [String : Any]
        
        if self.weightTf.text != ""{
            params["max_weight"] = self.weightTf.text
        }
        
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
            
            APIBase.sharedInstance()?.callAPIEditVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIEditVehicle(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule ==  UserRole.Warehouse.rawValue {
            APIBase.sharedInstance()?.callAPIEditWarehouseVehicle(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIEditVehicle(result: result, error: error)
            })
        }
    }
    
    private func completionAPIEditVehicle(result : NSDictionary?, error : NSError?){
        if error == nil{
            let editedVehicle = VehicleModel(dict: result!["vehicle"] as! Dictionary<String,Any>) 
            // Success
            Util.showAlert("Sửa thông tin xe thành công", completion: {
                self.delegate?.editVehicleDone(editedVehicle: editedVehicle)
                self.popViewController(animated: true)
            })
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    @IBAction func editBtnAction(_ sender: UIColorButton) {
        self.callAPIEditVehicle()
    }        
}

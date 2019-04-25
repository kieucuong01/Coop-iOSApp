//
//  VehicleModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/6/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class VehicleModel: NSObject {
    var id: Int = 0
    var phone: String = ""
    var box_dimension: String = ""
    var mobile: String = ""
    var owner: String = ""
    var created_at: String = ""
    var transport: TransportModel?
    var plate_number: String = ""
    var active_flag: Bool = false
    var max_weight: Int = 0
    var driver_name: String = ""
    var model: String = ""
    var supplier: SupplierModel?
    var status: StatusVehicleModel?
    
    // Map function
    override init(){}
    
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let phone:String = dict["phone"] as? String {
            self.phone = phone
        }
        
        if let box_dimension:String = dict["box_dimension"] as? String {
            self.box_dimension = box_dimension
        }

        if let mobile:String = dict["mobile"] as? String {
            self.mobile = mobile
        }

        if let owner:String = dict["owner"] as? String {
            self.owner = owner
        }

        if let created_at:String = dict["created_at"] as? String {
            self.created_at = created_at
        }

        if let transport:Dictionary<String,Any> = dict["transport"] as? Dictionary<String,Any> {
            self.transport = TransportModel(dict: transport)
        }
        
        if let plate_number:String = dict["plate_number"] as? String {
            self.plate_number = plate_number
        }
        
        if let active_flag:Bool = dict["active_flag"] as? Bool {
            self.active_flag = active_flag
        }
        
        if let max_weight:Int = dict["max_weight"] as? Int {
            self.max_weight = max_weight
        }
        
        if let driver_name:String = dict["driver_name"] as? String {
            self.driver_name = driver_name
        }
        
        if let model:String = dict["model"] as? String {
            self.model = model
        }
        
        if let supplier:Dictionary<String,Any> = dict["supplier"] as? Dictionary<String,Any> {
            self.supplier = SupplierModel(dict: supplier)
        }
        
        if let status:Dictionary<String,Any> = dict["status"] as? Dictionary<String,Any> {
            self.status = StatusVehicleModel(dict: status)
        }
    }
}

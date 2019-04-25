//
//  SupplierModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/6/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class SupplierModel: BaseModel {
    var address: String = ""
    var owner: String = ""
    var mobile: String = ""
    var id: Int = 0
    var district: String = ""
    var ward: String = ""
    var type: Dictionary<String, Any> = Dictionary<String,Any>()
    var name: String = ""
    var province: String = ""
    
    // Map function
    override init(){}

    init (dict: Dictionary<String, Any>) {
        if let address:String = dict["address"] as? String {
            self.address = address
        }
        
        if let owner:String = dict["owner"] as? String {
            self.owner = owner
        }
        
        if let mobile:String = dict["mobile"] as? String {
            self.mobile = mobile
        }
        
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let district:String = dict["district"] as? String {
            self.district = district
        }
        
        if let type:Dictionary<String,Any> = dict["type"] as? Dictionary<String,Any> {
            self.type = type
        }
        
        if let ward:String = dict["ward"] as? String {
            self.ward = ward
        }
        
        if let name:String = dict["name"] as? String {
            self.name = name
        }
        
        if let province:String = dict["province"] as? String {
            self.province = province
        }
    }
}

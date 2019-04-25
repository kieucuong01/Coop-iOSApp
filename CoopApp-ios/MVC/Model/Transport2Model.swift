//
//  Transport2Model.swift
//  CoopApp-ios
//
//  Created by MAC on 3/22/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class Transport2Model: NSObject {
    var code: String = ""
    var id: Int = 0
    var start_at: String = ""
    var finished_at: String = ""
    var vehicle : VehicleModel?
    
    // Map function
    override init(){}
    
    init (dict: Dictionary<String, Any>) {
        if let code:String = dict["code"] as? String {
            self.code = code
        }
        
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let start_at:String = dict["start_at"] as? String {
            self.start_at = start_at
        }
        
        if let finished_at:String = dict["finished_at"] as? String {
            self.finished_at = finished_at
        }
        
        if let vehicle : Dictionary<String,Any> = dict["vehicle"] as? Dictionary<String,Any>{
            self.vehicle = VehicleModel(dict: vehicle)
        }
    }
}

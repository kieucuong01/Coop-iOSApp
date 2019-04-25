//
//  ProductPackingModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class ProductPacking: NSObject {
    var id: Int = 0
    var value: Int = 0
    var unit: String = ""
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let value:Int = dict["value"] as? Int {
            self.value = value
        }
        
        if let unit:String = dict["unit"] as? String {
            self.unit = unit
        }
    }
}

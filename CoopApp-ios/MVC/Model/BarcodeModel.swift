//
//  BarcodeModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class BarcodeModel: NSObject {
    var id: Int = 0
    var type: String = ""
    var created_at: String = ""
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let type:String = dict["type"] as? String {
            self.type = type
        }
        
        if let created_at:String = dict["created_at"] as? String {
            self.created_at = created_at
        }
    }
}

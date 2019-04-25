//
//  OrderBranchModel.swift
//  CoopApp-ios
//
//  Created by MAC on 4/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class OrderBranchModel: NSObject {
    var id: Int = 0
    var is_finish: Bool = true
    var create_at: String = ""
    var branch: BranchModel?
    var order_date: String = ""
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let is_finish:Bool = dict["is_finish"] as? Bool {
            self.is_finish = is_finish
        }
        
        if let order_date : String = dict["order_date"] as? String {
            self.order_date = order_date
        }
        
        if let created_at : String = dict["created_at"] as? String {
            self.create_at = created_at
        }
        
        if let branch : Dictionary<String,Any>  = dict["branch"] as? Dictionary<String,Any> {
            self.branch = BranchModel(dict: branch)
        }
    }
}

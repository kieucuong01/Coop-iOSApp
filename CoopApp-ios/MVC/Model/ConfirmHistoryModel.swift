//
//  ConfirmHistoryModel.swift
//  CoopApp-ios
//
//  Created by MAC on 3/27/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class ConfirmHistoryModel: NSObject {
    var id: Int = 0
    var passed_flag: Bool = true
    var reason: String = ""
    var quantity: Double = 0.0
    var created_at: String = ""
    var packing: ProductPacking?
    var branch: BranchModel?
    var image_list: [WitnessModel] = []
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        if let passed_flag:Bool = dict["passed_flag"] as? Bool {
            self.passed_flag = passed_flag
        }
        
        if let reason : String = dict["reason"] as? String {
            self.reason = reason
        }
        
        if let quantity : Double = dict["quantity"] as? Double {
            self.quantity = quantity
        }
        
        if let created_at : String = dict["created_at"] as? String {
            self.created_at = created_at
        }
        if let branch : Dictionary<String,Any>  = dict["branch"] as? Dictionary<String,Any> {
            self.branch = BranchModel(dict: branch)
        }
        
        if let image_list: Array<Dictionary<String,Any>> = dict["image_list"] as? Array<Dictionary<String,Any>>{
            for image in image_list {
                self.image_list.append(WitnessModel(dict: image))
            }
        }
    }
}

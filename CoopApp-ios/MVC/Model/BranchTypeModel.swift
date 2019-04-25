//
//  BranchTypeModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/13/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class BranchTypeModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var branchId : Int = 0
    var branchName : String = ""
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let name:String = dict["name"] as? String {
            self.name = name
        }
        
        if let branch_category:Dictionary<String,Any> = dict["branch_category"] as? Dictionary<String,Any> {
            
            if let branchId:Int = branch_category["id"] as? Int {
                self.branchId = branchId
            }
            
            if let branchName:String = branch_category["name"] as? String {
                self.branchName = branchName
            }
        }
    }
}

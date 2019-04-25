//
//  BranchModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class BranchModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var type: String = ""
    var avatar: String = ""
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let name:String = dict["name"] as? String {
            self.name = name
        }
        
        if let type:String = dict["type"] as? String {
            self.type = type
        }
        
        if let avatar:String = dict["avatar"] as? String {
            self.avatar = avatar
        }
    }
}

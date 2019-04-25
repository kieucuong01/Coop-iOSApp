//
//  UserLoginModel.swift
//  OwnersClub-ios
//
//  Created by KTC on 7/11/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//
import UIKit

class UserLoginModel: NSObject, NSCoding {
    static let keyModel : String = "userloginmodel"
    // Attributes
    var user_id: Int?
    var user_type_id: Int?
    var branch_id: Int?
    var full_name: String = ""
    var mobile: String = ""
    var avatar_url: String = ""
    var key: String = ""
    var branch_name: String = ""
    var rule: String = ""
    var user_type_code: String = ""
    var user_type_name: String = ""
    var supplier_id : Int?
    var supplier_name : String = ""
    var warehouse_id : Int?
    var warehouse_name : String = ""
    var supermarket_id : Int?
    var supermarket_name : String = ""

//    var config : NSDictionary?
    
    // Init
    override init() {
    }
    
    init(dict : NSDictionary) {
        super.init()
        if let user_id:Int = dict["user_id"] as? Int {
            self.user_id = user_id
        }

        if let user_type_id:Int = dict["user_type_id"] as? Int {
            self.user_type_id = user_type_id
        }

        if let branch_id:Int = dict["branch_id"] as? Int {
            self.branch_id = branch_id
        }

        if let full_name = dict["full_name"] as? String {
            self.full_name = full_name
        }
        
        if let mobile = dict["mobile"] as? String {
            self.mobile = mobile
        }
        
        if let avatar_url = dict["avatar_url"] as? String {
            self.avatar_url = avatar_url
        }
        
        if let key = dict["key"] as? String {
            self.key = key
        }
        
        if let branch_name = dict["branch_name"] as? String {
            self.branch_name = branch_name
        }
        
        if let rule = dict["rule"] as? String {
            self.rule = rule
        }
        if let user_type_code = dict["user_type_code"] as? String {
            self.user_type_code = user_type_code
        }
        
        if let user_type_name = dict["user_type_name"] as? String {
            self.user_type_name = user_type_name
        }
        
        if let supplier_id:Int = dict["supplier_id"] as? Int {
            self.supplier_id = supplier_id
        }
        
        if let supplier_name = dict["supplier_name"] as? String {
            self.supplier_name = supplier_name
        }
        
        if let supermarket_id:Int = dict["supermarket_id"] as? Int {
            self.supermarket_id = supermarket_id
        }
        
        if let supermarket_name = dict["supermarket_name"] as? String {
            self.supermarket_name = supermarket_name
        }
        
//        if let config = dict["config"] as? NSDictionary {
//            self.config = config
//        }
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.user_id = aDecoder.decodeObject(forKey: "user_id") as? Int
        self.user_type_id = aDecoder.decodeObject(forKey: "user_type_id") as? Int
        self.branch_id = aDecoder.decodeObject(forKey: "branch_id") as? Int
        self.full_name = aDecoder.decodeObject(forKey: "full_name") as! String
        self.mobile = aDecoder.decodeObject(forKey: "mobile") as! String
        self.avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as! String
        self.key = aDecoder.decodeObject(forKey: "key") as! String
        self.branch_name = aDecoder.decodeObject(forKey: "branch_name") as! String
        self.rule = aDecoder.decodeObject(forKey: "rule") as! String
        self.user_type_code = aDecoder.decodeObject(forKey: "user_type_code") as! String
        self.user_type_name = aDecoder.decodeObject(forKey: "user_type_name") as! String
        self.supplier_id = aDecoder.decodeObject(forKey: "supplier_id") as? Int
        self.supplier_name = aDecoder.decodeObject(forKey: "supplier_name") as! String
        self.warehouse_id = aDecoder.decodeObject(forKey: "warehouse_id") as? Int
        self.warehouse_name = aDecoder.decodeObject(forKey: "warehouse_name") as! String
        self.supermarket_id = aDecoder.decodeObject(forKey: "supermarket_id") as? Int
        self.supermarket_name = aDecoder.decodeObject(forKey: "supermarket_name") as! String

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(user_type_id, forKey: "user_type_id")
        aCoder.encode(branch_id, forKey: "branch_id")
        aCoder.encode(full_name, forKey: "full_name")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(avatar_url, forKey: "avatar_url")
        aCoder.encode(key, forKey: "key")
        aCoder.encode(branch_name, forKey: "branch_name")
        aCoder.encode(rule, forKey: "rule")
        aCoder.encode(user_type_code, forKey: "user_type_code")
        aCoder.encode(user_type_name, forKey: "user_type_name")
        aCoder.encode(supplier_id, forKey: "supplier_id")
        aCoder.encode(supplier_name, forKey: "supplier_name")
        aCoder.encode(warehouse_id, forKey: "warehouse_id")
        aCoder.encode(warehouse_name, forKey: "warehouse_name")
        aCoder.encode(supermarket_id, forKey: "supermarket_id")
        aCoder.encode(supermarket_name, forKey: "supermarket_name")
    }

}

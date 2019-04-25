//
//  File.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class ProductModel: BaseModel {
    
    var id: Int? = nil
    var sku: Int? = nil
    var name: String? = nil
    var avatar: String? = nil
    var categoryId: Int? = nil
    var categoryName: String? = nil
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let sku:Int = dict["sku"] as? Int {
            self.sku = sku
        }
        
        if let name:String = dict["name"] as? String {
            self.name = name
        }
        
        if let avatar:String = dict["avatar"] as? String {
            self.avatar = avatar
        }
        
        if let category:Dictionary<String,Any> = dict["category"] as? Dictionary<String,Any> {
            if let categoryId : Int = category["id"] as? Int {
                self.categoryId = categoryId
            }
            if let categoryName : String = category["name"] as? String {
                self.categoryName = categoryName
            }
        }
    }
}

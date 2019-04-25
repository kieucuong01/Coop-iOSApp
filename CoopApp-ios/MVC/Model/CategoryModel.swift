//
//  CategoryModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/8/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class CategoryModel: NSObject {
    var id: Int = 0
    var name: String = ""
    
    // Map function
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let name:String = dict["name"] as? String {
            self.name = name
        }
    }
}

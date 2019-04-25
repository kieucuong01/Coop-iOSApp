//
//  TransportModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/6/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class TransportModel: NSObject {
    var code: String = ""
    var id: Int = 0
    var transactions: Int = 0
    var basket: Int = 0
    var container: Int = 0
    var start_at: String = ""
    var status_id: Int = 0

    // Map function
    override init(){}

    init (dict: Dictionary<String, Any>) {
        if let code:String = dict["code"] as? String {
            self.code = code
        }
        
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let transactions:Int = dict["transactions"] as? Int {
            self.transactions = transactions
        }

        if let basket:Int = dict["baskets"] as? Int {
            self.basket = basket
        }

        if let container:Int = dict["containers"] as? Int {
            self.container = container
        }
        
        if let start_at:String = dict["start_at"] as? String {
            self.start_at = start_at
        }
        
        if let status_id:Int = dict["status_id"] as? Int {
            self.status_id = status_id
        }
    }
}

//
//  TransactionModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class TransactionModel: BaseModel {
    var vehicle_transport_id: Int = 0
    var vehicle_transport_code: String = ""
    var id: Int = 0
    var quantity: Double = 0.0
    var branch: BranchModel? = nil
    var to_branch: BranchModel? = nil
    var from_branch: BranchModel? = nil
    var created_at: String = ""
    var product: ProductModel? = nil
    var basket: BasketModel? = nil
    var container: ContainerModel? = nil
    var passed_flag: Bool = false
    var product_packing: ProductPacking? = nil
    var supplier: SupplierModel? = nil

    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let vehicle_transport_id:Int = dict["vehicle_transport_id"] as? Int {
            self.vehicle_transport_id = vehicle_transport_id
        }
        
        if let vehicle_transport_code:String = dict["vehicle_transport_code"] as? String {
            self.vehicle_transport_code = vehicle_transport_code
        }
        
        if let quantity:Double = dict["quantity"] as? Double {
            self.quantity = quantity
        }
        
        if let vehicle_transport_id:Int = dict["vehicle_transport_id"] as? Int {
            self.vehicle_transport_id = vehicle_transport_id
        }
        
        if let created_at:String = dict["created_at"] as? String {
            self.created_at = created_at
        }
        
        if let passed_flag:Bool = dict["passed_flag"] as? Bool {
            self.passed_flag = passed_flag
        }
        
        if let branch:Dictionary<String,Any> = dict["branch"] as? Dictionary<String,Any> {
            self.branch = BranchModel(dict: branch)
        }
        
        if let to_branch:Dictionary<String,Any> = dict["to_branch"] as? Dictionary<String,Any> {
            self.to_branch = BranchModel(dict: to_branch)
        }
        
        if let from_branch:Dictionary<String,Any> = dict["from_branch"] as? Dictionary<String,Any> {
            self.from_branch = BranchModel(dict: from_branch)
        }
        
        if let product:Dictionary<String,Any> = dict["product"] as? Dictionary<String,Any> {
            self.product = ProductModel(dict: product)
        }
        
        if let supplier:Dictionary<String,Any> = dict["supplier"] as? Dictionary<String,Any> {
            self.supplier = SupplierModel(dict: supplier)
        }
        
        if let basket:Dictionary<String,Any> = dict["basket"] as? Dictionary<String,Any> {
            self.basket = BasketModel(dict: basket)
        }
        
        if let product_packing:Dictionary<String,Any> = dict["product_packing"] as? Dictionary<String,Any> {
            self.product_packing = ProductPacking(dict: product_packing)
        }
        
        if let container:Dictionary<String,Any> = dict["container"] as? Dictionary<String,Any> {
            self.container = ContainerModel(dict: container)
        }
    }
}

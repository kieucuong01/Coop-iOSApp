//
//  OrderModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

// MARK: - Model
class OrderModel: NSObject {
    
    var id: Int = 0
    var quantity: Double = 0.0
    var sale_order_id: Int = 0
    var sale_order_supplier_sum: Double = 0.0
    var sale_order_warehouse_sum: Double = 0
    var sale_order_warehouse_confirm: Double = 0
    var sale_order_supplier_confirm: Double = 0
    var created_at: String = ""
    var product_packing_id: Int = 0
    var product_packing_value: Int = 0
    var product_packing_unit: String = ""
    var order_type_id: Int = 0
    var order_type_name: String = ""
    
    var product: ProductModel? = nil 
    var branch: BranchModel? = nil
    
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let quantity:Double = dict["quantity"] as? Double {
            self.quantity = quantity
        }
        
        if let sale_order_id:Int = dict["sale_order_id"] as? Int {
            self.sale_order_id = sale_order_id
        }
        
        if let sale_order_supplier_sum:Double = dict["sale_order_supplier_sum"] as? Double {
            self.sale_order_supplier_sum = sale_order_supplier_sum
        }
        
        if let sale_order_warehouse_sum:Double = dict["sale_order_warehouse_sum"] as? Double {
            self.sale_order_warehouse_sum = sale_order_warehouse_sum
        }
        
        if let sale_order_warehouse_confirm:Double = dict["sale_order_warehouse_confirm"] as? Double {
            self.sale_order_warehouse_confirm = sale_order_warehouse_confirm
        }
        
        if let sale_order_supplier_confirm:Double = dict["sale_order_supplier_confirm"] as? Double {
            self.sale_order_supplier_confirm = sale_order_supplier_confirm
        }
        
        if let created_at:String = dict["created_at"] as? String {
            self.created_at = created_at
        }
        
        if let productPacking:Dictionary<String,Any> = dict["product_packing"] as? Dictionary<String,Any> {
            if let product_packing_id : Int = productPacking["id"] as? Int {
                self.product_packing_id = product_packing_id
            }
            if let product_packing_value : Int = productPacking["value"] as? Int {
                self.product_packing_value = product_packing_value
            }
            if let product_packing_unit : String = productPacking["unit"] as? String {
                self.product_packing_unit = product_packing_unit
            }
        }
        
        if let orderType:Dictionary<String,Any> = dict["order_type"] as? Dictionary<String,Any> {
            if let order_type_id : Int = orderType["id"] as? Int {
                self.order_type_id = order_type_id
            }
            if let order_type_name : String = orderType["name"] as? String {
                self.order_type_name = order_type_name
            }
        }
        
        if let product:Dictionary<String,Any> = dict["product"] as? Dictionary<String,Any> {
            self.product = ProductModel(dict: product)
        }
        
        if let branch:Dictionary<String,Any> = dict["branch"] as? Dictionary<String,Any> {
            self.branch = BranchModel(dict: branch)
        }

    }
    
    func updateValue(order : OrderModel) {
        self.sale_order_supplier_sum  = order.sale_order_supplier_sum
        self.sale_order_warehouse_sum = order.sale_order_warehouse_sum
        self.sale_order_warehouse_confirm = order.sale_order_warehouse_confirm
        self.sale_order_supplier_confirm = order.sale_order_supplier_confirm
    }
}

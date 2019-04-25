//
//  ContainerModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/7/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class ContainerModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var barcode: String = ""
    var description2: String = ""
    var type: String = ""
    var barcodeImg: UIImage?
    
    // Map function
    init(id: Int, barcode: String){
        self.id = id
        self.barcode = barcode
    }
    
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let name:String = dict["name"] as? String {
            self.name = name
        }
        
        if let barcode:String = dict["barcode"] as? String {
            self.barcode = barcode
            
            self.barcodeImg = try? QRCode(string: self.barcode, size: CGSize(width: 100, height: 100))!.image()
        }
        
        if let description2:String = dict["description"] as? String {
            self.description2 = description2
        }
        
        if let type:String = dict["type"] as? String {
            self.type = type
        }        
    }
}

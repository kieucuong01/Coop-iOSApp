//
//  BasketModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import UIKit

class BasketModel: NSObject {
    var id: Int = 0
    var rfid: String = ""
    var barcode: String = ""
    var location: String = ""
    var start_date: String = ""
    var end_date: String = ""
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
        
        if let rfid:String = dict["rfid"] as? String {
            self.rfid = rfid
        }
        
        if let barcode:String = dict["barcode"] as? String {
            self.barcode = barcode
            
            self.barcodeImg = try? QRCode(string: self.barcode, size: CGSize(width: 100, height: 100))!.image()
        }
        
        if let location:String = dict["location"] as? String {
            self.location = location
        }

        if let start_date:String = dict["start_date"] as? String {
            self.start_date = start_date
        }

        if let end_date:String = dict["end_date"] as? String {
            self.end_date = end_date
        }
    }
}

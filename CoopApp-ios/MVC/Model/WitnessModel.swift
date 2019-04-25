//
//  WitnessModel.swift
//  CoopApp-ios
//
//  Created by MAC on 4/2/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class WitnessModel: NSObject {
    var id: Int = 0
    var create_at: String = ""
    var image: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let id:Int = dict["id"] as? Int {
            self.id = id
        }
        
        if let image : String = dict["image"] as? String {
            self.image = image
        }
        
        if let created_at : String = dict["created_at"] as? String {
            self.create_at = created_at
        }
        
        if let lat : Double = dict["lat"] as? Double {
            self.lat = lat
        }
        
        if let lon : Double = dict["lon"] as? Double {
            self.lon = lon
        }
    }
}

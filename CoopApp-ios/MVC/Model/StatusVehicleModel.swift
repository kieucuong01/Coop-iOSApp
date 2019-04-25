//
//  StatusVehicleModel.swift
//  CoopApp-ios
//
//  Created by MAC on 3/20/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

class StatusVehicleModel: NSObject {
    var lat: Double = 0.0
    var lon: Double = 0.0
    var speed: Int = 0
    
    // Map function
    init (dict: Dictionary<String, Any>) {
        if let lat:Double = dict["lat"] as? Double {
            self.lat = lat
        }
        if let lon:Double = dict["lon"] as? Double {
            self.lon = lon
        }
        
        if let speed:Int = dict["speed"] as? Int {
            self.speed = speed
        }
    }
}

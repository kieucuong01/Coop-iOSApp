//
//  ParkingPlaceModel.swift
//  ParkingManagementApp-ios
//
//  Created by KTC on 10/26/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import CoreLocation

class ParkingPlaceModel: NSObject {
    static let keyModel : String = "usermodel"
    // Attributes
    var id: String = ""
    var name: String = ""
    var address: String = ""
    var status: Int = 0
    let coordinate: CLLocationCoordinate2D
    
    // Init
    init(json: [Any]) {
        // 1
        if let title = json[0] as? String {
            self.name = title
        } else {
            self.name = "No Name"
        }
        self.address = json[1] as! String
        self.status = json[2] as! Int
        // 2
        if let latitude = Double(json[3] as! String),
            let longitude = Double(json[4] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }

}

//
//  BuildingModel.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/28/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import ObjectMapper

class BuildingModel: Mappable {
    var id : String = ""
    var imageURL : String = ""
    var name : String = ""
    var address : String = ""

    // Init
    init() {
    }

    // Init with parameter
    init(id: String, imageURL: String, name: String, address: String) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.address = address
    }

    // Init by map
    required init?(map: Map) {
        mapping(map: map)
    }

    // Map function
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.imageURL <- map["image_url"]
        self.address <- map["address1"]
    }

}

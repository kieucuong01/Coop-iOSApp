//
//  ChartDataModel.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 7/6/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//


import UIKit
import ObjectMapper

class ChartDataModel: Mappable {
    var value : Int = 0
    var month : UInt8 = 0
    var year : UInt16 = 0

    // Init
    init() {
    }

    // Init with parameter
    init(value: Int, month: UInt8, year: UInt16) {
        self.value = value
        self.month = month
        self.year = year
    }

    // Init by map
    required init?(map: Map) {
        mapping(map: map)
    }

    // Map function
    func mapping(map: Map) {
        self.value <- map["title"]
        self.month <- map["date"]
        self.year <- map["content"]
    }
}


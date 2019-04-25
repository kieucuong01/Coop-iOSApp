//
//  MonthyReportModel.swift
//  OwnersClub-ios
//
//  Created by KTC on 7/12/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import ObjectMapper

// MARK: - Model
class MonthyDataModel : Mappable {
    static let keyModel : String = "monthy_data_model"
    // Attributes
    var year : UInt16 = 0
    var month : UInt8 = 0
    var residentsTotal : Int = 0
    var roomsTotal : Int = 0
    var tenancyRate : Int = 0

    // Init
    init() {
    }
    
    // Init by map
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    // Map function
    func mapping(map: Map) {
        self.year <- map["year"]
        self.month <- map["month"]
        self.residentsTotal <- map["residents_total"]
        self.roomsTotal <- map["rooms_total"]
        self.tenancyRate <- map["tenancy_rate"]
    }
}

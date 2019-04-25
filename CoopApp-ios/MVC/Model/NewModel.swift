//
//  NewModel.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/28/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import ObjectMapper

// MARK: - Model
class NewModel: Mappable {
    var identify: Int? = nil
    var title: String? = nil
    var content: String? = nil
    var date: String? = nil
    var isRead: Bool? = nil

    // Init
    init() {
    }

    // Init with parameter
    init(title: String, content: String, date: String) {
        self.title = title
        self.content = content
        self.date = date
    }

    // Init by map
    required init?(map: Map) {
        mapping(map: map)
    }

    // Map function
    func mapping(map: Map) {
        self.identify <- map["id"]
        self.title <- map["title"]
        self.content <- map["content"]
        self.date <- map["public_date"]
        self.isRead <- map["is_read"]
    }
}

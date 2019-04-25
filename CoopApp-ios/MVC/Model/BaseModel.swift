//
//  BaseModel.swift
//  CoopApp-ios
//
//  Created by MAC on 3/26/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    // Key Name Model
    static var keyModel: String {
        return String(describing: self)
    }
}

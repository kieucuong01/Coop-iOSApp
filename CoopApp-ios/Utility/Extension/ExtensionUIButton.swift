//
//  ExtensionUIButton.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/21/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var localizedText : String {
        set(value) {
            self.setTitle(NSLocalizedString(value, comment: ""), for: .normal)
        }
        get {
            return "xxx"
        }
    }
}

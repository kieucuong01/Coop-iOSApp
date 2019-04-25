//
//  ExtensionUILabel.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/21/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable var localizedText : String {
        set(value) {
            self.text = NSLocalizedString(value, comment: "")
        }
        get {
            return self.text!
        }
    }
}

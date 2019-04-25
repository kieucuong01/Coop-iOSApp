//
//  UIAppEngLabel.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 7/4/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//
import UIKit

@IBDesignable
class UIAppEngLabel: UILabel {
    var colorsText : [UIColor?] = [PRIMARY_COLOR, GRAY1_COLOR, GRAY2_COLOR, GRAY3_COLOR,GRAY4_COLOR, WHITE_COLOR]

    @IBInspectable var mSize : CGFloat {
        set(value) {
            self.font = UIFont(name: self.font.fontName, size: value * DISPLAY_SCALE)
        }
        get {
            return 50.0
        }
    }

    @IBInspectable var isBold : Bool {
        set(value) {
            if value == true {
                self.font = UIFont(name: PRIMARY_ENGLISH_FONT_NAME_MEDIUM, size: self.font.pointSize)
            }
            else {
                self.font = UIFont(name: PRIMARY_ENGLISH_FONT_NAME_REGULAR, size: self.font.pointSize)
            }

        }
        get {
            return false
        }
    }

    @IBInspectable var colorAdapter : Int {
        set(value) {
            if colorsText.indices.contains(value) == true {
                self.textColor = colorsText[value]
            }
            else {
                self.textColor = BLACK_COLOR
            }

        }
        get {
            return 100
        }
    }
}



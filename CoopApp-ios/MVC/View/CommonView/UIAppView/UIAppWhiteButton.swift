//
//  UIAppButton.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 3/1/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

@IBDesignable
class UIAppWhiteButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        self.layer.cornerRadius = 27 * DISPLAY_SCALE
        self.setTitleColor(PRIMARY_COLOR, for: .normal)
        self.layer.backgroundColor = WHITE_COLOR.cgColor
        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 18 * DISPLAY_SCALE)
        self.applySketchShadow(color: GRAY1_COLOR, alpha: 0.5, x: 0.0, y: 4.0, blur: 8, spread: 0)
    }
}


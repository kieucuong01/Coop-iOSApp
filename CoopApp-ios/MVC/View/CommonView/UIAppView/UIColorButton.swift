//
//  UIColorButton.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 3/1/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class UIColorButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.tintColor = PRIMARY_COLOR
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.backgroundColor = PRIMARY_COLOR.cgColor
        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 15 * DISPLAY_SCALE)
    }

}

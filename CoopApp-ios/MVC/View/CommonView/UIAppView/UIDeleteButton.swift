//
//  UIColorButton.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 3/1/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class UIDeleteButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.tintColor = .red
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.backgroundColor = UIColor.red.cgColor
        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 15 * DISPLAY_SCALE)
    }

}

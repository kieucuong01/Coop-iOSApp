//
//  UILabelButton.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/22/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class UILabelBlackButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.setTitleColor(BLACK_COLOR, for: .normal)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: (self.titleLabel?.font.pointSize)! * DISPLAY_SCALE)
    }
}

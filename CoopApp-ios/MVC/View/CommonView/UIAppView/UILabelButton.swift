//
//  UILabelButton.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/22/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

//@IBDesignable
//class UILabelButton: UIButton {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setup()
//    }
//    func setup() {
//        self.setTitleColor(PRIMARY_COLOR, for: .normal)
//        self.layer.backgroundColor = UIColor.clear.cgColor
//        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: (self.titleLabel?.font.pointSize)! * DISPLAY_SCALE)
//    }
//}
class UILabelButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.setTitleColor(PRIMARY_COLOR, for: .normal)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: (self.titleLabel?.font.pointSize)! * DISPLAY_SCALE)
    }
}

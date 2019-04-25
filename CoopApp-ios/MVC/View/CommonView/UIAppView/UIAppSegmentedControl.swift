//
//  UIAppSegmentedControl.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/30/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class UIAppSegmentedControl: UISegmentedControl {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
    }
    func setup() {
        self.tintColor = PRIMARY_COLOR
        self.layer.cornerRadius = self.layer.frame.size.height/2.0
        self.layer.borderColor = PRIMARY_COLOR.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        let attr = NSDictionary(object: UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 14.0 * DISPLAY_SCALE)!, forKey: NSAttributedStringKey.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
    }
    
}

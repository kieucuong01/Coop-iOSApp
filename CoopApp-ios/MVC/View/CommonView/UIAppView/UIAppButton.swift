//
//  UIAppButton.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 3/1/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class UIAppButton: UIButton {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = self.frame.height/2.0
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 18 * DISPLAY_SCALE)
        
        // Check enable state
        self.checkStateForEnable()
    }
    
    override var isEnabled: Bool {
        didSet {
            // Check enable state
            self.checkStateForEnable()
        }
    }
    
    // MARK: - Private Methods
    
    private func checkStateForEnable() {
        // Enabled
        if (self.isEnabled == true) {
            self.layer.backgroundColor = PRIMARY_COLOR.cgColor
            self.applySketchShadow(color: GRAY1_COLOR, alpha: 0.5, x: 0.0, y: 4.0, blur: 8, spread: 0)
        }
            // Disabled
        else {
            self.layer.backgroundColor = GRAY4_COLOR.cgColor
            self.applySketchShadow(color: GRAY1_COLOR, alpha: 0, x: 0.0, y: 0.0, blur: 0, spread: 0)
        }
    }
}

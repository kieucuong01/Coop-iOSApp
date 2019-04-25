//
//  UIScureTextFieldView.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/22/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class UIScureTextFieldView: UIAppTextFieldView {

    override func xibSetup() {
        self.isHasButton = true
        super.xibSetup()
        self.button.isHidden = true
        self.textField.isSecureTextEntry = true
        self.button.addTarget(self, action: #selector(self.hideOrShowPass(sender : )), for: .touchUpInside)
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }

    @objc func hideOrShowPass(sender : UIButton) {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        self.updateButtonImage()
    }

    func updateButtonImage(){
        if self.textField.isSecureTextEntry == false {
            self.button.setImage(#imageLiteral(resourceName: "passHide"), for: .normal)
        }
        else {
            self.button.setImage(#imageLiteral(resourceName: "passShow"), for: .normal)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.textField.text != ""{
            self.button.isHidden = false
            self.widthButton.constant = 52 * DISPLAY_SCALE
        }
        else {
            self.button.isHidden = true
            self.widthButton.constant = 0
        }
    }
}

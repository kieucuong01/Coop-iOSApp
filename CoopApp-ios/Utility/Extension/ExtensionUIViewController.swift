//
//  ExtensionUIViewController.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 3/16/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import Foundation
import UIKit

extension BaseViewController {
    func hideKeyboardNErrorTapAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(BaseViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
        self.navigationItem.titleView?.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        self.hideTopError()
        self.hideTintTopError()
        if let d = self.drawer() {
            d.showLeftSlider(isShow: false)
            d.showRightSlider(isShow: false)
        }
        view.endEditing(true)
    }
}

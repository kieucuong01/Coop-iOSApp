//
//  NavbarVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/28/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class NavbarVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.topItem?.title = GlobalQuick.userLogin?.full_name
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = PRIMARY_COLOR
        self.navigationBar.backgroundColor = PRIMARY_COLOR
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.hideMenuTapAround()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.dismissKeyboard()
    }
    
    func hideMenuTapAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        self.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        if let d = self.drawer() {
            d.showLeftSlider(isShow: false)
            d.showRightSlider(isShow: false)
        }
        view.endEditing(true)
    }    
}

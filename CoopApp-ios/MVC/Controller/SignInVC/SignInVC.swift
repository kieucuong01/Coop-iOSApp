//
//  SignInVC.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/20/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class SignInVC: BaseViewController {
    
    @IBOutlet weak var passwordtfView: UIScureTextFieldView!
    @IBOutlet weak var emailTfView: UIAppTextFieldView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardNErrorTapAround()
        emailTfView.textField.keyboardType = .emailAddress
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
//        self.emailTfView.textField.text = "ncc"
//        self.passwordtfView.textField.text = "coop@123"
    }
    // MARK: - Method
    private func callAPILogin(email : String, password: String) {
        APIBase.sharedInstance()?.callAPILogin(isShowHUD: true, username: email, password: password, completionHandler: {(result, error) in
            if error == nil && result != nil {
                GlobalQuick.handleLogin(userModel: UserLoginModel(dict: result!))
                self.presentToViewController(storyboardName: "General", identifier: "DrawerVC", animated: true)
            }
            else {
                Util.showAlert(error?.localizedDescription ?? "Đã có lỗi xảy ra")
            }
        })
        
//        APIManager.shareObject.callAPILogin(isShowHUD: true, user: email, password: password) { (result, error) in
//            if error == nil && result != nil{
//                GlobalQuick.handleLogin(userModel: UserLoginModel(dict: result!))
//                self.presentToViewController(storyboardName: "General", identifier: "DrawerVC", animated: true)
//            }
//            else {
//                self.showTopError(message: "Sai thông tin đăng nhập")
//            }
//        }
    }

    // MARK: - Action
    @IBAction func signInAction(_ sender: Any) {
        if let email = self.emailTfView.textField.text,
            let password = self.passwordtfView.textField.text {
            // Validate form
            let validateFromReponse : Valid = Validation.shared.validate(values: [(ValidationType.password, password)])
            switch validateFromReponse {
            case .success:
                // Call api
                self.callAPILogin(email: email, password: password)
                break
            case .failure(_, let message):
                self.showTintTopError(message: message.localized())
            }
        }
    }
}

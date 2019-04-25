//
//  GlobalQuickConstant.swift
//  FundaNote
//
//  Created by Cuong Kieu on 9/19/17.
//  Copyright © 2017 QUICK Corp. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage
// MARK: - Util Quick Constant
final class GlobalQuick {
    // MARK: - Constants
    static let userLoginKey: String = "user"
    static let wasLoginKey: String = "was_login"
    static let accessTokenKey: String = "accesss_token"
    static let userIdKey: String = "user_id"
    static let userNameKey: String = "user_name"
    static let appScheme: String = "fundanoteapp"

    // MARK: - Fonts
    static let mainFontRegular: UIFont = UIFont.systemFont(ofSize: 15.0 * DISPLAY_SCALE, weight: UIFont.Weight.regular)
    static let mainFontMedium: UIFont = UIFont.systemFont(ofSize: 15.0 * DISPLAY_SCALE, weight: UIFont.Weight.medium)
    static let mainFontBold: UIFont = UIFont.systemFont(ofSize: 15.0 * DISPLAY_SCALE, weight: UIFont.Weight.bold)

    // MARK: - Variables
    static var userLogin: UserLoginModel? = nil

    // MARK: - Login, Logout

    /*
     * Created by: cuongkt
     * Description: Handle login function
     */
    static func handleLogin(userModel: UserLoginModel) {
        // Get my user model
        GlobalQuick.userLogin = userModel
        
        Util.saveObjectForKeyToUserDefault(object: userModel, forKey: GlobalQuick.userLoginKey)
        Util.saveValueForKeyToUserDefault(value: true, forKey: GlobalQuick.wasLoginKey)
        Util.saveValueForKeyToUserDefault(value: userModel.key, forKey: GlobalQuick.accessTokenKey)
        Util.saveValueForKeyToUserDefault(value: userModel.supplier_id, forKey: GlobalQuick.userIdKey)
        Util.saveValueForKeyToUserDefault(value: userModel.full_name, forKey: GlobalQuick.userNameKey)
    }

    /*
     * Created by: cuongkt
     * Description: Logout function
     */
    static func logOut() {
        // Remove my user model
        GlobalQuick.userLogin = nil
        
        // Remove accesstoken, userid
        Util.saveValueForKeyToUserDefault(value: nil, forKey: GlobalQuick.accessTokenKey)
        Util.saveValueForKeyToUserDefault(value: nil, forKey: GlobalQuick.userIdKey)
        Util.saveValueForKeyToUserDefault(value: nil, forKey: GlobalQuick.userNameKey)

        // Pop to LoginVC
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let signInVC : SignInVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "signInVC") as? SignInVC{
                // Reset rootView
                let rootNavigationController: UINavigationController = UINavigationController()
                rootNavigationController.isNavigationBarHidden = true
                rootNavigationController.setViewControllers([signInVC], animated: true)
                appDelegate.window?.rootViewController = rootNavigationController
            }
        }
    }
}

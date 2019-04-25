//
//  Util.swift
//  ParkingManagementApp
//
//  Created by Cuong Kieu on 2/10/17.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage
import SystemConfiguration

// MARK: - Util method

final class Util {
    // MARK: - Check connected to network
    /*
     * Created by: cuongkt
     * Description: Check iPhoneX
     */
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired

         return isReachable && !needsConnection
         */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }

    // MARK: - Check iPhoneX

    /*
     * Created by: cuongkt
     * Description: Check iPhoneX
     */
    static func checkIsIPhoneX() -> Bool {
        var isIPhoneX: Bool = false
        if #available(iOS 11.0, *) {
            if let window: UIWindow = UIApplication.shared.delegate?.window as? UIWindow {
                if window.safeAreaInsets.top > 0.0 {
                    isIPhoneX = true
                }
            }
        }
        return isIPhoneX
    }

    // MARK: - UserDefaults

    /*
     * Created by: cuongkt
     * Description: Save value to user default
     */
    static func saveValueForKeyToUserDefault(value: Any?, forKey key: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    static func saveObjectForKeyToUserDefault(object: Any?, forKey key: String){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: object!)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }

    /*
     * Created by: cuongkt
     * Description: Get value from user default
     */
    static func getValueFromUserDefault(key: String) -> Any? {
        let userDefaults: UserDefaults = UserDefaults.standard
        let value: Any? = userDefaults.value(forKey: key)
        return value
    }
    
    static func getObjectFromUserDefault(key: String) -> Any? {
        let userDefaults: UserDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: key) as! Data
        let decodedObj : Any? = NSKeyedUnarchiver.unarchiveObject(with: decoded)
        
        return decodedObj
    }
    
    // MARK: - Convert Date and String

    /*
     * Created by: cuongkt
     * Description: Get date string from seconds
     */
    static func getStringDate(from secondsString: String?) -> String? {
        if secondsString != nil, let seconds: Double = Double(secondsString!) {
            let date: Date = Date(timeIntervalSince1970: seconds)
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = NSLocalizedString("Global_Date_Format", comment: "")
            let dateString: String = dateFormatter.string(from: date)
            return dateString
        }
        else {
            return nil
        }
    }

    // MARK: - Show Alert

    /*
     * Created by: cuongkt
     * Description: Show alert not completion
     */
    static func showAlert(_ alertMessage: String) {
        // Show alert
        Util.showAlert(alertMessage, completion: nil)
    }

    /*
     * Created by: cuongkt
     * Description: Show alert full
     */
    static func showAlert(_ alertMessage: String, completion: (() -> Void)?) {
        // Init alert
        let alertController: UIAlertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: UIAlertActionStyle.default, handler: { (alert) in
            completion?()
        }))

        // Make title smaller
        alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

        // Show alert
        self.topViewController()?.present(alertController, animated: true, completion: nil)
    }

    /*
     * Created by: cuongkt
     * Description: Show confirm alert with only yes completion
     */
    static func showConfirmAlert(_ alertMessage: String, yesCompletion: (() -> Void)?) {
        // Show alert
        Util.showConfirmAlert(alertMessage, noCompletion: nil, yesCompletion: yesCompletion)
    }

    /*
     * Created by: cuongkt
     * Description: Show confirm alert full
     */
    static func showConfirmAlert(_ alertMessage: String, noCompletion: (() -> Void)?, yesCompletion: (() -> Void)?) {
        // Init alert
        let alertController: UIAlertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("button_cancel_title", comment: ""), style: UIAlertActionStyle.default, handler: { (alert) in
            noCompletion?()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: UIAlertActionStyle.default, handler: { (alert) in
            yesCompletion?()
        }))

        alertController.view.tintColor = PRIMARY_COLOR
        // Make title smaller
        alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")
        
        // Set style for alert message
        let attrString = NSMutableAttributedString(string: alertMessage)
        attrString.setAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 16 * DISPLAY_SCALE) ?? UIFont.systemFont(ofSize: 16)], range: NSMakeRange(0, attrString.length))
        alertController.setValue(attrString, forKey: "attributedMessage")

        // Show alert
        self.topViewController()?.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Show Action Sheet

    /*
     * Created by: cuongkt
     * Description: Show action sheet alert
     */
    static func showActionSheetAlert(listButtons: [(title: String, style: UIAlertActionStyle, handle: (() -> Void)?)]) {
        // Init alert
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("button_cancel_title", comment: ""), style: UIAlertActionStyle.cancel, handler: { (alert) in
        }))

        // List buttons
        for button in listButtons {
            alertController.addAction(UIAlertAction(title: button.title, style: button.style, handler: { (alert) in
                button.handle?()
            }))
        }

        // Show alert
        self.topViewController()?.present(alertController, animated: true, completion: nil)
    }

    // MARK: - MBProgressHUD

    /*
     * Created by: cuongkt
     * Description: Show MBProgressHUD
     */
    static func getShowMBProgressHUD() -> MBProgressHUD? {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.window != nil {
                return MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
            }
        }
        return nil
    }
    
    /*
     * Created by: cuongkt
     * Description: Show MBProgressHUD
     */
    static func showMBProgressHUD() {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.window != nil {
                MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
            }
        }
    }

    /*
     * Created by: cuongkt
     * Description: Hide all MBProgressHUD
     */
    static func hideAllMBProgressHUD() {
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.window != nil {
                MBProgressHUD.hide(for: appDelegate.window!, animated: true)
            }
        }
    }

    // MARK: - Get time stamp

    /*
     * Created by: cuongkt
     * Description: Get time stamp string
     */
    static func getTimeStampString() -> String {
        let date: Date = Date()
        let timeStampString: String = date.timeIntervalSince1970.description
        return timeStampString
    }

    /*
     * Created by: cuongkt
     * Description: Get time stamp string
     */
    static func getTimeStampString(date: Date) -> String {
        let timeStampString: String = date.timeIntervalSince1970.description
        return timeStampString
    }

    // MARK: - Convert String to Double

    /*
     * Created by: cuongkt
     * Description: Convert string to double value (Special for stock value)
     */
    static func convertStringToDoubleValue(string: String?, isNeedChangeUnit: Bool) -> Double {
        var doubleValue: Double = 0.0

        // Check nil
        if (string != nil) && (Double(string!) != nil) {
            doubleValue = Double(string!)!
        }

        // Check value
        if isNeedChangeUnit == true {
            doubleValue = doubleValue / 100000.0
        }

        // Return double value
        return doubleValue
    }

    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

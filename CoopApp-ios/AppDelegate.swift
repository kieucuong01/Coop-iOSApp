//
//  AppDelegate.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/19/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notificationInfo: [AnyHashable : Any]? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {        
        // Check auto login
        self.checkAutoLogin()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK: - Method
    /*
     * Created by: cuongkt
     * Description: Check auto login
     */
    func checkAutoLogin() {
        let accessToken: String? = Util.getValueFromUserDefault(key: GlobalQuick.accessTokenKey) as? String
        if accessToken != nil{
            // Save user login object
            GlobalQuick.userLogin = Util.getObjectFromUserDefault(key: GlobalQuick.userLoginKey) as? UserLoginModel
            
            // Get SigninVC
            let storyboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
            let loginVC: SignInVC? = storyboard.instantiateViewController(withIdentifier: "signInVC") as? SignInVC
            // Get LoadingVC
            let loadingVC: LoadingVC? = storyboard.instantiateViewController(withIdentifier: "loadingVC") as? LoadingVC

            // Set root view controller
            self.setRootViewController(viewControllers: [loginVC!, loadingVC!])
        }
        else {
            // Set root view controller
            self.setRootViewController(viewControllers: nil)
        }
    }

    /*
     * Created by: cuongkt
     * Description: Set root view controller
     */
    func setRootViewController(viewControllers: [UIViewController]?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootVC: BaseVCTutorialScreen = storyboard.instantiateViewController(withIdentifier: "BaseVCTutorialScreen") as? BaseVCTutorialScreen {

            self.window = UIWindow(frame: UIScreen.main.bounds)
            let rootNavigationController: UINavigationController = UINavigationController()
            //            rootNavigationController.automaticallyAdjustsScrollViewInsets = false
            rootNavigationController.isNavigationBarHidden = true

            if viewControllers != nil {
                rootNavigationController.setViewControllers(viewControllers!, animated: true)
            }
            else {
//                if  Util.getValueFromUserDefault(key: GlobalQuick.wasLoginKey) as? Bool == true {
//                    if let signInVC : SignInVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "signInVC") as? SignInVC{
//                        rootNavigationController.setViewControllers([signInVC], animated: true)
//                    }
//                }
//                else {
                    rootNavigationController.setViewControllers([rootVC], animated: true)
//                }
            }
            self.window?.rootViewController = rootNavigationController
            self.window?.makeKeyAndVisible()
        }
    }
}

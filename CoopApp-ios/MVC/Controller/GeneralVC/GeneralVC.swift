//
//  GeneralVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/35/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class GeneralVC: UITabBarController {
    
    var data : Dictionary<String, Any> = Dictionary()
    var backgroundTabbarItemView: UIView = UIView()
    @IBOutlet weak var customeTabbar: CustomTabbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = PRIMARY_COLOR
        self.passData()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func passData() {
        if let vc : DashboardVC = self.viewControllers![0] as? DashboardVC {
            vc.data = self.data
        }
    }
}

class CustomTabbar : UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
            size.height = size.height + 7 * DISPLAY_SCALE
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.initTabbar()
    }
    
    private func initTabbar(){
        // Fix bug position for tabbar on iphone X
//        self.invalidateIntrinsicContentSize()
//        self.backgroundImage = UIImage(named: "pmrbackground")
        
        let generalTabbarItem : UITabBarItem = self.items![0]
        let dashBoardTabbarItem : UITabBarItem = self.items![1]
        let activityTabbarItem : UITabBarItem = self.items![2]
        
        generalTabbarItem.image = UIImage(named: "ic_parking")
        dashBoardTabbarItem.image = UIImage(named: "ic_report")
        activityTabbarItem.image = UIImage(named: "ic_activity")
        
        dashBoardTabbarItem.title = NSLocalizedString("dashboard_lbl_tabbar", comment: "")
        generalTabbarItem.title = NSLocalizedString("new_lbl_tabbar", comment: "")
        activityTabbarItem.title = NSLocalizedString("chat_lbl_tabbar", comment: "")
        
        generalTabbarItem.titlePositionAdjustment = UIOffsetMake(0, -8)
        dashBoardTabbarItem.titlePositionAdjustment = UIOffsetMake(0, -8)
        activityTabbarItem.titlePositionAdjustment = UIOffsetMake(0, -8)
    }
}

extension GeneralVC : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            if let vc = viewController.childViewControllerForStatusBarHidden as? VehiclesMapVC {
                vc.initData()
            }
        }
    }
}

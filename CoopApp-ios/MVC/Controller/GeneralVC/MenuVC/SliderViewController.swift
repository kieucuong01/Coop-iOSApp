//
//  SliderViewController.swift
//  MMDrawController
//
//  Created by Millman YANG on 2017/3/30.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import MMDrawController

let menuSection = ["TÀI KHOẢN","CHÍNH SÁCH","HỆ THỐNG"]

class SliderViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imgAvater:UIImageView!
    let menuData : [[MenuModel]] = [[MenuModel(title: "Thông tin", image: UIImage(named: "ic_user")!)],
                                    [MenuModel(title: "Chính sách", image: UIImage(named: "ic_policy")!),
                                     MenuModel(title: "Hỗ trợ", image: UIImage(named: "ic_support")!),
                                     MenuModel(title: "Liên hệ", image: UIImage(named: "ic_contact")!)],
                                    [MenuModel(title: "Đăng xuất", image: UIImage(named: "ic_logout")!)]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setup()
    }
    
    func setup() {
        self.imgAvater.clipsToBounds = true
        self.imgAvater.layer.cornerRadius = imgAvater.frame.height/2
    }
}

extension SliderViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let d = self.drawer() {
            d.showLeftSlider(isShow: false)
            if indexPath.section == 0 {
                if let generalVC = d.main as? GeneralVC{
                    let storyboardLogin: UIStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
                    let vc : UIViewController = storyboardLogin.instantiateViewController(withIdentifier: "myPageNavVC")
                    generalVC.present(vc, animated: true, completion: nil)
                }
            }
            else if (indexPath.section == 1) {
                if let generalVC = d.main as? GeneralVC{
                    let storyboardLogin: UIStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
                    let vc : MyPageWebViewVC = storyboardLogin.instantiateViewController(withIdentifier: "myPageWebViewVC") as! MyPageWebViewVC
                    if indexPath.row == 0 {
                        vc.data = ["typeWebView" : MyPageWebViewVC.MyPageWebViewType.Policy]
                    }
                    else if indexPath.row == 1 {
                        vc.data = ["typeWebView" : MyPageWebViewVC.MyPageWebViewType.Support]
                    }
                    else {
                        vc.data = ["typeWebView" : MyPageWebViewVC.MyPageWebViewType.Contact]
                    }
                    generalVC.present(vc, animated: true, completion: nil)
                }
            }
            else {
                GlobalQuick.logOut();
            }
        }
    }
}

extension SliderViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        viewHeader.textLabel?.text = menuSection[section]
        viewHeader.textLabel?.textColor = UIColor.lightGray
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") ,
            let label = cell.viewWithTag(100) as? UILabel,
            let imageView = cell.viewWithTag(101) as? UIImageView {
            let menuModel : MenuModel = self.menuData[indexPath.section][indexPath.row] 
            imageView.image = menuModel.image
            label.text = menuModel.title
            return cell
        }
        return UITableViewCell()
    }
}

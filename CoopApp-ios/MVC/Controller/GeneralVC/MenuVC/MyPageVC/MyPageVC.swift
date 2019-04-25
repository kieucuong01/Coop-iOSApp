//
//  MyPageVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/25/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class MyPageVC: BaseViewController {
    enum MyPageSection : Int {
        case Profile = 0, Building = 1, BottomInfo = 2
    }
    var isEditProfile : Bool = false
    var buildings : [BuildingModel] = []
    var profileInfos : [[String:String]] = [[:]]
    var bottomInfos : [String] = [NSLocalizedString("mypage_lbl_term", comment: ""),
                                  NSLocalizedString("mypage_lbl_policy", comment: ""),
                                  NSLocalizedString("mypage_lbl_version", comment: ""),
                                  NSLocalizedString("mypage_lbl_logout", comment: "")]
    var mobileTf : UITextField? = nil
    var fullNameTf : UITextField? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewFAQFooter : UIView = {
        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 110 * DISPLAY_SCALE))
        
        let faqButton = UIColorButton(frame: CGRect(x: 0, y: 0, width: 100 * DISPLAY_SCALE, height: 35 * DISPLAY_SCALE))
        faqButton.center = viewFooter.center
        faqButton.setTitle(NSLocalizedString("Lưu", comment: ""), for: .normal)
        faqButton.addTarget(self, action: #selector(MyPageVC.editProfileBtnAction(_:)), for: .touchUpInside)
        
        viewFooter.addSubview(faqButton)
        
        return viewFooter
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private func
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "ResetingCell", bundle: nil), forCellReuseIdentifier: "ResetingCell")
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "BuildingCell")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.getUserMyPage()
    }
    
    private func getUserMyPage(){
        APIBase.sharedInstance()?.callAPIGetProfile(isShowHUD: true, params: nil, completionHandler: { (result, error) in
            if error == nil {
                // Success
                let userMyPage  = UserMyPageModel(dict: result as! Dictionary<String,Any>)
                
                self.profileInfos = [[NSLocalizedString("Tên người dùng: ", comment: "") : userMyPage.username],
                                     [NSLocalizedString("Họ vả tên: ", comment: "") : userMyPage.full_name],
                                     [NSLocalizedString("Email: ", comment: "") :userMyPage.email],
                                     [NSLocalizedString("SĐT: ", comment: "") : userMyPage.mobile]]
                self.tableView.reloadData()
            }
            else {
                // Call API Fail
                if let user : UserLoginModel = GlobalQuick.userLogin {
                    var unitName : String = ""
                    if user.rule == UserRole.Supplier.rawValue {
                        unitName = user.supplier_name
                    }
                    else if user.rule == UserRole.Warehouse.rawValue {
                        unitName = user.warehouse_name
                    }
                    else if user.rule == UserRole.Supermarket.rawValue {
                        unitName = user.supermarket_name
                    }
                    
                    self.profileInfos = [[NSLocalizedString("Tên đơn vị: ", comment: "") : unitName],
                                         [NSLocalizedString("Họ tên: ", comment: "") : user.full_name],
                                         [NSLocalizedString("Chức vụ: ", comment: "") :user.user_type_name],
                                         [NSLocalizedString("SĐT: ", comment: "") : user.mobile]]
                    
                    // Reload table
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Action
    @objc func editProfileBtnAction(_ sender: UIButton){
        let params = ["mobile" : mobileTf?.text,
                      "full_name" : fullNameTf?.text]
        APIBase.sharedInstance()?.callAPIUpdateProfile(isShowHUD: true, params: params as [String : Any] , completionHandler: { (result, error) in
            if error == nil {
                // Success
                let userMyPage  = UserMyPageModel(dict: result as! Dictionary<String,Any>)
                
                self.profileInfos = [[NSLocalizedString("Tên người dùng: ", comment: "") : userMyPage.username],
                                     [NSLocalizedString("Họ vả tên: ", comment: "") : userMyPage.full_name],
                                     [NSLocalizedString("Email: ", comment: "") :userMyPage.email],
                                     [NSLocalizedString("SĐT: ", comment: "") : userMyPage.mobile]]
                self.isEditProfile = false
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(self.editBtnAction(_:)))
                self.tableView.reloadData()
            }
            else {

            }
        })
    }
    @objc func resetingBtnAction(_ sender: UIButton){
//        self.presentToViewController(storyboardName: "SignIn", identifier: "forgetPasswordVC", animated: true)
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        self.isEditProfile = !self.isEditProfile
        if self.isEditProfile == true {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: .plain, target: self, action:  #selector(self.editBtnAction(_:)))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_edit"), style: .plain, target: self, action:  #selector(self.editBtnAction(_:)))
        }
        self.tableView.reloadData()
    }
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    
    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == MyPageSection.BottomInfo.rawValue {
            return 0
        }
        return 150 * DISPLAY_SCALE
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == MyPageSection.Profile.rawValue {
            return 110 * DISPLAY_SCALE
        }
        else {
            return 0
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    /*
     * Created by: cuongkt
     * Description: Number of section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     * Created by: cuongkt
     * Description: Number of row in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == MyPageSection.Profile.rawValue {
            return  5
        }
        else {
            return 0
        }
    }
    
    /*
     * Created by: cuongkt
     * Description: View for Header
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == MyPageSection.Profile.rawValue {
            // Create Header View
            let viewHeader = UIView (frame: CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 150 * DISPLAY_SCALE))
            
            // Create subviews of header view
            let circleView = UIImageView(frame: CGRect(x: 0, y: 20 * DISPLAY_SCALE, width: 68 * DISPLAY_SCALE, height: 68 * DISPLAY_SCALE))
            circleView.layer.cornerRadius = circleView.frame.size.height/2.0
            circleView.center = CGPoint(x: viewHeader.frame.size.width/2.0,
                                        y: circleView.frame.origin.y + circleView.frame.size.height/2.0)
            circleView.contentMode = .scaleAspectFit
            circleView.image = UIImage(named: "ICON")
            let lblTitle = UILabel (frame: CGRect(x: 0, y: circleView.frame.origin.y + circleView.frame.size.height + 4 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 27 * DISPLAY_SCALE))
            lblTitle.textAlignment = .center
            lblTitle.font = UIFont (name: PRIMARY_FONT_NAME_REGULAR, size: 18 * DISPLAY_SCALE)
            if section == 0 {
                lblTitle.text = NSLocalizedString("mypage_lbl_profile", comment: "")
            }
            else {
                lblTitle.text = NSLocalizedString("mypage_lbl_property", comment: "")
            }
            
            //            viewHeader.backgroundColor = FORM_BACKGROUND_COLOR
            viewHeader.addSubview(circleView)
            viewHeader.addSubview(lblTitle)
            return viewHeader
        }
        else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.isEditProfile {
            return viewFAQFooter
        }
        else {
            return nil
        }
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Profile section
        if indexPath.section == MyPageSection.Profile.rawValue {
            // Reseting Cell
            if indexPath.row == 4 {
                if let cell: ResetingCell = tableView.dequeueReusableCell(withIdentifier: "ResetingCell") as? ResetingCell {
                    cell.resettingBtn.addTarget(self, action: #selector(self.resetingBtnAction(_:)), for: .touchUpInside)
                    // Return cell
                    return cell
                }
            }
            else {
                if let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell {
                    if self.profileInfos.indices.contains(indexPath.row){
                        let modelCell : [String:String] = self.profileInfos[indexPath.row]
                        cell.updateViewCell(model: modelCell)
                        if (indexPath.row == 1 || indexPath.row == 3) && self.isEditProfile == true {
                            if indexPath.row == 1 {
                                self.fullNameTf = cell.contentTf
                            }
                            else {
                                self.mobileTf = cell.contentTf
                            }
                            cell.contentTf.isEnabled = true
                        }
                        else {
                            cell.contentTf.isEnabled = false
                        }
                    }
                    
                    // Return cell
                    return cell
                }
            }
        }
            // Bottom section include term, policy, version, logout
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
            if (cell == nil) {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "defaultCell")
                cell?.selectionStyle = .none
                cell?.backgroundView = UIView(frame: CGRect(x: 0, y: 4, width: (cell?.contentView.frame.width)!, height: (cell?.contentView.frame.height)! - 8))
                cell?.backgroundView?.backgroundColor = .white
                cell?.backgroundView?.applySketchShadow(color: GRAY4_COLOR, alpha: 0.5, x: 0, y: 0, blur: 4, spread: 0)
                cell?.detailTextLabel?.textColor = GRAY1_COLOR
                cell?.textLabel?.textColor = PRIMARY_COLOR
                cell?.textLabel?.font = UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 16 * DISPLAY_SCALE)
                
            }
            if bottomInfos.count >= indexPath.row{
                cell?.textLabel?.text = bottomInfos[indexPath.row]
                if indexPath.row == 2{
                    var versionString : String = ""
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
                        versionString = version
                        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
                            versionString = versionString + "(" + buildVersion + ")"
                        }
                        cell?.detailTextLabel?.text = versionString
                    }
                }
                else {
                    cell?.detailTextLabel?.text = ""
                }
            }
            
            return cell!
        }
        
        // Default
        return UITableViewCell()
    }
}

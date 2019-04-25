//
//  ContainerVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/7/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import UIKit
import XLPagerTabStrip

class ContainerVC: UIViewController {
    
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var list : [ContainerModel] = []
    var itemInfo: IndicatorInfo = "View"
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    
    lazy var findContainerView:FormOneField = {
        let view = (Bundle.main.loadNibNamed("FormOneField", owner: self, options: nil))?[0] as! FormOneField
        view.initView(title: "TÌM THÙNG HÀNG", rightBtnTitle: "OK", leftBtnTitle: "HỦY", formTfPlaceholder: "ID Thùng hàng")
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        view.formTf.keyboardType = .numberPad
        return view
    }()
    
    lazy var addContainerView:FormOneField = {
        let view = (Bundle.main.loadNibNamed("FormOneField", owner: self, options: nil))?[0] as! FormOneField
        view.initView(title: "TẠO QRCODE CHO THÙNG HÀNG", rightBtnTitle: "OK", leftBtnTitle: "HỦY", formTfPlaceholder: "Tên Thùng hàng")
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true        
        return view
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initCollectionView()
        // Do any additional setup after loading the view.
    }
    
    private func initView(){
    }
    
    private func initCollectionView(){
        //Register cells
        self.collectionView.register(UINib.init(nibName: "ContainerCVC", bundle: nil), forCellWithReuseIdentifier: "containerCVC")
        
        // Set attributes
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    private func callAPISearchContainer(containerId: Int) {
        let params = ["container_id": containerId] as [String : Any]
        
        APIBase.sharedInstance()?.callAPISearchContainer(isShowHUD: true, params: params, completionHandler: { (result, error) in
            if error == nil{
                // Success
                let basket : ContainerModel = ContainerModel(dict: result?["container"] as! Dictionary<String, Any>)
                self.list.append(basket)
                self.collectionView.reloadData()
            }
            else {
                // Call API Fail
                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }

    private func callAPIInsertContainer(name: String, description: String = ""){
        let params = ["name" : name,
                      "description": description] as [String : Any]
        
        APIBase.sharedInstance()?.callAPIInsertContainer(isShowHUD: true, params: params, completionHandler: { (result, error) in
            if error == nil {
                let container : ContainerModel = ContainerModel(dict: result?["container"] as! Dictionary<String, Any>)
                // Success
                self.list.append(container)
                    self.collectionView.reloadData()
            }
            else {
                // Call API Fail
                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }
    
    @IBAction func insertContainerBtnAction(_ sender: UIButton) {
        self.tabBarController?.view.addSubview(self.addContainerView)
        self.addContainerView.isHidden = false
        self.addContainerView.delegate = self
    }
    
    @IBAction func searchContainerBtnAction(_ sender: UIButton) {
        self.tabBarController?.view.addSubview(self.findContainerView)
        self.findContainerView.isHidden = false
        self.findContainerView.delegate = self
        
    }
}

extension ContainerVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension ContainerVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0 , bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170 * DISPLAY_SCALE, height: 200 * DISPLAY_SCALE)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell:ContainerCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "containerCVC", for: indexPath) as? ContainerCVC {
            // Update index
            if self.list.indices.contains(indexPath.row){
                let model : ContainerModel = self.list[indexPath.row]
                cell.updateViewCell(model: model)
            }
            // Return cell
            return cell
        }
        //Default
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ContainerVC : FormOneFieldDelegate {
    func clickedButtonCancel(sender: FormOneField) {
        
    }
    
    func clickedButtonOK(sender: FormOneField) {
        if sender == self.findContainerView {
            if let containerId = Int(sender.formTf.text ?? "0") {
                self.callAPISearchContainer(containerId: containerId)
                self.noneView.isHidden = true
            }
        }
        else {
            if let containerName = sender.formTf.text {
                self.callAPIInsertContainer(name: containerName)
                self.noneView.isHidden = true
            }
        }
    }
}

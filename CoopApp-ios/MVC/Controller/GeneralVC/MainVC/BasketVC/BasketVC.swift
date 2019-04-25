//
//  BasketVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/7/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol BasketVCDelegate: class {
    func clickedButtonCancel(sender: BasketVC)
    func clickedButtonOK(sender: BasketVC)
}

class BasketVC: UIViewController {
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var baskets : [BasketModel] = []
    var itemInfo: IndicatorInfo = "View"
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    weak var delegate:BasketVCDelegate? = nil
    
    lazy var findBasketView:FormOneField = {
        let view = (Bundle.main.loadNibNamed("FormOneField", owner: self, options: nil))?[0] as! FormOneField
        view.initView(title: "TÌM SỌT HÀNG", rightBtnTitle: "OK", leftBtnTitle: "HỦY", formTfPlaceholder: "ID Sọt hàng")
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        view.formTf.keyboardType = .numberPad
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
        self.collectionView.register(UINib.init(nibName: "BasketCVC", bundle: nil), forCellWithReuseIdentifier: "basketCVC")
        
        // Set attributes
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func callAPISearchBasket(basketId: Int) {
        let params = ["basket_id": basketId] as [String : Any]

        APIBase.sharedInstance()?.callAPISearchBasket(isShowHUD: true, params: params, completionHandler: { (result, error) in
            if error == nil{
                // Success
                let basket : BasketModel = BasketModel(dict: result?["basket"] as! Dictionary<String, Any>)
                self.baskets.append(basket)
                self.collectionView.reloadData()
            }
            else {
                // Call API Fail
                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }
    
    private func callAPIInsertBasket(){
        APIBase.sharedInstance()?.callAPIInsertBasket(isShowHUD: true, params: nil, completionHandler: { (result, error) in
            if error == nil{
                // Success
                let basket : BasketModel = BasketModel(dict: result?["basket"] as! Dictionary<String, Any>)
                    self.baskets.append(basket)
                    self.collectionView.reloadData()
            }
            else {
                // Call API Fail
                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }
    
    
    @IBAction func insertBasketBtnAction(_ sender: UIButton) {
        self.callAPIInsertBasket()
        self.noneView.isHidden = true
    }
    
    @IBAction func searchBasketBtnAction(_ sender: UIButton) {
        self.tabBarController?.view.addSubview(self.findBasketView)
        self.findBasketView.isHidden = false
        self.findBasketView.delegate = self
    }
}

extension BasketVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension BasketVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.baskets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0 , bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170 * DISPLAY_SCALE, height: 190 * DISPLAY_SCALE)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell:BasketCVC = collectionView.dequeueReusableCell(withReuseIdentifier: "basketCVC", for: indexPath) as? BasketCVC {
            // Update index
            if self.baskets.indices.contains(indexPath.row){
                let model : BasketModel = self.baskets[indexPath.row]
                cell.updateViewCell(model: model)
            }
            // Return cell
            return cell
        }
        //Default
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.clickedButtonOK(sender: self)
//        let transaction = self.baskets[indexPath.row]
//        self.selectedTransactions.append(transaction)
//        if self.selectedTransactions.count != 0 {
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.clickedButtonCancel(sender: self)
//        let transaction = self.transactions[indexPath.row]
//        if let index = self.selectedTransactions.index(where: { $0.id == transaction.id }) {
//            self.selectedTransactions.remove(at: index)
//        }
//        if self.selectedTransactions.count == 0 {
//        }
    }
    
}

extension BasketVC : FormOneFieldDelegate {
    func clickedButtonCancel(sender: FormOneField) {
        
    }
    
    func clickedButtonOK(sender: FormOneField) {
        if let basketId = Int(sender.formTf.text ?? "0") {
            self.callAPISearchBasket(basketId: basketId)
            self.noneView.isHidden = true
        }
    }
}

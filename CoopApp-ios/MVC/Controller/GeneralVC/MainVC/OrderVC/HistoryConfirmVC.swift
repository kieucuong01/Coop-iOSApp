//
//  HistoryConfirmVC.swift
//  CoopApp-ios
//
//  Created by MAC on 3/25/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit
import FLAnimatedImage
import AXPhotoViewer

class HistoryConfirmVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var confirmHistoryList : [ConfirmHistoryModel] = []
    var transaction : TransactionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
        // Do any additional setup after loading the view.
    }
    
    private func initView() {
        self.title = "LỊCH SỬ KIỂM ĐỊNH"
        if let transaction = self.data[TransactionModel.keyModel] as? TransactionModel {
            self.transaction = transaction
            self.callAPIConfirmList(transactionId: transaction.id)
        }
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: ConfirmHistoryTVC.cellIdentifier, bundle: nil), forCellReuseIdentifier: ConfirmHistoryTVC.cellIdentifier)
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.callAPIConfirmList(transactionId: self.transaction?.id ?? 0)
        }
    }
    
    private func callAPIConfirmList(transactionId : Int) {
        // Reset list of new
        self.confirmHistoryList.removeAll()
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue  {
            let params : [String : Any] = ["transaction_id" : transactionId]
            APIBase.sharedInstance()?.callAPITransactionConfirmList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransactionList(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue || GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue{
            let params : [String : Any] = ["warehouse_product_transaction_id" : transactionId]
            APIBase.sharedInstance()?.callAPIWarehouseTransactionConfirmList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransactionList(result: result, error: error)
            })
        }
    }
    
    private func completionAPITransactionList(result : NSDictionary?, error : NSError?){
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil && result != nil{
            // Success
            let dics : Array<Dictionary<String,Any>> = result?["confirm_list"] as! Array<Dictionary<String, Any>>
            for dic in dics {
                let confirmModel = ConfirmHistoryModel(dict: dic)
                confirmModel.packing = self.transaction?.product_packing
                self.confirmHistoryList.append(confirmModel)
            }
            self.tableView.reloadData()
        }
        else {
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }

}


extension HistoryConfirmVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    
    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        return self.confirmHistoryList.count
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ConfirmHistoryTVC = tableView.dequeueReusableCell(withIdentifier: ConfirmHistoryTVC.cellIdentifier) as? ConfirmHistoryTVC {
            // Update index
            if self.confirmHistoryList.indices.contains(indexPath.row){
                let model : ConfirmHistoryModel = self.confirmHistoryList[indexPath.row]
                cell.delegate = self
                cell.updateCell(model: model)
            }
            // Return cell
            return cell
        }
        
        // Default
        return UITableViewCell()
    }
}

extension HistoryConfirmVC : ConfirmHistoryTVCDelegate {
    func imageBtnAction(sender: ConfirmHistoryTVC) {
        if sender.model?.image_list.count ?? 0 > 0 {
            var witnessPhotos : [AXPhoto] = []
            for i in 0...sender.model!.image_list.count-1{
                let witnessModel : WitnessModel = sender.model!.image_list[i]
                let photo = AXPhoto(attributedTitle: NSAttributedString(string: ""),
                                    attributedDescription: nil,
                                    attributedCredit: NSAttributedString(string: witnessModel.create_at),
                                    url: URL(string: witnessModel.image))
                witnessPhotos.append(photo)
            }        
            let dataSource = AXPhotosDataSource(photos: witnessPhotos)
            let pagingConfig = AXPagingConfig(interPhotoSpacing: 1.0)
            let photosViewController = AXPhotosViewController(dataSource: dataSource, pagingConfig: pagingConfig)

            self.present(photosViewController, animated: true)
        }
    }
}

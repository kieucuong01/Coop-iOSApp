//
//  WarehouseTransportVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/14/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class WarehouseTransportVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    var list: [TransactionModel] = []
    var transport : TransportModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initView(){
        self.title = NSLocalizedString("SỌT HÀNG" , comment: "")
        self.transport = self.data["transport"] as? TransportModel
        self.callAPIList(isReload: true)
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "TransactionTVC", bundle: nil), forCellReuseIdentifier: "transactionTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIList(isReload: true)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIList(isReload: true)
            }
        }
    }
    
    private func callAPIList(isReload: Bool) {
        // Reset list of new
        if (isReload == true) { self.list.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        let params = ["transport_id" : self.transport?.id ?? 0,
                      "page": self.page] as [String : Any]
        
        APIBase.sharedInstance()?.callAPIWarehouseTransportTransaction(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
            
            if error == nil && result != nil{
                // Success
                if result?["success"] as! Bool == true {
                    let dics : Array<Dictionary<String,Any>> = result?["transaction_list"] as! Array<Dictionary<String, Any>>
                    self.totalPage = result?["total_page"] as! Int
                    self.totalRecord = result?["total_record"] as! Int
                    for dic in dics {
                        self.list.append(TransactionModel(dict: dic))
                        
                    }
                    self.tableView.reloadData()
                }
                else {
                    // Fail
                    Util.showAlert(result?["detail"] as! String)
                }
            }
            else {
                // Call API Fail
                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }
    
}

extension WarehouseTransportVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    
    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 * DISPLAY_SCALE
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
        return self.list.count
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader : UITableViewHeaderFooterView = UITableViewHeaderFooterView()
        viewHeader.textLabel?.text = String(format: "%d %@", self.totalRecord, NSLocalizedString("Sản phẩm", comment: ""))
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: TransactionTVC = tableView.dequeueReusableCell(withIdentifier: "transactionTVC") as? TransactionTVC {
            // Update index
            if self.list.indices.contains(indexPath.row){
                let model : TransactionModel = self.list[indexPath.row]
                cell.updateViewCell(model: model)
            }
            // Return cell
            return cell
        }
        
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Chi tiết", style: UIAlertActionStyle.default)
        { action -> Void in
            // Put your code here
        })
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

//
//  SupermarketVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/26/19.
//  Copyright © 2019 Oceanize. All rights reserved.
//

import UIKit

class SupermarketVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryLbl: UIButton!
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    var list: [OrderBranchModel] = []
    var searchKey: String?
    var selectedBranchType: BranchTypeModel?
    var branchTypes: [BranchTypeModel] = []
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    fileprivate var searchView : UISearchBar {
        let searchView : UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        searchView.placeholder = "Tìm siêu thị"
        searchView.sizeToFit()
        searchView.barTintColor = navigationController?.navigationBar.barTintColor
        searchView.tintColor = self.view.tintColor
        searchView.delegate = self
        searchView.becomeFirstResponder()
        
        return searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initView(){
        self.title = NSLocalizedString("CHỌN SIÊU THỊ" , comment: "")
        self.categoryLbl.setTitle("Danh mục", for: .normal)
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchBtnAction))
        self.navigationItem.rightBarButtonItem = searchBtn

        self.callAPIGetBranchType()
        self.callAPIList(isReload: false, searchKey: nil, branchTypeId: nil)
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "SupermarketTVC", bundle: nil), forCellReuseIdentifier: "supermarketTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIList(isReload: true, searchKey: self.searchKey, branchTypeId: self.selectedBranchType?.id)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIList(isReload: false, searchKey: self.searchKey, branchTypeId: self.selectedBranchType?.id)
            }
        }
    }
    
    private func callAPIList(isReload: Bool, searchKey: String?, branchTypeId: Int?) {
        // Reset list of new
        if (isReload == true) { self.list.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        var params = ["page": self.page] as [String : Any]
        
        if let orderDate = self.data["date"] as? Date {
            params["order_date"] = self.dateFormatter.string(from: orderDate)
        }
        if searchKey != nil {
            params["branch_name"] = searchKey
        }
        if branchTypeId != nil {
            params["branch_type_id"] = branchTypeId
        }
        
        if let product = self.data[ProductModel.keyModel] as? ProductModel {
            params["product_id"] = product.id
        }
        
        APIBase.sharedInstance()?.callAPIGetBranch(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
            
            if error == nil && result != nil{
                // Success
                if result?["success"] as! Bool == true {
                    let dics : Array<Dictionary<String,Any>> = result?["sale_order_list"] as! Array<Dictionary<String, Any>>
                    self.totalPage = result?["total_page"] as! Int
                    self.totalRecord = result?["total_record"] as! Int
                    for dic in dics {
                        self.list.append(OrderBranchModel(dict: dic as! Dictionary<String, Any>))
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
    
    private func callAPIGetBranchType(){
        APIBase.sharedInstance()?.callAPIGetBranchType(isShowHUD: false, params: nil, completionHandler: { (result, error) in
            if error == nil {
                // Success
                let branchTypeDics : Array<Dictionary<String,Any>> = result?["list"] as! Array<Dictionary<String, Any>>
                for branchTypeDic in branchTypeDics {
                    self.branchTypes.append( BranchTypeModel(dict: branchTypeDic))
                }
            }
            else {
                // Call API Fail
//               Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }
    
    
    // MARK: - ACTION
    @objc func searchBtnAction() {
        //Adiciona a barra do Controlador de Busca a barra do navegador
        navigationItem.titleView = self.searchView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButnAction))
    }
    
    @objc func cancelButnAction() {
        self.view.endEditing(true)
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchBtnAction))
    }

    @IBAction func categoryAction(_ sender: UIButton) {
        let alert = UIAlertController()
        
        for branchType in self.branchTypes {
            alert.addAction(UIAlertAction(title: branchType.name, style: UIAlertActionStyle.default)
            { action -> Void in
                self.selectedBranchType = branchType
                self.categoryLbl.setTitle(branchType.name, for: .normal)
                self.callAPIList(isReload: true, searchKey: self.searchKey, branchTypeId: branchType.id)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

}

extension SupermarketVC: UITableViewDelegate, UITableViewDataSource {
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
        viewHeader.textLabel?.text = String(format: "%@ %d", NSLocalizedString("Số lượng: ", comment: ""), self.totalRecord)

        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SupermarketTVC = tableView.dequeueReusableCell(withIdentifier: "supermarketTVC") as? SupermarketTVC {
            // Update index
            if self.list.indices.contains(indexPath.row){
                let model : OrderBranchModel = self.list[indexPath.row]
                cell.updateViewCell(model: model)
            }
            // Return cell
            return cell
        }
        
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branch : BranchModel = self.list[indexPath.row].branch!
        self.pushToViewController(storyboardName: "Order", identifier: "ordersVC", animated: true, withParameter: ["branch" : branch, "date" : self.data["date"]!])
    }    
}

extension SupermarketVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKey = searchBar.text!
        self.callAPIList(isReload: true, searchKey: self.searchKey, branchTypeId: self.selectedBranchType?.id)
        self.cancelButnAction()
    }
}

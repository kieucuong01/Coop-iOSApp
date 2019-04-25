//
//  ProductVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/26/19.
//  Copyright © 2019 Oceanize. All rights reserved.
//

import UIKit

class ProductVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderTypeLbl: UIButton!
    @IBOutlet weak var categoryLbl: UIButton!
    
    var page: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    var list: [ProductModel] = []
    var searchKey: String?
    var orderType: Int?
    var selectedCate: CategoryModel?
    var categories: [CategoryModel] = []
    
    fileprivate var searchView : UISearchBar {
        let searchView : UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        searchView.placeholder = "Tìm sản phẩm"
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
        self.title = NSLocalizedString("SẢN PHẨM" , comment: "")
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchBtnAction))
        self.navigationItem.rightBarButtonItem = searchBtn

        self.callAPIGetCate()
        self.callAPIList(isReload: false, searchKey: nil, orderType: nil, cateId: nil)
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "ProductTVC", bundle: nil), forCellReuseIdentifier: "productTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIList(isReload: true, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCate?.id)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIList(isReload: false, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCate?.id)
            }
        }
    }
    
    private func callAPIList(isReload: Bool, searchKey: String?, orderType: Int?, cateId: Int?) {
        // Reset list of new
        if (isReload == true) { self.list.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        var params = ["supplier_id" : Util.getValueFromUserDefault(key: GlobalQuick.userIdKey) as? Int ?? 0,
                      "page": self.page] as [String : Any]
        if searchKey != nil {
            params["product_name"] = searchKey
        }
        if orderType != nil {
            params["order_type"] = orderType
        }
        if cateId != nil {
            params["bussiness_category"] = cateId
        }
        
        APIBase.sharedInstance()?.callAPIProductList(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
            
            if error == nil && result != nil{
                // Success
                if result?["success"] as! Bool == true {
                    let dics : Array<Dictionary<String,Any>> = result?["product_list"] as! Array<Dictionary<String, Any>>
                    self.totalPage = result?["total_page"] as! Int
                    self.totalRecord = result?["total_record"] as! Int
                    for dic in dics {
                        self.list.append( ProductModel(dict: dic["product"] as! Dictionary<String, Any>))
                        
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
    
    private func callAPIGetCate(){
        APIBase.sharedInstance()?.callAPIGetCategories(isShowHUD: false, params: nil, completionHandler: { (result, error) in
            if error == nil {
                // Success
                let cateDics : Array<Dictionary<String,Any>> = result?["list"] as! Array<Dictionary<String, Any>>
                for cateDic in cateDics {
                    self.categories.append( CategoryModel(dict: cateDic))
                }
            }
            else {
                // Call API Fail
                //                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
            }
        })
    }
    
    
    // - MARK: ACTION
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
    
    @IBAction func orderTypeBtnAction() {
        if self.orderType == 1 {
            self.orderType = 2
            self.orderTypeLbl.setTitle("Đa phương", for: .normal)
        }
        else {
            self.orderType = 1
            self.orderTypeLbl.setTitle("Tập trung", for: .normal)
        }
        self.callAPIList(isReload: true, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCate?.id)
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        let alert = UIAlertController()
        
        for cate in self.categories {
            alert.addAction(UIAlertAction(title: cate.name, style: UIAlertActionStyle.default)
            { action -> Void in
                self.selectedCate = cate
                self.categoryLbl.setTitle(cate.name, for: .normal)
                self.callAPIList(isReload: true, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCate?.id)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

}

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
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
        viewHeader.contentView.backgroundColor = .white
        viewHeader.textLabel?.text = String(format: "%@ %d", NSLocalizedString("Số lượng: ", comment: ""), self.totalRecord)
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProductTVC = tableView.dequeueReusableCell(withIdentifier: "productTVC") as? ProductTVC {
            // Update index
            if self.list.indices.contains(indexPath.row){
                let model : ProductModel = self.list[indexPath.row]
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

extension ProductVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKey = searchBar.text!
        self.callAPIList(isReload: true, searchKey: searchBar.text!, orderType: self.orderType, cateId: self.selectedCate?.id)
        self.cancelButnAction()
    }

}

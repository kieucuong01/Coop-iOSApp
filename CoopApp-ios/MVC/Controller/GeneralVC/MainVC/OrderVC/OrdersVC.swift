//
//  OrdersVC.swift
//  CoopApp-ios
//
//  Created by KTC on 2/26/19.
//  Copyright © 2019 Oceanize. All rights reserved.
//

import UIKit

class OrdersVC: BaseViewController  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLbl: UIButton!
    @IBOutlet weak var orderTypeLbl: UIButton!
    
    var page: Int = 1
    var orderType: Int = 1
    var totalPage: Int = 1
    var totalRecord: Int = 0
    var orders: [OrderModel] = []
    var categories: [CategoryModel] = []
    var selectedCategory: CategoryModel?
    var searchKey: String?

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate var searchView : UISearchBar {
        let searchView : UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        searchView.placeholder = "Tìm đơn hàng"
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
    
    private func initView() {
        self.title = self.dateFormatter.string(from: self.data["date"] as! Date)
        self.categoryLbl.setTitle("Danh mục", for: .normal)
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchBtnAction))
        self.navigationItem.rightBarButtonItem = searchBtn
        
        self.callAPIGetCate()
        self.callAPIGetOrders(isReload: false, searchKey: self.searchKey, cateId: self.selectedCategory?.id)
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "OrderTVC", bundle: nil), forCellReuseIdentifier: "orderTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIGetOrders(isReload: true, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCategory?.id)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIGetOrders(isReload: false, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCategory?.id)
            }
        }
    }
    
    private func callAPIGetCate(){
        APIBase.sharedInstance()?.callAPIGetCategories(isShowHUD: true, params: nil, completionHandler: { (result, error) in
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
    
    private func callAPIGetOrders(isReload: Bool, searchKey: String?, orderType: Int = 1, cateId: Int?) {
        // Reset list of new
        if (isReload == true) { self.orders.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API SUPPLIER OR WAREHOUSE OR SUPPERMARKET
        var params = ["order_date" :  self.dateFormatter.string(from: self.data["date"] as! Date),
                      "page": self.page,
                      "order_type": orderType] as [String : Any]
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue {
            params["supplier_id"] = GlobalQuick.userLogin?.supplier_id
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            if let branch : BranchModel = self.data["branch"] as? BranchModel {
                params["branch_id"] = branch.id
            }
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue {
            params["branch_id"] = GlobalQuick.userLogin?.supermarket_id
        }
        
        if searchKey != nil {
            params["product_name"] = searchKey
        }
        if cateId != nil {
            params["bussiness_category"] = cateId
        }
        APIBase.sharedInstance()?.callAPIGetOrders(isShowHUD: true, params: params, completionHandler: { (result, error) in
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
            
            if error == nil {
                // Success
                let ordersDic : Array<Dictionary<String,Any>> = result?["sale_order_detail_list"] as! Array<Dictionary<String, Any>>
                self.totalPage = result?["total_page"] as! Int
                self.totalRecord = result?["total_record"] as! Int
                
                for orderDic in ordersDic {
                    self.orders.append( OrderModel(dict: orderDic))
                }
                self.tableView.reloadData()
            }
            else {
                // Call API Fail
                Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
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
    
    @IBAction func rightBarAction() {
        if self.orderType == 1 {
            self.orderType = 2
            self.orderTypeLbl.setTitle("Đa phương", for: .normal)
        }
        else {
            self.orderType = 1
            self.orderTypeLbl.setTitle("Tập trung", for: .normal)
        }
        self.callAPIGetOrders(isReload: true, searchKey: self.searchKey, orderType: self.orderType, cateId: self.selectedCategory?.id)
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        let alert = UIAlertController()

        for cate in self.categories {
            alert.addAction(UIAlertAction(title: cate.name, style: UIAlertActionStyle.default)
            { action -> Void in
                self.selectedCategory = cate
                self.categoryLbl.setTitle(cate.name, for: .normal)
                self.callAPIGetOrders(isReload: true, searchKey: self.searchKey, orderType: self.orderType, cateId: cate.id)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel)
        { action -> Void in
            
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
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
        return self.orders.count
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
        if let cell: OrderTVC = tableView.dequeueReusableCell(withIdentifier: "orderTVC") as? OrderTVC {
            // Update index
            if orders.indices.contains(indexPath.row){
                let orderModelCell : OrderModel = self.orders[indexPath.row]
                cell.updateViewCell(model: orderModelCell)
            }
            // Return cell
            return cell
        }
        
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.getViewController(storyboardName: "Order", identifier: "orderDetailVC") as? OrderDetailVC {
            vc.data = ["order" : self.orders[indexPath.row], "branch" : self.data["branch"] as Any]
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension OrdersVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKey = searchBar.text!
        self.callAPIGetOrders(isReload: true, searchKey: searchBar.text!, cateId: self.selectedCategory?.id)
        self.cancelButnAction()
    }
}

extension OrdersVC : OrderDetailVCDelegate {
    func insertStock(updatedOrder: OrderModel) {
        self.orders.filter {$0.id == updatedOrder.id}.first?.updateValue(order: updatedOrder)
        self.tableView.reloadData()
    }
}

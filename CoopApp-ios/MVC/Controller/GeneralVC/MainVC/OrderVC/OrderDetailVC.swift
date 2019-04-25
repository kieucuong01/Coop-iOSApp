//
//  OrderDetailVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import AVFoundation
import UIKit
import QRCodeReader

protocol OrderDetailVCDelegate : class {
    func insertStock(updatedOrder : OrderModel)
}

class OrderDetailVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarBtn: UIBarButtonItem!
    @IBOutlet weak var previewView: QRCodeReaderView! {
        didSet {
            previewView.setupComponents(showCancelButton: true, showSwitchCameraButton: true, showTorchButton: true, showOverlayView: true, reader: reader)
        }
    }
    var selectedTransactions: [TransactionModel] = []
    var transactions: [TransactionModel] = []
    var order : OrderModel? = nil
    var page: Int = 1
    var totalPage: Int = 1
    weak var delegate : OrderDetailVCDelegate? = nil
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView        = true            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    private var formQuantityView:FormOneField = {
        let view = (Bundle.main.loadNibNamed("FormOneField", owner: self, options: nil))?[0] as! FormOneField
        view.titleLbl.text = "NHẬP SỐ LƯỢNG"
        view.okBtn.setTitle("OK", for: .normal)
        view.cancelBtn.setTitle("HỦY", for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.order = self.data["order"] as? OrderModel
        
        self.initView()
        self.initTableView()
    }
    
    private func initView() {
        self.title = "CHIA HÀNG"
        self.callAPIGetTransactions(isReload: false)
        
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue || GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue{
            let qrcodeButton = UIBarButtonItem(image: UIImage(named: "ic_qrcode"), style: .plain, target: self, action: #selector(self.qrCodeBtnAction(_:)))
            self.navigationItem.rightBarButtonItem = qrcodeButton
        }
        self.tabBarController?.view.addSubview(self.formQuantityView)
        self.formQuantityView.formTf.text = String(self.order?.product_packing_value ?? 0)
        self.formQuantityView.formTf.isEnabled = false
        self.formQuantityView.isHidden = true
        self.formQuantityView.delegate = self
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "OrderTVC", bundle: nil), forCellReuseIdentifier: "orderTVC")
        self.tableView.register(UINib(nibName: "BasketTVC", bundle: nil), forCellReuseIdentifier: "basketTVC")
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            self.page = 1
            self.callAPIGetTransactions(isReload: true)
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            self.page += 1
            if self.page > self.totalPage{
                self.tableView.pullToRefreshView?.stopAnimating()
                self.tableView.infiniteScrollingView?.stopAnimating()
            }
            else {
                self.callAPIGetTransactions(isReload: false)
            }
        }
    }
    
    private func callAPIGetTransactions(isReload: Bool) {
        // Reset list of new
        if (isReload == true) { self.transactions.removeAll() }
        // automatic stop animate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        
        // Call API
        let params : [String : Any] = ["sale_order_id" : self.order?.sale_order_id ?? 0,
                                       "page": self.page]
        
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue || (GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.order?.order_type_id == 2){
            APIBase.sharedInstance()?.callAPITransactionList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransactionList(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue || (GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.order?.order_type_id == 1) {
//            let params : [String : Any] = ["to_branch" : self.order?.branch?.id ?? 0,
//                                           "page": self.page]
            APIBase.sharedInstance()?.callAPIWarehouseTransactionList(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransactionList(result: result, error: error)
            })
        }
    }
    
    private func completionAPITransactionList(result : NSDictionary?, error : NSError?){
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil && result != nil{
            // Success
            let transactionsDic : Array<Dictionary<String,Any>> = result?["transaction_list"] as! Array<Dictionary<String, Any>>
            self.totalPage = result?["total_page"] as! Int
            for transactionDic in transactionsDic {
                self.transactions.append( TransactionModel(dict: transactionDic))
            }
            self.tableView.reloadData()
        }
        else {
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    // MARK: - Actions
    @objc func qrCodeBtnAction(_ sender: UIBarButtonItem){
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem){
        self.pushToViewController(storyboardName: "Order", identifier: "transportMapVC", animated: true, withParameter: ["transactions" : self.selectedTransactions])
    }
}

// MARK: - QRCodeReader Delegate Methods
extension OrderDetailVC : QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        let typeId = String(result.value.prefix(2))
        let id = String(result.value.suffix(10))
        let dic : Dictionary<String,Any> = ["id" : Int(id) ?? 0, "type": Stock(rawValue: typeId) ?? Stock.Basket]
        
        reader.dismiss(animated: true, completion: {
            //            self.formQuantityView.isHidden = false
            //            self.formQuantityView.data = dic
            self.callAPIInsertTransaction(type : Stock(rawValue: typeId) ?? Stock.Basket, stockId: Int(id) ?? 0, quantity: self.order?.product_packing_value ?? 0, saleOrderId: self.order?.sale_order_id ?? 0)
        })
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

// TableView delegate
extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100 * DISPLAY_SCALE
    }
    /*
     * Created by: cuongkt
     * Description: Height for header
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
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
        return self.transactions.count
    }
    
    /*
     * Created by: cuongkt
     * Description: View for Header
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell: OrderTVC = tableView.dequeueReusableCell(withIdentifier: "orderTVC") as? OrderTVC {
            cell.updateViewCell(model: self.order!)
            // Return cell
            return cell
        }
        return UITableViewHeaderFooterView()
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: BasketTVC = tableView.dequeueReusableCell(withIdentifier: "basketTVC") as? BasketTVC {
            // Update index
            if self.transactions.indices.contains(indexPath.row){
                let model : TransactionModel = self.transactions[indexPath.row]
                cell.delegate = self
                cell.updateViewCell(model: model)
            }            
            // Return cell
            return cell
        }
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = self.transactions[indexPath.row]
        self.selectedTransactions.append(transaction)
        if self.selectedTransactions.count != 0 && GlobalQuick.userLogin?.rule != UserRole.Supermarket.rawValue{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_check"), style: .plain, target: self, action: #selector(self.doneAction(_:)))
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let transaction = self.transactions[indexPath.row]
        if let index = self.selectedTransactions.index(where: { $0.id == transaction.id }) {
            self.selectedTransactions.remove(at: index)
        }
        if self.selectedTransactions.count == 0 && GlobalQuick.userLogin?.rule != UserRole.Supermarket.rawValue{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_qrcode"), style: .plain, target: self, action: #selector(self.qrCodeBtnAction(_:)))
        }
    }
}

extension OrderDetailVC : FormOneFieldDelegate {
    func clickedButtonCancel(sender: FormOneField) {
        
    }
    
    func clickedButtonOK(sender: FormOneField) {
        if let quantity  = Int(sender.formTf.text!),
            let stockID = sender.data?["id"] as? Int,
            let type = sender.data?["type"] as? Stock{
            self.callAPIInsertTransaction(type : type, stockId: stockID, quantity: quantity, saleOrderId: self.order?.sale_order_id ?? 0)
        }
    }
    
    func callAPIInsertTransaction(type : Stock, stockId: Int, quantity: Int, saleOrderId: Int) {
        // Call API
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue{
            var params : [String : Any] = ["sale_order_id" : saleOrderId,
                                           "quantity" : quantity]
            if type == Stock.Basket {
                params["basket_id"] = stockId
            }
            else {
                params["container_id"] = stockId
            }
            
            APIBase.sharedInstance()?.callAPITransactionInsert(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIInsertTransaction(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            let branch : BranchModel = self.data["branch"] as! BranchModel
            var params : [String : Any] = [:]
            if type == Stock.Basket {
                params["basket_id"] = stockId
            }
            else {
                params["container_id"] = stockId
            }
            
            APIBase.sharedInstance()?.callAPITransactionBasket(isShowHUD: true, params: params, completionHandler: { (result, error) in
                if error == nil {
                    // Success
                    let dics : Array<Dictionary<String,Any>> = result?["list_transaction"] as! Array<Dictionary<String, Any>>
                    if dics.count >= 1 {
                        // Basket over 1 product
                        for dic in dics {
                            let quantity = dic["quantity"] as! Int
                            if quantity > 0 {
                                let supplierTransactionId = dic["id"] as! Int
                                var params : [String : Any] = ["supplier_transaction_id" : supplierTransactionId,
                                                               "to_branch_id": branch.id,
                                                               "quantity" : quantity]
                                if type == Stock.Basket {
                                    params["basket_id"] = stockId
                                }
                                else {
                                    params["container_id"] = stockId
                                }
                                
                                APIBase.sharedInstance()?.callAPIWarehouseTransactionInsert(isShowHUD: true, params: params, completionHandler: { (result, error) in
                                    self.completionAPIInsertTransaction(result: result, error: error)
                                })
                            }
                            else {
                                Util.showAlert("Sọt hàng không có hàng hóa.")
                            }
                        }
                    }
                    else {
                        Util.showAlert("Sọt hàng không có hàng hóa.")
                    }
                    
                    
                }
            })
        }
    }
    
    private func completionAPIInsertTransaction(result : NSDictionary?, error : NSError?){
        self.tableView.pullToRefreshView?.stopAnimating()
        self.tableView.infiniteScrollingView?.stopAnimating()
        
        if error == nil && result != nil{
            let updatedOrder = OrderModel(dict: result!["info"] as! Dictionary<String,Any>)
            self.order = updatedOrder
            self.delegate?.insertStock(updatedOrder: updatedOrder)
            // Success
            self.callAPIGetTransactions(isReload: true)
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
}

extension OrderDetailVC : BasketTVCDelegate {
    func historyConfirmAction(sender: BasketTVC) {
        self.pushToViewController(storyboardName: "Order", identifier: "historyConfirmVC", animated: true, withParameter: [TransactionModel.keyModel : sender.model!])
    }
}

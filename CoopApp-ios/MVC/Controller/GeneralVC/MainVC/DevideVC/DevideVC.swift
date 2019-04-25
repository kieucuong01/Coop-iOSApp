//
//  DevideVC.swift
//  CoopApp-ios
//
//  Created by MAC on 3/15/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import AVFoundation
import UIKit
import QRCodeReader
import AVKit
import AVFoundation
class DevideVC: BaseViewController {
    @IBOutlet weak var noBasketImv: UIImageView!
    @IBOutlet weak var noBasketView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var transactions: [TransactionModel] = []
    var stockId : Int?
    var type: Stock?
    var isFindQRCode : Bool = false
    
    var orderType : OrderType = OrderType.Centralize
    var reader: QRCodeReader = QRCodeReader()
    var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView        = true
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if stockId != nil && type != nil {
            self.callAPIGetTransaction(id: stockId!, type: type!)
        }
    }
    
    private func updateInfo(transaction: TransactionModel) {
        
    }
    
    private func initView() {
        self.title = "CHIA HÀNG"
        self.noBasketImv.applySketchShadow()
        self.readerVC.modalPresentationStyle = .formSheet
        self.readerVC.delegate               = self
    }
    
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: StockInfoTVC.cellIdentifier, bundle: nil), forCellReuseIdentifier: StockInfoTVC.cellIdentifier)
        
        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    
    // MARK: - API
    private func callAPIGetTransaction(id : Int, type: Stock) {
        // Remove old data
        self.stockId = id
        self.type = type
        self.transactions.removeAll()
        
        // Call API
        var params : [String : Any]  = [:]
        if type == Stock.Basket{
            params["basket_id"] = id
        }
        else if type == Stock.Container {
            params["container_id"] = id
        }
        
        if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            APIBase.sharedInstance()?.callAPITransactionBasket(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIGetTransactions(result: result, error: error)
            })
        }
    }
    
    private func completionAPIGetTransactions(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            let dics : Array<Dictionary<String,Any>> = result?["list_transaction"] as! Array<Dictionary<String, Any>>
            for dic in dics {
                self.transactions.append( TransactionModel(dict: dic))
            }
            self.tableView.reloadData()
            self.noBasketView.isHidden = true
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
    @IBAction func qrCodeBtnAction(_ sender: UIButton){
        guard checkScanPermissions() else { return }
        
//        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
//            if let result = result {
//                print("Completion with result: \(result.value) of type \(result.metadataType)")
//            }
//        }
            self.present(self.readerVC, animated: true, completion: nil)
    }
}

// MARK: - QRCodeReader Delegate Methods
extension DevideVC : QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        if isFindQRCode == false {
            self.isFindQRCode = true
            if let typeId = Stock(rawValue: String(result.value.prefix(2))),
                let id = Int(String(result.value.suffix(10))) {
                Util.showConfirmAlert(result.value, noCompletion: {
                    self.isFindQRCode = false
                    reader.startScanning()
                }, yesCompletion: {
                    reader.dismiss(animated: true, completion: {
                        self.isFindQRCode = false
                        self.callAPIGetTransaction(id: id, type: typeId)
                    })
                })
            }
            else {
                Util.showAlert("Sai định dạng QRCode", completion: {
                    reader.startScanning()
                })
            }
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}


extension DevideVC: UITableViewDelegate, UITableViewDataSource {
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
        return self.transactions.count
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: StockInfoTVC = tableView.dequeueReusableCell(withIdentifier:StockInfoTVC.cellIdentifier) as? StockInfoTVC {
            // Update index
            if self.transactions.indices.contains(indexPath.row){
                let model : TransactionModel = self.transactions[indexPath.row]
                cell.updateViewCell(model: model)
            }
            // Return cell
            return cell
        }
        // Default
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let transaction = self.transactions[indexPath.row]
        self.pushToViewController(storyboardName: "Devide", identifier: "devideSupermarketVC", animated: true, withParameter: [TransactionModel.keyModel : transaction, "date" : self.data["date"]!])
    }
    
}



//
//  DevideReceiverVC.swift
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
class DevideReceiverVC: BaseViewController {
    @IBOutlet weak var noBasketImv: UIImageView!
    @IBOutlet weak var noBasketView: UIView!
    var orderType : OrderType = OrderType.Centralize
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
        view.formTf.keyboardType = .decimalPad
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func updateInfo(transaction: TransactionModel) {
        
    }
    
    private func initView() {
        self.title = "CHỌN SỌT ĐẾN"
        self.noBasketImv.applySketchShadow()
        
        self.tabBarController?.view.addSubview(self.formQuantityView)
        self.formQuantityView.isHidden = true
        self.formQuantityView.delegate = self
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
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
            self.present(self.readerVC, animated: true, completion: nil)
    }
}

// MARK: - QRCodeReader Delegate Methods
extension DevideReceiverVC : QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        let typeId = String(result.value.prefix(2))
        let id = String(result.value.suffix(10))
        let dic : Dictionary<String,Any> = ["id" : Int(id) ?? 0, "type": Stock(rawValue: typeId) ?? Stock.Basket]
        
        reader.dismiss(animated: true, completion: {
            self.formQuantityView.isHidden = false
            self.formQuantityView.data = dic
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


extension DevideReceiverVC : FormOneFieldDelegate {
    func clickedButtonCancel(sender: FormOneField) {
        
    }
    
    func clickedButtonOK(sender: FormOneField) {
        if let quantity  = Int(sender.formTf.text!),
            let stockID = sender.data?["id"] as? Int,
            let type = sender.data?["type"] as? Stock,
            let transaction = self.data[TransactionModel.keyModel] as? TransactionModel{
            self.callAPIInsertTransaction(type : type, stockId: stockID, quantity: quantity, transactionId: transaction.id)
        }
    }
    
    func callAPIInsertTransaction(type : Stock, stockId: Int, quantity: Int, transactionId: Int) {
        // Call API
        if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            let branch : BranchModel = self.data["branch"] as! BranchModel
            var params : [String : Any] = ["supplier_transaction_id" : transactionId,
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
    }
    
    private func completionAPIInsertTransaction(result : NSDictionary?, error : NSError?){
        if error == nil && result != nil{
            // Success
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        }
        else {
            // Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
}

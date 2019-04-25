//
//  BasketBackVC.swift
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
class BasketBackVC: BaseViewController {
    @IBOutlet weak var noBasketImv: UIImageView!
    @IBOutlet weak var previewView: QRCodeReaderView! {
        didSet {
            previewView.setupComponents(showCancelButton: true, showSwitchCameraButton: true, showTorchButton: true, showOverlayView: true, reader: reader)
        }
    }
    
    var supplier: SupplierModel? = nil
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardNErrorTapAround()
        self.initView()
        self.initData()
    }
    
    private func initView() {
        self.title = "TRẢ SỌT HÀNG"
    }
    
    private func initData() {
        if let supplierModel = self.data[SupplierModel.keyModel] as? SupplierModel{
            self.supplier = supplierModel
        }
    }
    
    // MARK: - API
    private func callAPIReturnBasket(stockId : Int, type: Stock, supplierId: Int) {
        // Call API
        var params : [String : Any]  = ["supplier_id": supplierId]
        if type == Stock.Basket{
            params["basket_id"] = stockId
            APIBase.sharedInstance()?.callAPIReturnBasket(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIReturnBasket(result: result, error: error)
            })
        }
        else if type == Stock.Container {
            params["container_id"] = stockId
            APIBase.sharedInstance()?.callAPIReturnContainer(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIReturnBasket(result: result, error: error)
            })
        }
    }
    
    private func completionAPIReturnBasket(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            Util.showAlert("Trả sọt hàng thành công!")
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
extension BasketBackVC : QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        if let typeId = Stock(rawValue: String(result.value.prefix(2))),
            let id = Int(String(result.value.suffix(10))) {
            Util.showConfirmAlert(result.value, noCompletion: {
                reader.startScanning()
            }, yesCompletion: {
                reader.dismiss(animated: true, completion: {
                    self.callAPIReturnBasket(stockId: id, type: typeId, supplierId: self.supplier?.id ?? 0)
                })
            })
        }
        else {
            Util.showAlert("Sai định dạng QRCode", completion: {
                reader.startScanning()
            })
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

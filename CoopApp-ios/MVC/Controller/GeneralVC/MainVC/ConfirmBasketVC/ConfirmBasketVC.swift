//
//  ConfirmBasketVC.swift
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
//class YourCustomView: UIView, QRCodeReaderDisplayable {
//    func setNeedsUpdateOrientation() {
//
//    }
//
//    func setupComponents(showCancelButton: Bool, showSwitchCameraButton: Bool, showTorchButton: Bool, showOverlayView: Bool, reader: QRCodeReader?) {
//    }
//
//    let cameraView: UIView            = UIView()
//    let cancelButton: UIButton?       = UIButton()
//    let switchCameraButton: UIButton? = SwitchCameraButton()
//    let toggleTorchButton: UIButton?  = ToggleTorchButton()
//    var overlayView: UIView?          = UIView()
//
//}


class ConfirmBasketVC: BaseViewController {
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var packingLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var supplierLbl: UILabel!
    @IBOutlet weak var createdAtLbl: UILabel!
    @IBOutlet weak var resultSwitch: UISwitch!
    @IBOutlet weak var supermarketLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UIAppLabel!
    @IBOutlet weak var infoView: UIView!
    var selectedTransactionIndex : Int = 0
    var transactions: [TransactionModel] = []
    
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
    
//    lazy var readerVC: QRCodeReaderViewController = {
//        let builder = QRCodeReaderViewControllerBuilder {
//            let readerView = QRCodeReaderContainer(displayable: YourCustomView())
//            
//            $0.readerView = readerView
//        }
//        
//        return QRCodeReaderViewController(builder: builder)
//    }()

    lazy var confirmImageView : ConfirmImage = {
        let view = (Bundle.main.loadNibNamed("ConfirmImage", owner: self, options: nil))?[0] as! ConfirmImage
        view.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: SIZE_HEIGHT)
        view.isHidden = true
        return view
    }()
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func updateInfo(transaction: TransactionModel, indexTransaction: Int) {
        self.productNameLbl.text = transaction.product?.name
        self.skuLbl.text = String(format: "%d", transaction.product?.sku ?? 0)
        self.packingLbl.text = String(format: "%d %@", transaction.product_packing?.value ?? 0, transaction.product_packing?.unit ?? "")
        self.quantityLbl.text = String(format: "%f %@", transaction.quantity , transaction.product_packing?.unit ?? "")
        self.supplierLbl.text = transaction.supplier?.name
        self.supermarketLbl.text = transaction.to_branch?.name ?? transaction.branch?.name
        self.createdAtLbl.text = transaction.created_at
        
        if self.transactions.count == 1 {
            self.titleLbl.text = "Xác nhận hàng"
        }
        else {
            self.titleLbl.text = String(format: "%@ %d", "Xác nhận mặt hàng thứ ", indexTransaction + 1)
        }
        
    }
    
    private func initView() {
        self.title = "KIỂM ĐỊNH"
        self.resultSwitch.onTintColor = PRIMARY_COLOR
        self.infoView.isHidden = true
        self.infoView.applySketchShadow()
        self.imagePicker.delegate = self
    }
    
    // MARK: - API
    private func callAPIGetTransaction(id : Int, type: Stock) {
        // Remove old transaction
        self.transactions.removeAll()
        
        // Call API
        var params : [String : Any]  = [:]
        if type == Stock.Basket{
            params["basket_id"] = id
        }
        else if type == Stock.Container {
            params["container_id"] = id
        }
        
        if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue || (GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.orderType == OrderType.Decentralize ){
            APIBase.sharedInstance()?.callAPITransactionBasket(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIGetTransaction(result: result, error: error)
            })
        }
        else if (GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.orderType == OrderType.Centralize) {
            APIBase.sharedInstance()?.callAPIWarehouseTransactionBasket(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIGetTransaction(result: result, error: error)
            })
        }
    }
    
    private func completionAPIGetTransaction(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            let dics : Array<Dictionary<String,Any>> = result?["list_transaction"] as! Array<Dictionary<String, Any>>
            for dic in dics {
                self.transactions.append(TransactionModel(dict: dic))
            }
            if dics.count > 0 {
                self.selectedTransactionIndex = 0
                self.updateInfo(transaction: self.transactions[self.selectedTransactionIndex], indexTransaction: self.selectedTransactionIndex)
                self.infoView.isHidden = false
            }
            else {
                Util.showAlert("Sọt hàng không có hàng hóa.")
            }
        }
        else {
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func callAPIConfirmContent(transaction : TransactionModel, isPass: Bool, reason: String, quantity: Double){
        if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue || (GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.orderType == OrderType.Decentralize){
                let params : [String : Any]  = ["transaction_id": transaction.id,
                                                "branch_id": transaction.branch?.id ?? 0,
                                                "passed_flag" : isPass,
                                                "quantity" : quantity,
                                                "reason" : reason]
            APIBase.sharedInstance()?.callAPITransactionConfirmContent(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIConfirmContent(result: result, error: error)
                if isPass == false && result?["confirm_id"] != nil{
                    self.callAPIConfirmImage(image: self.confirmImageView.image.image ?? UIImage(named: "ICON")!, confirmID: result?["confirm_id"] as! Int)
                }
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.orderType == OrderType.Centralize {
            let params : [String : Any]  = ["warehouse_product_transaction_id": transaction.id,
                                            "branch_id": transaction.to_branch?.id ?? 0,
                                            "user_type_id" : 1,
                                            "passed_flag" : isPass,
                                            "quantity" : quantity,
                                            "reason" : reason]
            APIBase.sharedInstance()?.callAPIWarehouseTransactionConfirmContent(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIConfirmContent(result: result, error: error)
                if isPass == false && result?["confirm_id"] != nil{
                    self.callAPIConfirmImage(image: self.confirmImageView.image.image ?? UIImage(named: "ICON")!, confirmID: result?["confirm_id"] as! Int)
                }
            })
        }
    }
    
    private func completionAPIConfirmContent(result : NSDictionary?, error : NSError?){
        if error == nil {
            // Success
            
            Util.showAlert("Xác nhận hàng hóa thành công!", completion: {
                if self.selectedTransactionIndex + 1 >= self.transactions.count{
                    self.selectedTransactionIndex = 0
                    self.infoView.isHidden = true
                }
                else {
                    self.selectedTransactionIndex += 1
                    self.updateInfo(transaction: self.transactions[self.selectedTransactionIndex], indexTransaction: self.selectedTransactionIndex)
                }
            })
        }
        else {
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    private func callAPIConfirmImage(image : UIImage, confirmID: Int) {
        let params : [String : Any]  = ["LATITUDE": "10",
                                        "LONGITUDE": "106",
                                        "CONFIRM-ID" : String(confirmID)]
        if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue || (GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.orderType == OrderType.Decentralize){
            APIBase.sharedInstance()?.callAPITransactionConfirmImage(isShowHUD: true, params: params, image: image, completionHandler: { (result, error) in
//                self.completionAPIConfirmImage(result: result, error: error)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue && self.orderType == OrderType.Centralize {
            APIBase.sharedInstance()?.callAPIWarehouseTransactionConfirmImage(isShowHUD: true, params: params, image: image, completionHandler: { (result, error) in
//                self.completionAPIConfirmImage(result: result, error: error)
            })
        }
    }
    
    private func completionAPIConfirmImage(result : NSDictionary?, error : NSError?) {
        if error == nil {
            // Success
            Util.showAlert("Upload ảnh thành công", completion: {
                self.infoView.isHidden = true
            })
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
        
        if GlobalQuick.userLogin?.rule == UserRole.Supermarket.rawValue {
            let alertController: UIAlertController = UIAlertController(title: "CHỌN LOẠI ĐƠN HÀNG", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "TẬP TRUNG", style: UIAlertActionStyle.default, handler: { (alert) in
                self.orderType = OrderType.Centralize
                self.present(self.readerVC, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "ĐA PHƯƠNG", style: UIAlertActionStyle.default, handler: { (alert) in
                self.orderType = OrderType.Decentralize
                self.present(self.readerVC, animated: true, completion: nil)
            }))
            self.tabBarController?.present(alertController, animated: true, completion: nil)

        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            self.present(self.readerVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        if resultSwitch.isOn == true {
            self.callAPIConfirmContent(transaction: self.transactions[self.selectedTransactionIndex], isPass: true, reason: "", quantity: self.transactions[self.selectedTransactionIndex].quantity )
        }
        else {
            self.tabBarController?.view.addSubview(self.confirmImageView)
            self.confirmImageView.unitLbl.text = self.transactions[self.selectedTransactionIndex].product_packing?.unit
            self.confirmImageView.isHidden = false
            self.confirmImageView.delegate = self
        }
    }
    
}

// MARK: - QRCodeReader Delegate Methods
extension ConfirmBasketVC : QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        if let typeId = Stock(rawValue: String(result.value.prefix(2))),
            let id = Int(String(result.value.suffix(10))) {
            Util.showConfirmAlert(result.value, noCompletion: {
                reader.startScanning()
            }, yesCompletion: {
                reader.dismiss(animated: true, completion: {
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
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}


extension ConfirmBasketVC :  ConfirmImageDelegate {
    func clickedButtonCamera(sender: ConfirmImage) {
        self.launchCamera()
    }
    
    func clickedButtonSend(sender: ConfirmImage) {
        let reason : String = self.confirmImageView.contentTf.text
        let quantity : Double = Double(self.confirmImageView.quantityTf!.text!)!
        self.callAPIConfirmContent(transaction: self.transactions[self.selectedTransactionIndex], isPass: false, reason: reason, quantity:quantity)
    }
    
    /*
     * Created by: cuongkt
     * Description: Check permission and launch camera
     */
    func launchCamera() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .authorized:
            // Open camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
            break
        case .denied, .restricted:
            break
        case .notDetermined:
            // Ask for permissions
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    // Open camera
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            break
        }
    }
}

extension ConfirmBasketVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /*
     * Created by: cuongkt
     * Description: Did finish picking image from gallery
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.confirmImageView.updateImage(image: pickedImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     * Created by: cuongkt
     * Description: Did cancel picking image
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  GetSupportCenterInfo.swift
//  SOS
//
//  Created by DucLA on 4/11/17.
//  Copyright © 2017 VCC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import AeroGearOTP
import MBProgressHUD

class APIManager {
    static let shareObject = APIManager()

    var header: HTTPHeaders!
    var manager: SessionManager!

    init() {
        header = [String : String]()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30

        manager = Alamofire.SessionManager(configuration: configuration)
    }

    func commonParam() -> Parameters {
//        PublicVariables.api_auth_date = Date().toMillis().description
//        PublicVariables.api_auth_key = ("smarttablet" + PublicVariables.api_auth_date).md5()
        return [:]
    }

    internal func getHeader() -> [String:String] {
        let accessToken: String = Util.getValueFromUserDefault(key: GlobalQuick.accessTokenKey) as? String ?? ""
        let otp = genOTP()!
        return ["Content-Type" : "text/plain",
                "Authorization": "Bearer \(accessToken)",
                "Coop-Device": otp]
    }
    
    internal func genOTP() -> String? {
        let seconds: TimeInterval = Date().timeIntervalSince1970
        let s = UInt64(seconds)
        var current_time_no_second: UInt64 = (s / 60) * 60 //+self.time_delta;//1534913533 ;//
        let current_second = Int(s % 60)
        if current_second < 30 {
            current_time_no_second += 29
        } else {
            current_time_no_second += 59
        }
        let generator = AGTotp(secret: AGBase32.base32Decode("najvj5u2sd5svty"))
        let strOTP = generator?.generate(forCounter: current_time_no_second)
        return strOTP
    }
    
    internal func aut_basic(_ username: String?, password: String?) -> String? {
        // Forming string with credentials 'myusername:mypassword'
        let authStr = "\(username ?? ""):\(password ?? "")"
        // Getting data from it
        let authData: Data? = authStr.data(using: .ascii)
        // Encoding data with base64 and converting back to NSString
        var authStrData: String? = nil
        if let base64 = authData?.base64EncodedData(options: .endLineWithLineFeed) {
            authStrData = String(data: base64, encoding: .ascii)
        }
        // Set your user login credentials
        return "Basic \(authStrData ?? "")"
    }

    internal func parse_data_output(_ params: [AnyHashable : Any]?) -> NSData? {
        var _: Error?
        var data: NSData? = nil
        if let params = params {
            data = try? JSONSerialization.data(withJSONObject: params, options: []) as NSData
        }
        return data?.zlibDeflate() as NSData?
    }
    
    internal func parse_data_input(_ data: NSData?, url: String?) -> NSData? {
        let res: NSData? = data?.zlibInflate() as NSData?
        var jsonObject: [AnyHashable : Any]? = nil
        
            try? jsonObject = JSONSerialization.jsonObject(with: res! as Data, options: []) as? [AnyHashable : Any]
        
        if let jsonObject = jsonObject {
            print("\(url ?? "") : \(jsonObject)")
        }
        return res
    }

    
    /*
     * Created by: cuongkt
     * Description: callAPIRequest
     */
    func callAPIRequest(isShowHUD: Bool, requestURL:String, method:HTTPMethod, param: Parameters?, imageParams: [String: UIImage]? = nil, header: HTTPHeaders?,
                        completionHandler: @escaping(NSDictionary?,NSError?) -> ()) {
        
        // Show MBProgressHUD
        var hud: MBProgressHUD? = nil
        if isShowHUD == true { hud = Util.getShowMBProgressHUD() }
        if imageParams != nil { hud?.mode = MBProgressHUDMode.annularDeterminate }
        
        // Call API
        Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
            // Images
            if imageParams != nil {
                for imageParamChild in imageParams! {
                    if let imageData: Data = UIImagePNGRepresentation(imageParamChild.value) {
                        multipartFormData.append(imageData, withName: imageParamChild.key, fileName: "file.png", mimeType: "image/png")
                    }
                }
            }
            
            // Texts
            if param != nil {
                for paramChild in param! {
                    let valueStringData: String? = String(describing: paramChild.value)
                    if let valueData: Data = valueStringData?.data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: paramChild.key)
                    }
                }
            }            
        }, to: requestURL,method: method, headers: header) { (result: SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                break
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress: Progress) in
                }).responseData(completionHandler: { (response) in
                    // Hide MBProgressHUD
                    Util.hideAllMBProgressHUD()

                    switch response.result {
                    case .success(let data):
                        let dataDecrypt: Data? = self.parse_data_input(data as NSData, url: "") as Data?
                        var dic: NSDictionary? = nil
                        try? dic = JSONSerialization.jsonObject(with: dataDecrypt! as Data, options: []) as? NSDictionary
                        completionHandler(dic, nil)
                    case .failure(let error):
                        print("\(error)")
                        completionHandler(nil, error as NSError)
                    }
                })
                break
            }
        }
    }

    // MARK: - Show API error

    func showAPIError(result: NSDictionary?, in viewController: UIViewController? = nil) {
        if let error: NSDictionary = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary {
            if let errorMessage: String = error.object(forKey: "message") as? String {
                if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                    // Init alert
                    let alertController: UIAlertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    }))

                    // Make title smaller
                    alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

                    // Show alert
                    if viewController != nil { viewController?.present(alertController, animated: true, completion: nil) }
                    else { appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil) }
                }
            }
        }
    }
}

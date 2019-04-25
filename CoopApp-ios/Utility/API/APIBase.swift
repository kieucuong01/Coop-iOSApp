//
//  APIBase3.swift
//  CoopApp-ios
//
//  Created by KTC on 2/28/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import Foundation
import AeroGearOTP
import AudioToolbox
import MBProgressHUD

enum PROTOCOL: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

class APIBase {
    static var sharedInstanceVar: APIBase? = nil
    
    class func sharedInstance() -> APIBase? {
        if sharedInstanceVar == nil {
            sharedInstanceVar = APIBase()
        }
        return sharedInstanceVar
    }
    
    //MARK: AUTHENTICATE
    internal func commonParam() -> [String:Any] {
        //        PublicVariables.api_auth_date = Date().toMillis().description
        //        PublicVariables.api_auth_key = ("smarttablet" + PublicVariables.api_auth_date).md5()
        return [:]
    }
    
    internal func getHeader() -> [String:String] {
        let accessToken: String = Util.getValueFromUserDefault(key: GlobalQuick.accessTokenKey) as? String ?? ""
        let otp = genOTP()!
        return ["Content-Type" : "text/plain",
                "Minerva": "Bearer \(accessToken)",
            "Coop-Device": otp]
    }
    
    internal func getImageHeader() -> [String : String] {
        let accessToken: String = Util.getValueFromUserDefault(key: GlobalQuick.accessTokenKey) as? String ?? ""
        let otp = genOTP()!
        return ["Content-Type" : "image/png",
                "Minerva": "Bearer \(accessToken)",
                "Coop-Device": otp,
                "Content-Disposition" : "name=\"file\"; filename=\"image.png\""]
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
        //NSLog(@"%d - %ld -  %@ ", current_time_no_second, s, strOTP);
        return strOTP
    }
    
    func aut_basic(_ username: String?, password: String?) -> String? {
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
    
    private func parse_data_output(_ params: [AnyHashable : Any]?) -> Data? {
        var _: Error?
        var data: NSData? = nil
        if let params = params {
            data = try? JSONSerialization.data(withJSONObject: params, options: []) as NSData
        }
        return data?.zlibDeflate()
    }
    
    private func parse_data_input(_ data: Data?) -> Data? {
        let res: Data? = (data as NSData?)?.zlibInflate()
        return res
    }
    
    //MARK: - SERVICES
    func callAPIRequest(isShowHUD: Bool, requestURL: String, method: PROTOCOL, params: [String : Any]? = nil, imageParams: [String: UIImage]? = nil, header: [String : Any]?,
                        completionHandler: @escaping(NSDictionary?,NSError?) -> ()) {
        // Show MBProgressHUD
        var hud: MBProgressHUD? = nil
        if isShowHUD == true { hud = Util.getShowMBProgressHUD() }
        if imageParams != nil { hud?.mode = MBProgressHUDMode.annularDeterminate }
        
        // Log
        print("API is calling :\(requestURL)")
        print("HTTP Params : \(params ?? [:])")
        print("HTTP Header : \(header ?? [:])")
        
        //Set up your request
        var request: NSMutableURLRequest? = nil
        if let url = URL(string: requestURL) {
            request = NSMutableURLRequest(url: url)
        }
        request?.httpMethod = method.rawValue
        // Setup header
        for key in (header?.keys)! {
            request?.addValue(header?[key] as! String, forHTTPHeaderField: key)
        }
        // Setup params
        if params != nil {
            request?.httpBody = self.parse_data_output(params)
        }
        
        // Send your request asynchronously
        var postDataTask: URLSessionDataTask? = nil
        if let request = request {
            postDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { responseData, response, error in
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 && responseData != nil {
                    let dataDecrypt: Data? = self.parse_data_input(responseData)
                    var dic: NSDictionary? = nil
                    if let dataDecrypt = dataDecrypt {
                        dic = try! JSONSerialization.jsonObject(with: dataDecrypt, options: []) as? NSDictionary
                        print("Response JSON: \(dic ?? [:])")
                    }
                    DispatchQueue.main.async {
                        // Hide MBProgressHUD
                        Util.hideAllMBProgressHUD()
                        if let success = dic?["success"] as? Bool{
                            if success == false {
                                Util.showAlert(dic?["detail"] as! String)
//                                completionHandler(nil, nil)
                            }
                            else {
                                completionHandler(dic, nil)
                            }
                            if dic?["code"] as? Int == 103 {
                                GlobalQuick.logOut()
                            }
                        }
                    }
                } else if  httpResponse?.statusCode == 500  {
                    DispatchQueue.main.async {
                        Util.hideAllMBProgressHUD()
                        Util.showAlert("500 Internal Server Error")
                    }
                }
                else {
                    DispatchQueue.main.async {
                        // Hide MBProgressHUD
                        Util.hideAllMBProgressHUD()
                        print("Error: \(String(describing: error))")
                        completionHandler(nil, error as NSError?)
                    }
                }
            })
        }    
        postDataTask?.resume()
    }
    
    func callAPILogin(isShowHUD: Bool, username: String, password: String, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: "\(APP_BASE_URL)\(API_GET_LOGIN)", method: PROTOCOL.POST, params: nil, header: ["Authorization": self.aut_basic(username, password: password)!,"Coop-Device": self.genOTP()!]) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    // MARK: avatar
    
    func callAPIImageRequest(isShowHUD: Bool, requestURL: String, method: PROTOCOL, params: [String : Any]? = nil, imageParam: UIImage, header: [String : Any]?,
                        completionHandler: @escaping(NSDictionary?,NSError?) -> ()) {
        // Show MBProgressHUD
        let hud: MBProgressHUD? = nil
        if isShowHUD == true { hud?.mode = MBProgressHUDMode.annularDeterminate }
        
        // Log
        print("API is calling :\(requestURL)")
        print("HTTP Header : \(header ?? [:])")
        
        //Set up your request
        var request: NSMutableURLRequest? = nil
        if let url = URL(string: requestURL) {
            request = NSMutableURLRequest(url: url)
        }
        request?.httpMethod = method.rawValue
        // Setup header
        for key in (header?.keys)! {
            request?.addValue(header?[key] as! String, forHTTPHeaderField: key)
        }
        
        for key in (params?.keys)! {
            request?.addValue(params?[key] as! String, forHTTPHeaderField: key)
        }
        
        
        let imageData: Data? = UIImageJPEGRepresentation(imageParam, 0.25)
    
        // Send your request asynchronously
        var postDataTask: URLSessionDataTask? = nil
        if let request = request {
            postDataTask = URLSession.shared.uploadTask(with: request as URLRequest, from: imageData, completionHandler: { responseData, response, error in
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200 && responseData != nil {
                    let dataDecrypt: Data? = self.parse_data_input(responseData)
                    var dic: NSDictionary? = nil
                    if let dataDecrypt = dataDecrypt {
                        dic = try! JSONSerialization.jsonObject(with: dataDecrypt, options: []) as? NSDictionary
                        print("Response JSON: \(dic ?? [:])")
                    }
                    DispatchQueue.main.async {
                        // Hide MBProgressHUD
                        Util.hideAllMBProgressHUD()
                        if let success = dic?["success"] as? Bool{
                            if success == false {
                                Util.showAlert(dic?["detail"] as! String)
                                //                                completionHandler(nil, nil)
                            }
                            else {
                                completionHandler(dic, nil)
                            }
                            if dic?["code"] as? Int == 103 {
                                GlobalQuick.logOut()
                            }
                        }
                    }
                } else if  httpResponse?.statusCode == 500  {
                    DispatchQueue.main.async {
                        Util.hideAllMBProgressHUD()
                        Util.showAlert("500 Internal Server Error")
                    }
                }
                else {
                    DispatchQueue.main.async {
                        // Hide MBProgressHUD
                        Util.hideAllMBProgressHUD()
                        print("Error: \(String(describing: error))")
                        completionHandler(nil, error as NSError?)
                    }
                }
            })
        }
        postDataTask?.resume()
    }

    
//    func uploadAvatar(_ picture: UIImage, returnBlock: @escaping (Any?) -> Void) {
//        let imageData: Data? = UIImagePNGRepresentation(picture)
//
//        var request: NSMutableURLRequest? = get_request(HOST_SERVICE_UPDATE_AVATAR)
//        request?.addValue(bearer()!, forHTTPHeaderField: "Authorization")
//        request?.addValue("name=\"file\"; filename=\"avatar.jpg\"", forHTTPHeaderField: "Content-Disposition")
//        request?.addValue("image/png", forHTTPHeaderField: "Content-Type")
//        request?.httpMethod = "PUT"
//
//        var uploadTask: URLSessionUploadTask? = nil
//        if let request = request {
//            uploadTask = URLSession.shared.uploadTask(with: request as URLRequest, from: imageData, completionHandler: { responseData, response, error in
//                let httpResponse = response as? HTTPURLResponse
//                if httpResponse?.statusCode == 200 && responseData != nil {
//                    let data: Data? = self.parse_data_input(responseData, url: HOST_SERVICE_UPDATE_AVATAR)
//                    var model: MUploadImage? = nil
//                    if let data = data {
//                        model = try? MUploadImage(data: data)
//                    }
//                    if error == nil {
//                        returnBlock(model)
//                    } else {
//                        let model = MModel()
//                        model.success = NSNumber(value: 0) as! (NSInteger)
//                        model.title = self.method(HOST_SERVICE_UPDATE_AVATAR)
//                        model.detail = error?.localizedDescription
//                        returnBlock(model)
//                    }
//                } else {
//                    self.callBackError(HOST_SERVICE_UPDATE_AVATAR, httpResponse: httpResponse, responseData: responseData, returnBlock: returnBlock)
//                }
//            })
//        }
//        uploadTask?.resume()
//    }
}

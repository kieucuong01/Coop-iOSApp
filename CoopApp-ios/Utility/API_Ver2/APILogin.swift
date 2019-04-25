//
//  APILogin.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import Foundation

extension APIManager {
    func callAPILogin(isShowHUD: Bool, user:String, password:String , completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        let requestURL =  "\(APP_BASE_URL)\(API_GET_LOGIN)"
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: .post, param: nil, header: ["Authorization": aut_basic(user, password: password)!, "MNV-Device" : genOTP()!]) { (result, error) in
            completionHandler(result,error)
        }
    }
}

//
//  APIGetOrders.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import Foundation
import Alamofire

extension APIManager {
    
    func callAPIGetOrders(isShowHUD: Bool, params: Parameters?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_SALE_ORDER)"
        print("API is calling :\(requestURL)")
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: .post, param: newParam, header: getHeader()) { (result, error) in
            completionHandler(result,error)
        }
    }
    
}

//
//  APIOrder.swift
//  CoopApp-ios
//
//  Created by KTC on 3/13/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

extension APIBase {
    func callAPIGetOrders(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_SALE_ORDER)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    
    func callAPIGetCategories(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let requestURL = "\(APP_BASE_URL)\(API_GET_CATEGORIES)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.GET, params: params, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIGetBranch(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_GET_BRANCH)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIGetBranchType(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let requestURL = "\(APP_BASE_URL)\(API_GET_BRANCH_TYPE)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.GET, params: params, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
}

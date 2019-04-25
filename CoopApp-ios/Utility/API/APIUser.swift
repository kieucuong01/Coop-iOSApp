//
//  File.swift
//  CoopApp-ios
//
//  Created by MAC on 3/22/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

extension APIBase {
    func callAPIGetProfile(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let requestURL = "\(APP_BASE_URL)\(API_GET_PROFILE)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.GET, params: params, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIUpdateProfile(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_UPDATE_PROFILE)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.PUT, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIUpdateAvatar(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_UPDATE_AVATAR)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.PUT, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
}

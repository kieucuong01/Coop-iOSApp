//
//  APITransport.swift
//  CoopApp-ios
//
//  Created by KTC on 3/14/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

extension APIBase {
    func callAPITransportVehicleList(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_VEHICLE_LIST)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportStart(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_START)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportMapping(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_MAPPING)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportInsert(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_INSERT)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportTransaction(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_TRANSACTION)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportSearch(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_SEARCH)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportFinish(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_FINISH)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportStatus(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_STATUS)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransportLocation(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSPORT_LOCATION)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
}

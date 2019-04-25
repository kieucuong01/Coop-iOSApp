//
//  APIWarehouseTransport.swift
//  CoopApp-ios
//
//  Created by KTC on 3/14/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

extension APIBase {
    func callAPIWarehouseTransportVehicleList(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_VEHICLE_LIST)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }


    func callAPIStartWarehouseVehicle(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_START)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransportMapping(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_MAPPING)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }

    
    func callAPIWarehouseTransportInsert(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_INSERT)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }


    func callAPIWarehouseTransportTransaction(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_TRANSACTION)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransportSearch(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_SEARCH)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransportFinish(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_FINISH)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransportStatus(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_STATUS)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransportLocation(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSPORT_LOCATION)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
}

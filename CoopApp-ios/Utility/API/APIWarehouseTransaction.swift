//
//  APIWarehouseTransaction.swift
//  CoopApp-ios
//
//  Created by KTC on 3/13/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import Alamofire

extension APIBase {
    func callAPIWarehouseTransactionList(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSACTION_LIST)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransactionInsert(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSACTION_INSERT)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransactionConfirmContent(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSACTION_CONFIRM_CONTENT)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransactionConfirmImage(isShowHUD: Bool,  params: [String : Any]?, image: UIImage, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let requestURL = "\(APP_BASE_URL)\(API_TRANSACTION_CONFIRM_IMAGE)"
        let header = getImageHeader()
        
        self.callAPIImageRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: params, imageParam: image, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPIWarehouseTransactionConfirmList(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_WAREHOUSE_TRANSACTION_CONFIRM_LIST)"
        let header = getHeader()
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
}

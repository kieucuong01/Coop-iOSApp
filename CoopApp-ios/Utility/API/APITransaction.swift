//
//  APITransactionList.swift
//  CoopApp-ios
//
//  Created by KTC on 3/5/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import Alamofire

extension APIBase {
    func callAPITransactionList(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSACTION_LIST)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransactionInsert(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSACTION_INSERT)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransactionConfirmContent(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSACTION_CONFIRM_CONTENT)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransactionConfirmImage(isShowHUD: Bool,  params: [String : Any]?, image: UIImage, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        let requestURL = "\(APP_BASE_URL)\(API_TRANSACTION_CONFIRM_IMAGE)"
        let header = getImageHeader()
        
        self.callAPIImageRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params : params, imageParam: image, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
    
    func callAPITransactionConfirmList(isShowHUD: Bool, params: [String : Any]?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        var newParam = commonParam()
        if params != nil {
            for key in (params?.keys)! {
                newParam[key] = params?[key]
            }
        }
        let requestURL = "\(APP_BASE_URL)\(API_TRANSACTION_CONFIRM_LIST)"
        let header = getHeader()
        
        self.callAPIRequest(isShowHUD: isShowHUD, requestURL: requestURL, method: PROTOCOL.POST, params: newParam, header: header) { (result, error) in
            completionHandler(result,error)
        }
    }
}

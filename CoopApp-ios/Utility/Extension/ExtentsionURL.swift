//
//  ExtentsionURL.swift
//  ParkingManagementApp-ios
//
//  Created by KTC on 7/13/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//
import UIKit

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

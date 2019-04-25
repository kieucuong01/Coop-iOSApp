//
//  ConstantApp.swift
//  CoopApp-ios
//
//  Created by MAC on 3/19/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

enum SearchVehicleType : String {
    case Code = "code"
    case PlateNumber = "plate_number"
}

enum OrderType : Int {
    case Centralize = 1
    case Decentralize = 2
}
enum UserRole : String {
    case Supplier
    case Warehouse
    case Supermarket
    case Admin
}

enum Stock : String {
    case Basket = "01"
    case Container = "02"
}

enum VehicleStatus : Int {
    case STATUS_START = 2
    case STATUS_BROKEN = 5
    case STATUS_TRAFIC = 6
}

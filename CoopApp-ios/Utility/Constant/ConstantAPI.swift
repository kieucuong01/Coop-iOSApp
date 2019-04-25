//
//  ConstantAPI.swift
//  SmartTablet
//
//  Created by thanhlt on 7/17/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import Foundation

#if STAGING
    let APP_BASE_URL = "http://118.69.82.125:8001/api/v1/"
#else
    let APP_BASE_URL = "https://mikata.smart-campus.jp/api/public/"

#endif
let CONTACT_URL_STRING                 = APP_BASE_URL + "static/about"
let POLICY_URL_STRING                  = APP_BASE_URL + "static/rule"
let SUPPORT_URL_STRING                  = APP_BASE_URL + "static/support"

let API_GET_PROFILE                 = "query/profile"
let API_UPDATE_PROFILE              = "query/profile"
let API_UPDATE_AVATAR               = "query/profile/update_avatar"
let API_GET_LOGIN                   = "login"
let API_SALE_ORDER                  = "query/sale_order/product"
let API_GET_BRANCH                  = "query/sale_order/branch"
let API_GET_BRANCH_TYPE             = "query/master/branch_type"

let API_TRANSACTION_LIST            = "query/supplier/transaction/list"
let API_TRANSACTION_INSERT          = "query/supplier/transaction/insert"
let API_TRANSACTION_BASKET          = "query/supplier/transaction/basket"
let API_TRANSACTION_CONFIRM_CONTENT = "query/supplier/transaction/confirm/content"
let API_TRANSACTION_CONFIRM_IMAGE   = "query/supplier/transaction/confirm/image"
let API_TRANSACTION_CONFIRM_LIST    = "query/supplier/transaction/confirm/list"

let API_WAREHOUSE_TRANSACTION_LIST            = "query/warehouse/transaction/list"
let API_WAREHOUSE_TRANSACTION_INSERT          = "query/warehouse/transaction/insert"
let API_WAREHOUSE_TRANSACTION_BASKET          = "query/warehouse/transaction/basket"
let API_WAREHOUSE_TRANSACTION_CONFIRM_CONTENT = "query/warehouse/transaction/confirm/content"
let API_WAREHOUSE_TRANSACTION_CONFIRM_IMAGE   = "query/warehouse/transaction/confirm/image"
let API_WAREHOUSE_TRANSACTION_CONFIRM_LIST    = "query/warehouse/transaction/confirm/list"

let API_VEHICLE_LIST                = "query/supplier/vehicle/list"
let API_VEHICLE_INSERT              = "query/supplier/vehicle/insert"
let API_VEHICLE_EDIT                = "query/supplier/vehicle/edit"
let API_VEHICLE_DELETE              = "query/supplier/vehicle/delete"

let API_TRANSPORT_VEHICLE_LIST       = "query/supplier/vehicle/transport/vehicle"
let API_TRANSPORT_START               = "query/supplier/vehicle/transport/start"
let API_TRANSPORT_MAPPING           = "query/supplier/vehicle/transport/mapping"
let API_TRANSPORT_INSERT            = "query/supplier/vehicle/transport/insert"
let API_TRANSPORT_TRANSACTION       = "query/supplier/vehicle/transport/transaction"
let API_TRANSPORT_SEARCH           = "query/supplier/vehicle/transport/search"
let API_TRANSPORT_FINISH           = "query/supplier/vehicle/transport/finish"
let API_TRANSPORT_STATUS           = "query/supplier/vehicle/transport/status"
let API_TRANSPORT_LOCATION           = "query/supplier/vehicle/transport/location"

let API_WAREHOUSE_VEHICLE_LIST                = "query/warehouse/vehicle/list"
let API_WAREHOUSE_VEHICLE_INSERT              = "query/warehouse/vehicle/insert"
let API_WAREHOUSE_VEHICLE_EDIT                = "query/warehouse/vehicle/edit"
let API_WAREHOUSE_VEHICLE_DELETE              = "query/warehouse/vehicle/delete"

let API_WAREHOUSE_TRANSPORT_VEHICLE_LIST       = "query/warehouse/vehicle/transport/vehicle"
let API_WAREHOUSE_TRANSPORT_START               = "query/warehouse/vehicle/transport/start"
let API_WAREHOUSE_TRANSPORT_MAPPING           = "query/warehouse/vehicle/transport/mapping"
let API_WAREHOUSE_TRANSPORT_INSERT           = "query/warehouse/vehicle/transport/insert"
let API_WAREHOUSE_TRANSPORT_TRANSACTION       = "query/warehouse/vehicle/transport/transaction"
let API_WAREHOUSE_TRANSPORT_SEARCH           = "query/warehouse/vehicle/transport/search"
let API_WAREHOUSE_TRANSPORT_FINISH           = "query/warehouse/vehicle/transport/finish"
let API_WAREHOUSE_TRANSPORT_STATUS           = "query/warehouse/vehicle/transport/status"
let API_WAREHOUSE_TRANSPORT_LOCATION           = "query/warehouse/vehicle/transport/location"

let API_BASKET_LIST                 = "query/basket/list"
let API_BASKET_INSERT               = "query/basket/insert"
let API_BASKET_RETURN               = "query/basket/location"
let API_BASKET_SEARCH               = "query/basket/search"

let API_CONTAINER_LIST              = "query/container/list"
let API_CONTAINER_INSERT            = "query/container/insert"
let API_CONTAINER_RETURN            = "query/container/location"
let API_CONTAINER_SEARCH            = "query/container/search"

let API_PRODUCT_LIST                = "query/supplier/product/list"

let API_GET_CATEGORIES              = "query/master/business_category"

let API_SUPPLIER_LIST                = "query/supplier/list"

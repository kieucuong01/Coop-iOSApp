//
//  Constant.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/19/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

let SIZE_WIDTH:CGFloat          =       UIScreen.main.bounds.size.width
let SIZE_HEIGHT:CGFloat         =       UIScreen.main.bounds.size.height

let DISPLAY_SCALE:CGFloat       =       SIZE_WIDTH/375.0
let DISPLAY_SCALE_IPAD:CGFloat  =       SIZE_WIDTH/768.0


//MARK:- Device
let IS_IPAD             =       UI_USER_INTERFACE_IDIOM() == .pad


//MARK: - UserDefault Name
let kUserDefaultUserId = "kUserDefaultUserID"
let kUserDefaultAccessToken = "kUserDefaultAccessToken"
let kUserDefaultUserListLastMessageId = "kUserDefaultUserListLastMessageId"

//MARK: COLOR
let WHITE_COLOR = UIColor(red: 255, green: 255, blue: 255)
let BLACK_COLOR = UIColor(red: 0, green: 0, blue: 0)
let PRIMARY_COLOR : UIColor = UIColor(red: 21, green: 101, blue: 192)
let GRAY1_COLOR = UIColor(red: 34, green: 34, blue: 34)
let GRAY2_COLOR = UIColor(red: 85, green: 85, blue: 85)
let GRAY3_COLOR : UIColor = UIColor(red: 153, green: 153, blue: 153)
let GRAY4_COLOR = UIColor(red: 204, green: 204, blue: 204)
let GRAY_COLOR_244 = UIColor(red: 244, green: 244, blue: 244)
let FORM_BACKGROUND_COLOR = UIColor(red: 46, green: 42, blue: 37)
let BORDER_COLOR = UIColor(red: 238, green: 238, blue: 238)

//MARK: FONT
let PRIMARY_FONT_NAME_MEDIUM : String = "AvenirNext-Medium"
let PRIMARY_FONT_NAME_REGULAR : String = "AvenirNext-Regular"
let PRIMARY_ENGLISH_FONT_NAME_MEDIUM : String = "AvenirNext-Medium"
let PRIMARY_ENGLISH_FONT_NAME_REGULAR : String = "AvenirNext-Regular"


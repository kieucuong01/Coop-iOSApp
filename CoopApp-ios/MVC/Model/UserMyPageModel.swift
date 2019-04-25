//
//  UserMyPageModel.swift
//  OwnersClub-ios
//
//  Created by KTC on 7/11/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

// MARK: - Model
class UserMyPageModel: NSObject {
    static let keyModel : String = "user_mypage_model"
    // Attributes
    var username: String = ""
    var mobile: String = ""
    var email: String = ""
    var full_name: String = ""
    var avatar_url: String = ""
    
    init (dict: Dictionary<String, Any>) {
        if let username:String = dict["username"] as? String {
            self.username = username
        }
        
        if let mobile:String = dict["mobile"] as? String {
            self.mobile = mobile
        }
        
        if let email:String = dict["email"] as? String {
            self.email = email
        }
        
        if let full_name:String = dict["full_name"] as? String {
            self.full_name = full_name
        }
        
        if let avatar_url:String = dict["avatar_url"] as? String {
            self.avatar_url = avatar_url
        }
    }
}

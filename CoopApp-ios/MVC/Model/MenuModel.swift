//
//  MenuModel.swift
//  CoopApp-ios
//
//  Created by KTC on 3/7/19.
//  Copyright © 2019 Minerva. All rights reserved.
//
import UIKit

class MenuModel: NSObject {
    var title : String = ""
    var image : UIImage
    
    init(title: String, image: UIImage){
        self.title = title
        self.image = image
    }
}

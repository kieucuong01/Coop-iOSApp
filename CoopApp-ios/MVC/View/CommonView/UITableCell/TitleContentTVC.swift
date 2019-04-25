//
//  TitleContentTVC.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/27/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class TitleContentTVC: UITableViewCell {
    @IBOutlet weak var titlelbl: UIAppLabel!
    @IBOutlet weak var contentlbl: UIAppLabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateViewCell(title : String, content : String) {
        self.titlelbl.text = title
        self.contentlbl.text = content
        if content == "" {
            self.contentlbl.text = "-"
        }
        self.layoutIfNeeded()
    }
}

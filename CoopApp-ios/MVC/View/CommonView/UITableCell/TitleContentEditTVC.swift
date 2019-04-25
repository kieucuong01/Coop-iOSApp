//
//  TitleContentEditTVC.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/27/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class TitleContentEditTVC: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var contentTv: UITextView!
    @IBOutlet weak var titleLbl: UIAppLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureView(){
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentTv.textContainerInset = UIEdgeInsets(top: 15 * DISPLAY_SCALE, left: 10, bottom: 10, right: 10)
        self.contentTv.layer.cornerRadius = 6 * DISPLAY_SCALE
        self.contentTv.backgroundColor = .white
        self.contentTv.layer.borderWidth = 1.5 * DISPLAY_SCALE
        self.contentTv.layer.borderColor = BORDER_COLOR.cgColor
        self.contentTv.textColor = GRAY1_COLOR
    }

    func updateViewCell(title : String, content : String){
        self.titleLbl.text = title
        self.contentTv.text = content
        self.contentTv.keyboardType = .default
    }
    
}

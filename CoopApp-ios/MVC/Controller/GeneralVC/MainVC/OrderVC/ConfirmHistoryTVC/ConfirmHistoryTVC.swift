//
//  ConfirmHistoryTVC.swift
//  CoopApp-ios
//
//  Created by MAC on 3/25/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit
protocol ConfirmHistoryTVCDelegate : class {
    func imageBtnAction(sender: ConfirmHistoryTVC)
}
class ConfirmHistoryTVC: UITableViewCell {
    @IBOutlet weak var createdDateLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var viewImagesBtn: UIButton!
    @IBOutlet weak var status2View: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    weak var delegate : ConfirmHistoryTVCDelegate? = nil
    var model : ConfirmHistoryModel? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureSelf()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.status2View.layer.cornerRadius = 5
    }

    
    func updateCell(model : ConfirmHistoryModel) {
        self.model = model
        self.createdDateLbl.text = model.created_at
        self.quantityLbl.text = String(format: "%.1f %@", model.quantity, model.packing?.unit ?? "")
        if model.passed_flag {
            self.statusView.backgroundColor = UIColor(red: 0, green: 144, blue: 81)
            self.status2View.backgroundColor = UIColor(red: 0, green: 144, blue: 81)
            self.statusLbl.text = "ĐẠT"
            self.reasonLbl.text = ""
            self.viewImagesBtn.isHidden = true
        }
        else {
            self.statusView.backgroundColor = UIColor.red
            self.status2View.backgroundColor = UIColor.red
            self.statusLbl.text = "KHÔNG ĐẠT"
            self.reasonLbl.text = model.reason
            //            self.viewImagesBtn.setImage("i", for: .normal)
        }
    }
    
    @IBAction func imageBtnAction(_ sender: UIButton) {
        self.delegate?.imageBtnAction(sender: self)
    }
}

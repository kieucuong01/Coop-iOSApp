//
//  OrderTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

protocol VehicleInforTVCDelegate: class {
    func viewPositionBtnAction(sender: VehicleInforTVC)
    func editBtnAction(sender: VehicleInforTVC)
    func deleteBtnAction(sender: VehicleInforTVC)
}

class VehicleInforTVC: UITableViewCell {
    @IBOutlet weak var plateNumberLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    
    @IBOutlet weak var driverLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var boxDimentionLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIColorButton!
    @IBOutlet weak var editBtn: UIDeleteButton!
    @IBOutlet weak var heightBtnConstraint: NSLayoutConstraint!
    
    var model : VehicleModel? = nil
    weak var delegate:VehicleInforTVCDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureSelf()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Configure View
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self        
        self.selectionStyle = UITableViewCellSelectionStyle.none
//        self.shadowView.layer.backgroundColor = UIColor.white.cgColor
//        self.shadowView.layer.cornerRadius = 12 * DISPLAY_SCALE
//        self.shadowView.applySketchShadow(color: GRAY2_COLOR, alpha: 0.4, x: 0.0, y: 2.0, blur: 8, spread: 0)
//
//        self.titleLabel.font = self.titleLabel.font.withSize(14.0 * DISPLAY_SCALE)
//        self.newLabel.font = self.newLabel.font.withSize(14.0 * DISPLAY_SCALE)
//        self.dateLabel.font = self.dateLabel.font.withSize(12.0 * DISPLAY_SCALE)
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(model: VehicleModel){
        self.model = model
        self.plateNumberLbl.text = String(format: "%@ %@", "Biển số: ", model.plate_number)
        if let transport = model.transport {
            self.codeLbl.text = String(format: "%@ %@", "Mã VC: ", transport.code)
        }
        self.mobileLbl.text = model.mobile
        self.boxDimentionLbl.text = model.box_dimension
        self.driverLbl.text = model.driver_name
        self.ownerLbl.text = model.owner
        self.weightLbl.text = String(model.max_weight)
        self.modelLbl.text = model.model
        if model.transport?.start_at != "None" && model.transport?.start_at != "" {
            self.editBtn.isHidden = true
            self.deleteBtn.isHidden = true
            self.heightBtnConstraint.constant = 0
        }
        else {
            self.editBtn.isHidden = false
            self.deleteBtn.isHidden = false
            self.heightBtnConstraint.constant = 30 * DISPLAY_SCALE
        }
        self.layoutIfNeeded()
    }
    
    @IBAction func viewPositionBtnAction(_ sender: UIButton) {
        self.delegate?.viewPositionBtnAction(sender: self)
    }
    @IBAction func editBtnAction(_ sender: UIButton) {
        self.delegate?.editBtnAction(sender: self)
    }
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        self.delegate?.deleteBtnAction(sender: self)
    }
}

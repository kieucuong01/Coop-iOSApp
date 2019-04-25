//
//  OrderTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class VehicleTVC: UITableViewCell {
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var barcodeLbl: UILabel!
    @IBOutlet weak var basketLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var transactionLbl: UILabel!
    @IBOutlet weak var containerLbl: UILabel!
    
    var model : VehicleModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        self.codeLbl.text = model.plate_number
        self.idLbl.text = model.owner
        self.transactionLbl.text = String(model.transport?.transactions ?? 0)
        self.basketLbl.text = String(model.transport?.basket ?? 0)
        self.containerLbl.text = String(model.transport?.container ?? 0)
        
        self.barcodeLbl.text = model.transport?.code ?? ""
        
        if let transport = model.transport {
            if transport.start_at != "None" &&  transport.start_at != ""{
                self.statusLbl.text = "Đang di chuyển"
            }
            else {
                self.statusLbl.text = "Đang chờ"
            }
        }
        else {
            self.statusLbl.text = "Đang chờ"
        }
//        self.layoutIfNeeded()
    }

}

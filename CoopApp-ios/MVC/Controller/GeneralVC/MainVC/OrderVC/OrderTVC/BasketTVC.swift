//
//  CartTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/4/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit
protocol BasketTVCDelegate : class {
    func historyConfirmAction(sender : BasketTVC)
}
class BasketTVC: UITableViewCell {

    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    weak var delegate : BasketTVCDelegate? = nil
    
    var model : TransactionModel? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.blue
        
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
    func updateViewCell(model: TransactionModel){
        self.model = model
        if let basket = model.basket {
            self.idLbl.text = String(format: "%@: %d", "Sọt", basket.id)
        }
        else {
            self.idLbl.text = String(format: "%@: %d", "Thùng", model.container?.id ?? 0)
        }
        
        if model.vehicle_transport_code != "" {
            self.typeLbl.text = String(format: "Mã VC: %@", model.vehicle_transport_code)
        }
        else {
            self.typeLbl.text = ""
        }
        self.quantityLbl.text = String(format: "%.1f %@", model.quantity, model.product_packing?.unit ?? "")
    }
    
    @IBAction func historyConfirmBtnAction(_ sender: UIButton) {
        self.delegate?.historyConfirmAction(sender: self)
    }
}

//
//  OrderTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class StockInfoTVC: UITableViewCell {
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var packingLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    var model : TransactionModel? = nil
    
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
        //self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(model: TransactionModel){
        self.model = model
        self.productNameLbl.text = model.product?.name
        self.skuLbl.text = String(format: "%@ %d", "SKU: ", model.product?.sku ?? 0)
        self.packingLbl.text = String(format: "Quy cách: %d %@", model.product_packing?.value ?? 0, model.product_packing?.unit ?? "")
        self.quantityLbl.text = String(format: "%.1f %@", model.quantity, model.product_packing?.unit ?? "")
//        self.layoutIfNeeded()
    }
}

//
//  ProductTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class TransactionTVC: UITableViewCell {
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var productImageImV: UIImageView!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var basketIdLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureSelf()
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
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(model: TransactionModel){
        self.quantityLbl.text = String(format: "%.1f %@", model.quantity , model.product_packing?.unit ?? "")
        self.productLbl.text = model.product?.name
        self.categoryLbl.text = model.product?.categoryName
        self.skuLbl.text = String(format: "SKU: %d", model.product?.sku ?? 0)
        if let basket = model.basket {
            self.productImageImV.image = basket.barcodeImg
            self.basketIdLbl.text = String(format: "ID: %d", basket.id)
        }
        else {
            self.productImageImV.image = model.container?.barcodeImg
            self.basketIdLbl.text = String(format: "ID: %d", model.container?.id ?? 0)
        }
    }
}

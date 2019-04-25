//
//  ProductTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class ProductTVC: UITableViewCell {
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var productImageImV: UIImageView!
    
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
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(model: ProductModel){
        self.productLbl.text = model.name
        self.categoryLbl.text = model.categoryName
        self.skuLbl.text = String(format: "SKU: %d", model.sku ?? 0)
        if let avatarURL = model.avatar {
            self.productImageImV.setImageForm(urlString: "http://118.69.82.125:8001" + avatarURL, placeHolderImage: UIImage(named: "ICON"))
        }
    }
}

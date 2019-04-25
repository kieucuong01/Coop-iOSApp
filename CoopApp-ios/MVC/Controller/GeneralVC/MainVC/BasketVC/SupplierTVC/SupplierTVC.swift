//
//  SupplierTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class SupplierTVC: UITableViewCell {
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var productImageImV: UIImageView!
    
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
    func updateViewCell(model: SupplierModel){
        self.productLbl.text = model.name
        self.categoryLbl.text = model.address
    }
}

//
//  SupermarketTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class SupermarketTVC: UITableViewCell {
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    @IBOutlet weak var productImageImV: UIImageView!
    @IBOutlet weak var isFinishImv: UIImageView!
    
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
    func updateViewCell(model: BranchModel){
        self.productLbl.text = model.name
        self.categoryLbl.text = model.type
        self.isFinishImv.isHidden = true
        self.productImageImV.setImageForm(urlString: "http://118.69.82.125:8001" + model.avatar, placeHolderImage: UIImage(named: "ic_product"))
    }
    
    func updateViewCell(model: OrderBranchModel){
        if let branch = model.branch {
            self.productLbl.text = branch.name
            self.categoryLbl.text = branch.type
            self.productImageImV.setImageForm(urlString: "http://118.69.82.125:8001" + branch.avatar, placeHolderImage: UIImage(named: "ic_product"))
        }
        
        if model.is_finish {
            self.isFinishImv.image = UIImage(named: "ic_completed")
        }
        else {
            self.isFinishImv.image = UIImage(named: "ic_uncompleted")
        }
    }
}

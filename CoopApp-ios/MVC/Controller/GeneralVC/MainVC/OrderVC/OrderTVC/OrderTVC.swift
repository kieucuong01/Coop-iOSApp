//
//  OrderTVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/1/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class OrderTVC: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var packingTitleLbl: UILabel!
    @IBOutlet weak var skuTitleLbl: UILabel!
    
    @IBOutlet weak var packingLbl: UILabel!
    @IBOutlet weak var skuLbl: UILabel!
    
    @IBOutlet weak var branchNameLbl: UILabel!
    @IBOutlet weak var saleOrderSumLbl: UILabel!
    
    @IBOutlet weak var saleOrderConfirmLbl: UILabel!
    @IBOutlet weak var saleOrderSpmLbl: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var view2WidthConstraint: NSLayoutConstraint!
    
    
    var model : OrderModel? = nil
    
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
        self.shadowView.layer.backgroundColor = UIColor.white.cgColor
        self.shadowView.layer.cornerRadius = 6 * DISPLAY_SCALE
        self.shadowView.applySketchShadow(color: GRAY2_COLOR, alpha: 0.4, x: 0.0, y: 2.0, blur: 8, spread: 0)
        self.view2WidthConstraint.constant = self.shadowView.frame.width/3
//        self.titleLabel.font = self.titleLabel.font.withSize(14.0 * DISPLAY_SCALE)
//        self.newLabel.font = self.newLabel.font.withSize(14.0 * DISPLAY_SCALE)
//        self.dateLabel.font = self.dateLabel.font.withSize(12.0 * DISPLAY_SCALE)
    }
    
    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(model: OrderModel){
        self.model = model
        self.titleLbl.text = model.product?.name
        self.categoryLbl.text = String(format: "%@ - %@", model.product?.categoryName ?? "", model.order_type_name)
        self.branchNameLbl.text = model.branch?.name
        self.quantityLbl.text = String(format: "%.1f %@", model.quantity, model.product_packing_unit)
        self.packingLbl.text = String(format: "%d %@", model.product_packing_value, model.product_packing_unit)
        self.skuLbl.text = String(model.product?.sku ?? 0)
        self.saleOrderSumLbl.text = String(format: "%.1f %@", model.sale_order_supplier_sum, model.product_packing_unit)
        self.saleOrderConfirmLbl.text = String(format: "%.1f %@", model.sale_order_supplier_confirm, model.product_packing_unit)
        if model.order_type_id == OrderType.Centralize.rawValue {
            self.saleOrderSpmLbl.text = String(format: "%.1f %@", model.sale_order_warehouse_confirm, model.product_packing_unit)
            self.view2.isHidden = false
            self.view2WidthConstraint.constant = self.shadowView.frame.width/3
        }
        else {
            self.saleOrderSpmLbl.text = String(format: "%.1f %@", model.sale_order_supplier_confirm, model.product_packing_unit)
            self.view2.isHidden = true
            self.view2WidthConstraint.constant = 0
        }

        self.layoutIfNeeded()
    }

}

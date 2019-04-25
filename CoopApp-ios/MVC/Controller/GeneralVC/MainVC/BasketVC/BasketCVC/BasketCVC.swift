//
//  BasketCVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/7/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class BasketCVC: UICollectionViewCell {

    @IBOutlet weak var qrcodeIV: UIImageView!
    @IBOutlet weak var idLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViewCell(model: BasketModel) {
        self.idLbl.text = String(format: "ID : %d", model.id)
        self.qrcodeIV.image = model.barcodeImg
    }
}

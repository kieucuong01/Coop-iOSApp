//
//  BasketCVC.swift
//  CoopApp-ios
//
//  Created by KTC on 3/7/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit

class ContainerCVC: UICollectionViewCell {

    @IBOutlet weak var qrcodeIV: UIImageView!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViewCell(model: ContainerModel) {
        self.idLbl.text = String(format: "ID : %d", model.id)
        self.nameLbl.text = String(format: "Tên : %@", model.name)
        self.qrcodeIV.image = model.barcodeImg
    }
}

//
//  ConfirmSignUpView.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol ConfirmImageDelegate: class {
    func clickedButtonCamera(sender: ConfirmImage)
    func clickedButtonSend(sender: ConfirmImage)
}

class ConfirmImage: UIView {
    //UIView
    @IBOutlet weak var titleLbl: UILabel!
    
    var data : Dictionary<String,Any>?
    @IBOutlet weak var contentTf: UITextView!
    @IBOutlet weak var heightImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var quantityTf: UITextField!
    @IBOutlet weak var unitLbl: UILabel!
    
    weak var delegate:ConfirmImageDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentTf.layer.borderWidth = 1
        self.contentTf.layer.borderColor = UIColor.lightGray.cgColor
        self.quantityTf.keyboardType = .numberPad
        self.hideKeyboard()
    }
    
    func updateImage(image : UIImage){
        self.heightImageConstraint.constant = 150
        self.image.image = image
    }
    
    @IBAction func clickedButtonOK(_ sender: Any) {
        self.endEditing(true)
        self.isHidden = true
        self.delegate?.clickedButtonSend(sender: self)
    }
    @IBAction func clickedButtonCamera(_ sender: UIButton) {
        self.endEditing(true)
        self.delegate?.clickedButtonCamera(sender: self)
    }
    @IBAction func clickedButtonCancel(_ sender: Any) {
        self.endEditing(true)
        self.isHidden = true
    }
    
}

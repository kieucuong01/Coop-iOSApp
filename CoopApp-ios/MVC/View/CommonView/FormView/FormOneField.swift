//
//  ConfirmSignUpView.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

protocol FormOneFieldDelegate: class {
    func clickedButtonCancel(sender: FormOneField)
    func clickedButtonOK(sender: FormOneField)
}

class FormOneField: UIView {
    //UIView
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var formTf: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var data : Dictionary<String,Any>?
    
    weak var delegate:FormOneFieldDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setFontForView()
        self.hideKeyboard()
    }
    
    private func setFontForView() {
//        self.mLabelTitleView.font = UIFont.boldSystemFont(ofSize: 12 * scale)
//        self.mLabelCode.font = UIFont.systemFont(ofSize: 10 * scale)
    }
    
    func initView(title: String, rightBtnTitle: String, leftBtnTitle: String,  formTfPlaceholder: String) {
        self.titleLbl.text = title
        self.okBtn.setTitle(rightBtnTitle, for: .normal)
        self.cancelBtn.setTitle(leftBtnTitle, for: .normal)
        self.formTf.placeholder = formTfPlaceholder
    }
    
    @IBAction func clickedButtonCancel(_ sender: Any) {
        self.isHidden = true
        self.endEditing(true)
        self.delegate?.clickedButtonCancel(sender: self)
    }
    
    @IBAction func clickedButtonOK(_ sender: Any) {
        self.isHidden = true
        self.endEditing(true)
        self.delegate?.clickedButtonOK(sender: self)
    }
}

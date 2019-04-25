//
//  UIAppTextField.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/21/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class UIAppTextFieldView: UIView {
    @IBOutlet weak var widthButton: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBInspectable
    var localizePlaceHolderText : String = ""{
        didSet {
            self.textField.placeholder = NSLocalizedString(localizePlaceHolderText, comment: "")
        }
    }
    var isHasButton : Bool = false
    var view: UIView? = nil
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        self.xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        self.xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        self.view?.frame = bounds
        self.view?.layer.cornerRadius = 8.0 * DISPLAY_SCALE
        self.view?.clipsToBounds = true
        self.textField.delegate = self

        // Setup style for textfield
        self.textField.text = ""
        self.layer.cornerRadius = 8.0 * DISPLAY_SCALE
        self.layer.backgroundColor = WHITE_COLOR.cgColor
        self.layer.borderWidth = 1.5 * DISPLAY_SCALE
        self.layer.borderColor = BORDER_COLOR.cgColor
        self.textField.textColor = GRAY1_COLOR
        self.textField.layer.cornerRadius = 8.0 * DISPLAY_SCALE
        self.textField.backgroundColor = WHITE_COLOR
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.red,
                          NSAttributedStringKey.font : UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 14*DISPLAY_SCALE)!]
        self.textField.attributedPlaceholder = NSAttributedString(string: self.textField.placeholder!,
                                                                  attributes:attributes)
        self.textField.textColor = GRAY1_COLOR
        self.textField.font = UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 14*DISPLAY_SCALE)

        // Create a padding view for padding on left
        self.textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10 * DISPLAY_SCALE, height: textField.frame.height))
        self.textField.leftViewMode = .always

        // Create a padding view for padding on right
        self.textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10 * DISPLAY_SCALE, height: textField.frame.height))
        self.textField.rightViewMode = .always

        // Update button
        //self.updateButtonStatus()
        self.button.isHidden = !self.isHasButton
        self.widthButton.constant = 0

        // Make the view stretch with containing view
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)

        
        addSubview(self.view!)
    }
    func updateButtonStatus(){
        self.button.isHidden = !self.isHasButton
        if self.isHasButton == false {
            self.widthButton.constant = 0
        }
        else {
            self.widthButton.constant = 52 * DISPLAY_SCALE
        }
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"UIAppTextFieldView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }
}

extension UIAppTextFieldView : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.removeHighlightTextField()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.highlightSelectedTextField()
    }

    // Ultil method for View
    func highlightSelectedTextField(){
        self.layer.borderColor = PRIMARY_COLOR.cgColor
        self.applySketchShadow1(color: PRIMARY_COLOR, alpha: 1, x: 0, y: 0, blur: 4.0, spread: 2.0)
    }

    func removeHighlightTextField(){
        self.layer.borderColor = BORDER_COLOR.cgColor
        self.applySketchShadow1(color: BORDER_COLOR, alpha: 1, x: 0, y: 0, blur: 0, spread: 0)
    }
    
    func applySketchShadow1(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur/2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 8.0 * DISPLAY_SCALE).cgPath
        }
    }
}

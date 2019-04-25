//
//  ExtensionUIView.swift
//  SmartLife-App
//
//  Created by Ghost on 10/15/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Foundation

// Extension UIView
extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    /*
     * Created by: cuongkt
     * Description: Disable multi touch for view and it's subViews
     */
    func enableExclusiveTouchForViewAndSubView() {
        // Enable for self
        self.isExclusiveTouch = true

        // Enable for subviews
        for subview in self.subviews {
            subview.enableExclusiveTouchForViewAndSubView()
        }
    }


    /*
     * Created by: cuongkt
     * Description: Create bottom shadow around view
     */
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 0.0

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    /*
     * Created by: cuongkt
     * Description: Create simple shadow around view
     */
    func applySketchShadow(
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
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    /*
     * Created by: cuongkt
     * Description: load view from nib
     */
    func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    /*
     * Created by: cuongkt
     * Description: load view from nib
     */
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        self.endEditing(true)
    }
}

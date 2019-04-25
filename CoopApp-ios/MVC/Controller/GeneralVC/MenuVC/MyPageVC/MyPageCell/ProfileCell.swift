//
//  ProfileCell.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/28/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentTf: UITextField!
    
    var model : [String:String] = [:]
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        // Call super
        super.awakeFromNib()

        // Configure self
        self.configureSelf()

        // Disable multi touch
        self.enableExclusiveTouchForViewAndSubView()
    }

    // MARK: - Configure View

    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func configureSelf() {
        // Configure self
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.shadowView.applySketchShadow(color: GRAY1_COLOR, alpha: 0.5, x: 0.0, y: 0.0, blur: 1, spread: 0)
    }

    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(model: [String:String]){
        self.model = model
        for (key, value) in model {
            self.titleLbl.text = key
            self.contentLbl.text = value
            self.contentTf.text = value
            if value == "" {
                 self.contentLbl.text = ""
                self.contentTf.text = ""
            }
        }
    }


    
}

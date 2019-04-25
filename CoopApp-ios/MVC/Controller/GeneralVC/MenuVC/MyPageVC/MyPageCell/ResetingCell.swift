//
//  ResetingCell.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/28/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class ResetingCell: UITableViewCell {

    @IBOutlet weak var resettingBtn: UIAppButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
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
        self.resettingBtn.titleLabel?.font =  UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 13 * DISPLAY_SCALE)

        self.titleLbl.text = NSLocalizedString("signin_tf_password", comment: "")
        self.contentLbl.text = "\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}"
    }
}

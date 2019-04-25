//
//  NewsTVC.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 10/20/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NewsTVC: UITableViewCell {
    // Subviews
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // Variables
    //var parentVC: ChatListTopViewController? = nil
    //var parentTableView: UITableView? = nil
    //var cellIndex: IndexPath? = nil
    var newModel: NewModel? = nil

    // MARK: - View Lifecycle

    override func awakeFromNib() {
        // Call super
        super.awakeFromNib()

        // Configure self
        self.configureSelf()
//
//        // Disable multi touch
//        self.enableExclusiveTouchForViewAndSubView()
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
        self.shadowView.layer.cornerRadius = 12 * DISPLAY_SCALE
        self.shadowView.applySketchShadow(color: GRAY2_COLOR, alpha: 0.4, x: 0.0, y: 2.0, blur: 8, spread: 0)
        
        self.titleLabel.font = self.titleLabel.font.withSize(14.0 * DISPLAY_SCALE)
        self.newLabel.font = self.newLabel.font.withSize(14.0 * DISPLAY_SCALE)
        self.dateLabel.font = self.dateLabel.font.withSize(12.0 * DISPLAY_SCALE)
    }

    /*
     * Created by: cuongkt
     * Description: Configure self
     */
    func updateViewCell(newModel: NewModel){
        self.newModel = newModel
        self.titleLabel.text = newModel.title
        self.dateLabel.text = newModel.date
        self.setState(isRead: newModel.isRead ?? false)
        self.layoutIfNeeded()
    }
    
    /*
     * Created by: cuongkt
     * Description: Set state
     */
    func setState(isRead: Bool) {
        // Update newLabel
        self.newLabel.isHidden = isRead
        
        // Check isNew
        if (isRead == true) {
            self.titleLabel.font = UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 14.0 * DISPLAY_SCALE)
        }
        else {
            self.titleLabel.font = UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 14.0 * DISPLAY_SCALE)
        }
    }
}

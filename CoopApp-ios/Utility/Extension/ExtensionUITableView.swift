//
//  ExtensionUITableView.swift
//  SmartLife-App
//
//  Created by Cuong Kieu on 10/5/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit
import Foundation

extension UITableView {
    /*
     * Created by: cuongkt
     * Description: Check and reload cell wirh given indexPath
     */
    func checkAndReloadCell(with indexPathNeedReload: IndexPath?) {
        // Check nil
        if indexPathNeedReload != nil {
            // Check section
            if self.numberOfSections > indexPathNeedReload!.section {
                // Check row
                if self.numberOfRows(inSection: indexPathNeedReload!.section) > indexPathNeedReload!.row {
                    DispatchQueue.main.async {
                        // Reload cell
                        self.reloadRows(at: [indexPathNeedReload!], with: UITableViewRowAnimation.none)
                        self.layoutIfNeeded()
                    }
                }
            }
        }
    }
}

extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

//
//  ExpandableCells.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 7..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

class ExpandableCell2: ExpandableCell {
    static let ID = "ExpandableCell"
    @IBOutlet weak var titleLabel: UILabel!
}

class ExpandedCell: UITableViewCell {
    static let ID = "ExpandedCell"
    
    @IBOutlet var titleLabel: UILabel!
}

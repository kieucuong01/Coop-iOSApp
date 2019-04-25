//
//  HistoryRecordVC.swift
//  ExpandableCellDemo
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

class HistoryRecordVC: UIViewController {
    @IBOutlet var tableView: ExpandableTableView!    
//    var cell: UITableViewCell {
//        return tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID)!
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.expandableDelegate = self
        tableView.animation = .automatic
        tableView.register(UINib(nibName: "ExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandedCell.ID)
        tableView.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell2.ID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func openAllButtonClicked() {
        tableView.openAll()
    }
    
    @IBAction func expandMultiButtonClicked(_ sender: Any) {
        tableView.expansionStyle = .multi
    }
    
    @IBAction func expandSingleButtonClicked(_ sender: Any) {
        tableView.expansionStyle = .single
        tableView.closeAll()
    }
    
    @objc func closeAllButtonClicked() {
        tableView.closeAll()
    }
    
    //scroll view methods are being forwarded correctly
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidScroll, decelerate:\(decelerate)")
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
}

extension HistoryRecordVC: ExpandableDelegate {
    
  
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        cell1.titleLabel.text = "Morning food"
        let cell2 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        cell2.titleLabel.text = "Buy books"
        let cell3 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        cell3.titleLabel.text = "Buy Laptop"
        return [cell1, cell2, cell3]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [UITableViewAutomaticDimension]
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .white
        cell?.backgroundColor = .white

//        print("didSelectRow:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
//        print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            cell.titleLabel.text = "XXXXX"
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableCell2.ID) as? ExpandableCell2 {
            cell.titleLabel.text = String(format: "%d/11/2018", indexPath.row+1)
            
            return cell
        } else { return UITableViewCell() }        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc(expandableTableView:didCloseRowAt:) func expandableTableView(_ expandableTableView: UITableView, didCloseRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        cell?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
//
//    func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = expandableTableView.cellForRow(at: indexPath)
//        cell?.contentView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//        cell?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//    }
    
//
//    func expandableTableView(_ expandableTableView: ExpandableTableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
//
//    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 33
//    }
}

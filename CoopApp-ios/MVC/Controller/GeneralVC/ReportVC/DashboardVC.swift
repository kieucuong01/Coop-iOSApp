//
//  DashboardVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/25/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class DashboardVC: BaseViewController {
    //MARK: - Variable
    @IBOutlet weak var tableView: UITableView!
//    var generalReportModel : GeneralReportModel = GeneralReportModel()
    var heightBuildingView : CGFloat = 20 * DISPLAY_SCALE
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardNErrorTapAround()
        self.initTableView()
//        self.getData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    //MARK: - Private method
    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "MonthyReportTVC", bundle: nil), forCellReuseIdentifier: "MonthyReportTVC")

        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = false
    }

    private func getData(){
//        if let generalReportModel : GeneralReportModel = self.data[GeneralReportModel.keyModel] as? GeneralReportModel {
//            self.generalReportModel = generalReportModel
//        }

        self.tableView.reloadData()
    }
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate

    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


    // MARK: - UITableViewDataSource

    /*
     * Created by: cuongkt
     * Description: Number of section
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
     * Created by: cuongkt
     * Description: Number of row in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return UIView()
    }

    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell: MonthyReportTVC = tableView.dequeueReusableCell(withIdentifier: "MonthyReportTVC") as? MonthyReportTVC {
                cell.parentVC = self
                // Return cell
                return cell
            }
        // Default
        return UITableViewCell()
    }
}

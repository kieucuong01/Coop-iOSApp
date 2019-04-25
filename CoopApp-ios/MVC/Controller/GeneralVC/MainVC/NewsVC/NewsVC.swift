//
//  NewsVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/25/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import ICSPullToRefresh

class NewsVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var totalUnread: Int = 0
    var listOfNew: [NewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TIN TỨC", comment: "")

        let oderTest = NewModel(title: "Cố vấn Nhà Trắng nói Hội nghị Mỹ - Triều tại Việt Nam là một thành công",
                                content: "\"Tôi không coi hội nghị Mỹ - Triều vừa qua tại Việt Nam là một thất bại mà là một thành công, xét trên phương diện Tổng thống đã bảo vệ và thúc đẩy các lợi ích quốc gia Mỹ\", NHK ngày 3/3 dẫn tuyên bố của Cố vấn An ninh Quốc gia Mỹ John Bolton. \n Trả lời phỏng vấn trên truyền hình, Bolton cho biết Tổng thống Mỹ Donald Trump đã chuẩn bị đầy đủ cho các cuộc đàm phán tiếp theo ở cấp thấp hơn và sẵn sàng tiến hành cuộc gặp thượng đỉnh lần ba với Chủ tịch Triều Tiên Kim Jong-un vào thời điểm phù hợp. \n Hội nghị thượng đỉnh Mỹ - Triều lần hai tại Hà Nội hôm 28/2 kết thúc mà không đưa ra được thỏa thuận chung nào. \n Tại các buổi họp báo sau đó, hai bên đã có những tuyên bố mâu thuẫn liên quan đến các khúc mắc tại hội nghị. Trong khi ông Trump cho biết Triều Tiên yêu cầu dỡ bỏ hoàn toàn cấm vận, Ngoại trưởng Triều Tiên lại cho hay Bình Nhưỡng muốn dỡ bỏ 5 trong 11 lệnh trừng phạt, nhưng Washington không chấp nhận. \n Dù không đạt được thống nhất, phái đoàn hai nước vẫn ra về trong thân thiện, Tổng thống Trump nói rằng \"không ai giận dữ\". Thư ký báo chí Nhà Trắng Sarah Sanders còn đăng lên Twitter ảnh ông Kim Jong-un tươi cười khi bắt tay tạm biệt ông Trump. \n Tại các buổi họp báo sau đó, hai bên đã có những tuyên bố mâu thuẫn liên quan đến các khúc mắc tại hội nghị. Trong khi ông Trump cho biết Triều Tiên yêu cầu dỡ bỏ hoàn toàn cấm vận, Ngoại trưởng Triều Tiên lại cho hay Bình Nhưỡng muốn dỡ bỏ 5 trong 11 lệnh trừng phạt, nhưng Washington không chấp nhận. \n Dù không đạt được thống nhất, phái đoàn hai nước vẫn ra về trong thân thiện, Tổng thống Trump nói rằng \"không ai giận dữ\". Thư ký báo chí Nhà Trắng Sarah Sanders còn đăng lên Twitter ảnh ông Kim Jong-un tươi cười khi bắt tay tạm biệt ông Trump.",
                                date: "12/02/2019")
        
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)
        listOfNew.append(oderTest)

        
        self.initTableView()
        self.callAPIGetListNews(isReload: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func initTableView() {
        // Register cells
        self.tableView.register(UINib(nibName: "NewsTVC", bundle: nil), forCellReuseIdentifier: "NewsTVC")

        // Set attributes
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Pull refresh
        self.tableView.addPullToRefreshHandler {
            DispatchQueue.main.async {
                self.callAPIGetListNews(isReload: true)
            }
        }
        
        // Infinite scroll
        self.tableView.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                self.callAPIGetListNews(isReload: false)
            }
        }
    }
    
    private func callAPIGetListNews(isReload: Bool) {
        // Reset list of new
        if (isReload == true) { self.listOfNew.removeAll() }
        // automatic stop animate after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.tableView.pullToRefreshView?.stopAnimating()
            self.tableView.infiniteScrollingView?.stopAnimating()
        })
        // Call API
//        APIManager.shareObject.callAPIGetOrders(isShowHUD: true, params: nil, completionHandler: { (result, error) in
//            self.tableView.pullToRefreshView?.stopAnimating()
//            self.tableView.infiniteScrollingView?.stopAnimating()
//
//            if error == nil && result != nil{
//                // Success
//            }
//            else {
//                // Fail
//            }
//        })
     
    }
    
    private func countAndUpdateNewsBadgeNumber() {
//        let badgeNumberString: String? = (self.totalUnread <= 0) ? nil : String(self.totalUnread)
//        FirebaseGlobalMethod.tabbarMainVC?.customeTabbar.updateBadgeNumberForNewTab(badgeNumber: badgeNumberString)
        self.tableView.reloadData()
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate

    /*
     * Created by: cuongkt
     * Description: Height for row
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        return self.listOfNew.count
    }

    /*
     * Created by: cuongkt
     * Description: Configure tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: NewsTVC = tableView.dequeueReusableCell(withIdentifier: "NewsTVC") as? NewsTVC {
            // Update index
            if listOfNew.indices.contains(indexPath.row){
                let newModelCell : NewModel = listOfNew[indexPath.row]
                cell.updateViewCell(newModel: newModelCell)
            }

            // Return cell
            return cell
        }

        // Default
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell : NewsTVC = tableView.cellForRow(at: indexPath) as? NewsTVC {
            self.pushToViewController(storyboardName: "News",
                                         identifier: "newDetailVC",
                                         animated: true,
                                         withParameter: ["new_model": cell.newModel ?? ""])
        }
    }
}

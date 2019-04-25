//
//  FAQVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/29/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit
import WebKit

class MyPageWebViewVC: BaseViewController {
    enum MyPageWebViewType {
        case FAQ
        case Term
        case Policy
        case Support
        case Contact
    }
    @IBOutlet weak var navbarTitleLbl: UILabel!
    @IBOutlet weak var webViewContainer: UIView!
    var webView: WKWebView!

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: CGRect(x: 0, y: 40 * DISPLAY_SCALE + AppUtil.getTopPadding(), width: SIZE_WIDTH, height: SIZE_HEIGHT - 40 * DISPLAY_SCALE - AppUtil.getTopPadding()), configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let typeWebView : MyPageWebViewType = self.data["typeWebView"] as? MyPageWebViewVC.MyPageWebViewType{
            if typeWebView == MyPageWebViewType.Support {
                self.navbarTitleLbl.text = NSLocalizedString("Hỗ Trợ", comment: "")
                self.initWebView(urlString: SUPPORT_URL_STRING)
            }
            else if typeWebView == MyPageWebViewType.Policy {
                self.navbarTitleLbl.text = NSLocalizedString("Chính sách", comment: "")
                self.initWebView(urlString: POLICY_URL_STRING)
            }
            else {
                self.navbarTitleLbl.text = NSLocalizedString("Liên hệ", comment: "")
                self.initWebView(urlString: CONTACT_URL_STRING)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func initWebView(urlString : String){
        self.webView.load(URLRequest(url: URL(string: urlString)!))
    }

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Delegate
extension MyPageWebViewVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Util.hideAllMBProgressHUD()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Util.hideAllMBProgressHUD()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Util.showMBProgressHUD()
    }
}

//
//  BaseVCTutorialScreen.swift
//  SmartTablet
//
//  Created by thanhlt on 6/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class BaseVCTutorialScreen: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var subTitle3: UIAppLabel!
    @IBOutlet weak var subTitle2: UIAppLabel!
    @IBOutlet weak var subTitle1: UIAppLabel!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var btnStart: UIAppButton!
    @IBOutlet weak var scrollViewTutorial: UIScrollView!
    @IBOutlet weak var btnSkip: UIButton!
    private var _viewSelectedPage1:UIView? = nil
    private var _viewSelectedPage2:UIView? = nil
    private var _viewSelectedPage3:UIView? = nil

    private var _lastContentOffset:CGFloat = 0
    private var isStopScroll:Bool = false
    
    private var arrayImagesTutorial:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.createSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Getter
    var viewSelectedPage1:UIView {
        if _viewSelectedPage1 == nil {
            let size = IS_IPAD ? 20.0 * DISPLAY_SCALE : 10.0 * DISPLAY_SCALE
            var y = 630.0 * DISPLAY_SCALE
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 650.0 * DISPLAY_SCALE
            }
            let x = 171.5 * DISPLAY_SCALE
            _viewSelectedPage1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage1?.center = CGPoint(x: x, y: y)
            _viewSelectedPage1?.backgroundColor = UIColor(red: 204, green: 204, blue: 204)
            _viewSelectedPage1?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage1!
    }
    
    var viewSelectedPage2:UIView {
        if _viewSelectedPage2 == nil {
            let size = IS_IPAD ? 16.0 * DISPLAY_SCALE : 8.0 * DISPLAY_SCALE
            var y = 630.0 * DISPLAY_SCALE
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 650.0 * DISPLAY_SCALE
            }
            let x = 187.5 * DISPLAY_SCALE
            _viewSelectedPage2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage2?.center = CGPoint(x: x, y: y)
            _viewSelectedPage2?.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
            _viewSelectedPage2?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage2!
    }
    
    var viewSelectedPage3:UIView {
        if _viewSelectedPage3 == nil {
            let size = IS_IPAD ? 16.0 * DISPLAY_SCALE : 8.0 * DISPLAY_SCALE
            let x = 203.5 * DISPLAY_SCALE
            var y = 630.0 * DISPLAY_SCALE
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
                y = 650.0 * DISPLAY_SCALE
            }
            _viewSelectedPage3 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
            _viewSelectedPage3?.center = CGPoint(x: x, y: y)
            _viewSelectedPage3?.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
            _viewSelectedPage3?.layer.cornerRadius = size / 2.0
        }
        return _viewSelectedPage3!
    }
    
    
    //MARK: - Private method
    private func configureView(){
        self.configSubtitle(label: self.subTitle1)
        self.configSubtitle(label: self.subTitle2)
        self.configSubtitle(label: self.subTitle3)
    }
    
    private func configSubtitle(label: UILabel){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7.5 * DISPLAY_SCALE
        let attributeStr = NSMutableAttributedString(string: label.text!)
        attributeStr.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributeStr.length))
        attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: GRAY2_COLOR, range: NSRange(location: 0, length: attributeStr.length))
        attributeStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: PRIMARY_FONT_NAME_REGULAR, size: 16 * DISPLAY_SCALE)!, range: NSRange(location: 0, length: attributeStr.length))
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        attributeStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attributeStr.length))

        label.attributedText = attributeStr;
    }
    
    private func createSubViews() {
        self.view.addSubview(self.viewSelectedPage1)
        self.view.addSubview(self.viewSelectedPage2)
        self.view.addSubview(self.viewSelectedPage3)
    }

    //MARK: - Selector
    @IBAction func btnSkipAction(_ sender: Any) {
        self.pushToViewController(storyboardName: "SignIn", identifier: "signInVC", animated: true)
    }

    @IBAction func btnStartAction(_ sender: Any) {
        self.pushToViewController(storyboardName: "SignIn", identifier: "signInVC", animated: true)
    }
    
    //MARK: - ScrollView Delegate
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
            self.checkScrollWhenRightDirection()

    }

    private func checkScrollWhenRightDirection() {
        let sizeSelected = IS_IPAD ? 20.0 * DISPLAY_SCALE : 10.0 * DISPLAY_SCALE
        let sizeNormal = IS_IPAD ? 16.0 * DISPLAY_SCALE : 8.0 * DISPLAY_SCALE
        self.viewSelectedPage3.frame.size = CGSize(width: sizeNormal, height: sizeNormal)
        self.viewSelectedPage2.frame.size = CGSize(width: sizeNormal, height: sizeNormal)
        self.viewSelectedPage1.frame.size = CGSize(width: sizeNormal, height: sizeNormal)

        self.viewSelectedPage3.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        self.viewSelectedPage2.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        self.viewSelectedPage1.backgroundColor = UIColor(red: 238, green: 238, blue: 238)

        let centerXContenOffset: CGFloat = scrollViewTutorial.contentOffset.x + (scrollViewTutorial.frame.size.width / 2.0)
        let currentPage: Int = Int(centerXContenOffset / scrollViewTutorial.frame.size.width)
        if currentPage == 2 {
            self.viewSelectedPage3.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage3.backgroundColor = UIColor(red: 204, green: 204, blue: 204)
            self.btnStart.isHidden = false
            self.btnSkip.isHidden = true

        } else if currentPage == 1 {
            self.viewSelectedPage2.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage2.backgroundColor = UIColor(red: 204, green: 204, blue: 204)
            self.btnStart.isHidden = true
            self.btnSkip.isHidden = false

        } else {
            self.viewSelectedPage1.frame.size = CGSize(width: sizeSelected, height: sizeSelected)
            self.viewSelectedPage1.backgroundColor = UIColor(red: 204, green: 204, blue: 204)
            self.btnStart.isHidden = true
            self.btnSkip.isHidden = false
        }

        self.updateViewSelectedPage()
    }

    private func updateViewSelectedPage() {
        self.viewSelectedPage3.layer.cornerRadius = self.viewSelectedPage3.frame.size.width / 2.0
        self.viewSelectedPage2.layer.cornerRadius = self.viewSelectedPage2.frame.size.width / 2.0
        self.viewSelectedPage1.layer.cornerRadius = self.viewSelectedPage1.frame.size.width / 2.0

        var y = 630.0 * DISPLAY_SCALE
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436.0 {
            y = 650.0 * DISPLAY_SCALE
        }
        let x1 = 171.5 * DISPLAY_SCALE
        let x2 = 187.5 * DISPLAY_SCALE
        let x3 = 203.5 * DISPLAY_SCALE
        self.viewSelectedPage1.center = CGPoint(x: x1, y: y)
        self.viewSelectedPage2.center = CGPoint(x: x2, y: y)
        self.viewSelectedPage3.center = CGPoint(x: x3, y: y)
    }
}

//
//  BaseViewcontrollers.swift
//  SmartTablet
//
//  Created by thanhlt on 6/30/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var data : Dictionary<String, Any> = [:]

    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK:- Public method
    // Top error view
    private var errorAppView : UIView {
        let errorView = UIView(frame: CGRect(x: 0, y: -95 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 95 * DISPLAY_SCALE))
        errorView.backgroundColor = PRIMARY_COLOR
        errorView.clipsToBounds = true
        errorView.tag = 100
        
        let containerView: UIView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.clear

        let labelMessage : UILabel = UILabel()
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        labelMessage.clipsToBounds = true
        labelMessage.tag = 101
        labelMessage.textColor = .white
        labelMessage.font = UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 14*DISPLAY_SCALE)
        labelMessage.numberOfLines = 2
        labelMessage.textAlignment = .center

        let imageLeft : UIImageView = UIImageView()
        imageLeft.translatesAutoresizingMaskIntoConstraints = false
        imageLeft.clipsToBounds = true
        imageLeft.contentMode = .scaleAspectFit
        imageLeft.image = UIImage(named: "ic_menu")

        errorView.addSubview(containerView)
        containerView.addSubview(labelMessage)
        containerView.addSubview(imageLeft)
        
        // ContainerView constraints
        containerView.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: errorView.heightAnchor).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualTo: errorView.widthAnchor, multiplier: 0.9).isActive = true
        
        // ImageLeft constraints
        imageLeft.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageLeft.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageLeft.widthAnchor.constraint(equalToConstant: 24.0 * DISPLAY_SCALE).isActive = true
        imageLeft.heightAnchor.constraint(equalToConstant: 24.0 * DISPLAY_SCALE).isActive = true
        
        // LabelMessage constraints
        labelMessage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        labelMessage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        labelMessage.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        labelMessage.leadingAnchor.constraint(equalTo: imageLeft.trailingAnchor, constant: 7.0 * DISPLAY_SCALE).isActive = true

        return errorView
    }
    
    private var errorTintAppView : UIView {
        let errorView = UIView(frame: CGRect(x: 0, y: -95 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 95 * DISPLAY_SCALE))
        errorView.backgroundColor = GRAY1_COLOR
        errorView.clipsToBounds = true
        errorView.tag = 200
        
        let containerView: UIView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.clear
        
        let labelMessage : UILabel = UILabel()
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        labelMessage.tag = 201
        labelMessage.textColor = PRIMARY_COLOR
        labelMessage.font = UIFont(name: PRIMARY_FONT_NAME_MEDIUM, size: 14*DISPLAY_SCALE)
        labelMessage.numberOfLines = 2
        labelMessage.textAlignment = .center
        
        let imageLeft : UIImageView = UIImageView()
        imageLeft.translatesAutoresizingMaskIntoConstraints = false
        imageLeft.clipsToBounds = true
        imageLeft.contentMode = .scaleAspectFit
        imageLeft.image = #imageLiteral(resourceName: "attentionBlue")
        
        errorView.addSubview(containerView)
        containerView.addSubview(labelMessage)
        containerView.addSubview(imageLeft)
        
        // ContainerView constraints
        containerView.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: errorView.heightAnchor).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualTo: errorView.widthAnchor, multiplier: 0.9).isActive = true
        
        // ImageLeft constraints
        imageLeft.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageLeft.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageLeft.widthAnchor.constraint(equalToConstant: 24.0 * DISPLAY_SCALE).isActive = true
        imageLeft.heightAnchor.constraint(equalToConstant: 24.0 * DISPLAY_SCALE).isActive = true
        
        // LabelMessage constraints
        labelMessage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        labelMessage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        labelMessage.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        labelMessage.leadingAnchor.constraint(equalTo: imageLeft.trailingAnchor, constant: 7.0 * DISPLAY_SCALE).isActive = true
        
        return errorView
    }

    func showTopError(message: String) {
        if let errorView = self.view.viewWithTag(100) {
            if let labelText : UILabel = errorView.viewWithTag(101) as? UILabel{
                labelText.text = message
                UIView.animate(withDuration: 0.5, animations: {
                    errorView.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 95 * DISPLAY_SCALE)
                })
            }
        }
        else {
            self.view.addSubview(self.errorAppView)
            self.showTopError(message: message)
        }
    }

    func hideTopError(){
        if let errorView = self.view.viewWithTag(100) {
            UIView.animate(withDuration: 0.5, animations: {
                errorView.frame = CGRect(x: 0, y: -95 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 95 * DISPLAY_SCALE)
            })
        }
    }
    
    func showTintTopError(message: String) {
        if let errorView = self.view.viewWithTag(200) {
            if let labelText : UILabel = errorView.viewWithTag(201) as? UILabel{
                labelText.text = message
                UIView.animate(withDuration: 0.5, animations: {
                    errorView.frame = CGRect(x: 0, y: 0, width: SIZE_WIDTH, height: 95 * DISPLAY_SCALE)
                })
            }
        }
        else {
            self.view.addSubview(self.errorTintAppView)
            self.showTintTopError(message: message)
        }
    }
    
    func hideTintTopError(){
        if let errorView = self.view.viewWithTag(200) {
            UIView.animate(withDuration: 0.5, animations: {
                errorView.frame = CGRect(x: 0, y: -95 * DISPLAY_SCALE, width: SIZE_WIDTH, height: 95 * DISPLAY_SCALE)
            })
        }
    }




    
    func errorAPIAppear(message: String?) {
        let alertController = UIAlertController(title: NSLocalizedString("alert_warning_title", comment: ""), message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: NSLocalizedString("button_cancel_title", comment: ""), style: .cancel, handler:nil)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAPIError(result: NSDictionary?) {
        if let error: NSDictionary = (result?.value(forKey: "error") as? NSArray)?[0] as? NSDictionary {
            if let errorMessage: String = error.object(forKey: "message") as? String {
                // Init alert
                let alertController: UIAlertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("button_ok_title", comment: ""), style: UIAlertActionStyle.default, handler: { (alert) in
                }))

                // Make title smaller
                alertController.setValue(NSAttributedString(string: ""), forKey: "attributedTitle")

                // Show alert
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func pushToViewController(storyboardName: String, identifier: String, animated: Bool, withParameter: Dictionary<String, Any> = [:]){
        let storyboardLogin: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        if withParameter.isEmpty {
            let vc : UIViewController = storyboardLogin.instantiateViewController(withIdentifier: identifier)
            self.navigationController?.pushViewController(vc, animated: animated)
        }
        else {
            if let vc : BaseViewController = storyboardLogin.instantiateViewController(withIdentifier: identifier) as? BaseViewController {
                vc.data = withParameter
                self.navigationController?.pushViewController(vc, animated: animated)
            }
        }
    }

    func presentToViewController(storyboardName: String, identifier: String, animated: Bool, withParameter: Dictionary<String, Any> = [:]){
        let storyboardLogin: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        if withParameter.isEmpty {
            let vc : UIViewController = storyboardLogin.instantiateViewController(withIdentifier: identifier)
            self.present(vc, animated: animated, completion: nil)
        }
        else {
            if let vc : BaseViewController = storyboardLogin.instantiateViewController(withIdentifier: identifier) as? BaseViewController {
                vc.data = withParameter
                self.present(vc, animated: animated, completion: nil)
            }
        }
    }

    func popViewController(animated: Bool){
        self.navigationController?.popViewController(animated: animated)
    }

    func getViewController(storyboardName: String, identifier: String) -> UIViewController? {
        let storyboardLogin: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc : UIViewController = storyboardLogin.instantiateViewController(withIdentifier: identifier)
            return vc
    }
    
    
    @IBAction func showLeftMenu(_ sender: UIBarButtonItem) {
        let manager = drawer()?.getManager(direction: .left)
        let value = !manager!.isShow
        drawer()?.showLeftSlider(isShow: value)
    }
    
    @IBAction func showRightMenu(_ sender: UIBarButtonItem) {
        let manager = drawer()?.getManager(direction: .right)
        let value = !manager!.isShow
        drawer()?.showRightSlider(isShow: value)
    }
}

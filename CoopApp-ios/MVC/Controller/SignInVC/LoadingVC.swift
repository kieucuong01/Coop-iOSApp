//
//  LoadingVC.swift
//  ParkingManagementApp-ios
//
//  Created by Cuong Kieu on 6/25/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class LoadingVC: BaseViewController {
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.presentToViewController(storyboardName: "General", identifier: "NavGeneralVC", animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Method
    private func configureView(){
        self.loadingImageView.image = UIImage.gifImageWithName(name: "Loading_3x")
    }
}

//
//  ViewController.swift
//  MMDrawController
//
//  Created by millmanyang@gmail.com on 03/30/2017.
//  Copyright (c) 2017 millmanyang@gmail.com. All rights reserved.
//

import UIKit
import MMDrawController

class DrawerViewController: MMDrawerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Init by Code
        let story = UIStoryboard.init(name: "General", bundle: nil)
        let main = story.instantiateViewController(withIdentifier: "generalVC")
        let right = story.instantiateViewController(withIdentifier: "Slider")
        let left = story.instantiateViewController(withIdentifier: "Slider")
        
        self.title = "SG COOP"
        
        self.set(right: right, mode: .frontWidthRate(r: 0.6))
        self.set(left: left, mode: .frontWidthRate(r: 0.6))
        self.set(main: main)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


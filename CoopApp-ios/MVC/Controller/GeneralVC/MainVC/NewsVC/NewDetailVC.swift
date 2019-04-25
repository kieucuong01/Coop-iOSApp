//
//  NewDetailVC.swift
//  OwnersClub-ios
//
//  Created by Cuong Kieu on 6/28/18.
//  Copyright © 2018 Oceanize. All rights reserved.
//

import UIKit

class NewDetailVC: BaseViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardNErrorTapAround()
        
        if let newModel : NewModel = self.data["new_model"] as? NewModel {
            self.updateView(newModel: newModel)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView(newModel: NewModel){
        self.titleLbl.text = newModel.title
        self.dateLbl.text = newModel.date
        self.contentLbl.text = newModel.content
    }

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  MedUsedReplacedVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MedUsedReplacedVC: UIViewController {

    @IBOutlet weak var txtMedName: UITextField!
    @IBOutlet weak var txtTruck: UITextField!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtNumWithExpDate1: UITextField!
    @IBOutlet weak var txtNewExpDate: UITextField!
    @IBOutlet weak var txtNumWithExpDate2: UITextField!
    
    var data: MedCell? // This var contains the info from the MedUsedVC.
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtMedName.text = data?.txtName.text
        txtTruck.text = data?.txtTruck.text
        txtBox.text = data?.txtBox.text
        txtExpDate.text = data?.txtExpDate.text
        txtNumWithExpDate1.text = data?.txtQuantity.text
    }
    
    @IBAction func updateBtnTapped(sender: UIButton) {
        
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

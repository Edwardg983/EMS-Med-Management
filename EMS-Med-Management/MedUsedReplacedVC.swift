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
    var dataService = DataService.instance
    var id: String = "" // This is so I can perform findByID
   
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMedName.text = data?.txtName.text
        txtTruck.text = data?.txtTruck.text
        txtBox.text = data?.txtBox.text
        txtExpDate.text = data?.txtExpDate.text
        txtNumWithExpDate1.text = data?.txtQuantity.text
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        var numberUsed = 0
        
        if(Int(Int(txtNumWithExpDate1.text!)! - (Int(txtNumWithExpDate2.text!))!) == 0){
            numberUsed = Int(txtNumWithExpDate1.text!)!
            
            dataService.updateMedUsed((data?.id)!, name: txtMedName.text!, expDate: txtNewExpDate.text!, quantity:numberUsed, truck: txtTruck.text!, box: txtBox.text!) { Success in
                if Success {
                    print("Med was successfully saved")
                } else {
                    print("An Error occurred while saving the med")
                }
            }
        } else {
            numberUsed = Int(Int(txtNumWithExpDate1.text!)! - (Int(txtNumWithExpDate2.text!))!)
            
            dataService.updateMedUsed((data?.id)!, name: txtMedName.text!, expDate: txtNewExpDate.text!, quantity:numberUsed, truck: txtTruck.text!, box: txtBox.text!) { Success in
                if Success {
                    print("Med was successfully saved")
                } else {
                    print("An Error occurred while saving the med")
                }
            }
            
            dataService.addNewMedication(txtMedName.text!, expDate: txtExpDate.text!, quantity: (Int(txtNumWithExpDate2.text!))!, truck: txtTruck.text!, box: txtBox.text!) { Success in
                if Success {
                    print("Med was successfully saved")
                } else {
                    print("An Error occurred while saving the med")
                }
            }
        }
        
        
    }
    
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

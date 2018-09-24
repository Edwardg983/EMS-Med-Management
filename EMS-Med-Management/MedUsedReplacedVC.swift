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
    var expirationDate: String = ""
    
    func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        let dateString = date
        dateFormatter.dateFormat = "MM-dd-yy"
        
        let dateFromString: Date? = dateFormatter.date(from: dateString)
        
        return dateFromString!
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMedName.text = data?.txtName.text
        txtTruck.text = data?.txtTruck.text
        txtBox.text = data?.txtBox.text
        txtExpDate.text = data?.txtExpDate.text
        txtNumWithExpDate1.text = data?.txtQuantity.text
    }
    
    // TODO: Create error handling. Prevent neg number, prevent exp date that already passed.
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        var numberUsed = 0
        
        let expDateExists = dataService.medsUsed.map({$0.expDate})
        
        // This if will handle med with an exp date that already exists and the number being replaced is equal to the number with the existing exp date.
        if(expDateExists.contains(txtNewExpDate.text!)) && (Int(Int(txtNumWithExpDate1.text!)! - (Int(txtNumWithExpDate2.text!))!) == 0){
            numberUsed = Int(txtNumWithExpDate1.text!)!
            let index = expDateExists.index(of: txtNewExpDate.text!)
            let medFound = dataService.medsUsed[index!]
            
            dataService.updateMedUsed(medFound.id, name: txtMedName.text!, expDate: txtNewExpDate.text!, quantity:(numberUsed + (Int(medFound.quantity))), truck: txtTruck.text!, box: txtBox.text!) { Success in
                if Success {
                    print("Med was successfully saved")
                } else {
                    print("An Error occurred while saving the med")
                }
            }
            
            dataService.deleteMed((data?.id)!) { Success in
                if Success {
                    print("Med was successfully deleted")
                } else {
                    print("An Error occurred while deleteing the med")
                }
            }
       //      This chunk of code will handle med with exp that already exists but number being replaced is different from number with the existing date
             
        } else if (expDateExists.contains(txtNewExpDate.text!)) && (Int(Int(txtNumWithExpDate1.text!)! - (Int(txtNumWithExpDate2.text!))!) > 0) {
             let index = expDateExists.index(of: txtNewExpDate.text!)
             let medFound = dataService.medsUsed[index!]
             numberUsed = medFound.quantity + (Int(txtNumWithExpDate2.text!))!
            
            dataService.updateMedUsed(medFound.id, name: txtMedName.text!, expDate: txtNewExpDate.text!, quantity: numberUsed, truck: txtTruck.text!, box: txtBox.text!) { Success in
                if Success {
                    print("Med was successfully saved")
                } else {
                    print("An Error occurred while saving the med")
                }
            }
            
            dataService.updateMedUsed((data?.id)!, name: txtMedName.text!, expDate: (data?.txtExpDate.text)!, quantity: ((Int((data?.txtQuantity.text!)!)!) - (Int(txtNumWithExpDate2.text!))!), truck: txtTruck.text!, box: txtBox.text!) { Success in
                if Success {
                    print("Med was successfully saved")
                } else {
                    print("An Error occurred while saving the med")
                }
            }
        } else {
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
    }
    
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

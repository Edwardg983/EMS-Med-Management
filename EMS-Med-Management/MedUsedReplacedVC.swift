//
//  MedUsedReplacedVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MedUsedReplacedVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
        
    @IBOutlet weak var truckPicker: UIPickerView!
    @IBOutlet weak var boxPicker: UIPickerView!
    @IBOutlet weak var drugUsedPicker: UIPickerView!
    @IBOutlet weak var expDatesPicker: UIPickerView!
    @IBOutlet weak var oldDatesPicker: UIPickerView!
    @IBOutlet weak var newExpDateTxtFld: UITextField!
    @IBOutlet weak var newDatesPicker: UIPickerView!
    
    
    
    var trucks = ["A1", "A2", "A3", "A4", "A5"] // TODO: Load the seperate DB
    var boxes = ["Medic", "Intermediate"]       // TODO: Load the seperate DB
    var drugUsed = ["D10", "Albuterol","NTG"]   // TODO: Load the seperate DB
    var exp_Date = ["3/31/2017", "12/31/2016", "6/30/2017"] // Will load the expDates of the used med by querying trucks, box and med name.
    var numberUsedReplacing = ["1", "2", "3", "4", "5"] // This array fills both the number of used and replacing pickers.
    
    var data: MedCell? // I'm hoping this var will contain the info from the MedUsedVC.
    var truck: String?
    var medName: String?
    var box: String?
    var quantity: Int?
    var expDate: String?  // Will need to change type once I figured out how to use dates.
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        truckPicker.dataSource = self
        truckPicker.delegate = self
        boxPicker.delegate = self
        boxPicker.dataSource = self
        drugUsedPicker.delegate = self
        drugUsedPicker.dataSource = self
        expDatesPicker.delegate = self
        expDatesPicker.dataSource = self    
        oldDatesPicker.delegate = self
        oldDatesPicker.dataSource = self
        newDatesPicker.delegate = self
        newDatesPicker.dataSource = self
        
        truckPicker.layer.cornerRadius = 5.0
        
        print(data?.txtName) as! String  // Hoping this will populate the name field in this VC. Once I have the method created to search the DB for the med used I will be able to test this. 12/24/17
        
        
    }
    
    @IBAction func updateBtnTapped(sender: UIButton) {
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == truckPicker{
            return trucks.count
        }
        if pickerView == boxPicker{
            return boxes.count
        }
        if pickerView == drugUsedPicker{
            return drugUsed.count
        }
        if pickerView == expDatesPicker{
            return exp_Date.count
        }
        if pickerView == oldDatesPicker{
            return numberUsedReplacing.count
        }
        if pickerView == newDatesPicker{
            return numberUsedReplacing.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == truckPicker{
            return trucks[row]
        }
        if pickerView == boxPicker{
            return boxes[row]
        }
        if pickerView == drugUsedPicker{
            return drugUsed[row]
        }
        if pickerView == expDatesPicker{
            return exp_Date[row]
        }
        if pickerView == oldDatesPicker{
            return numberUsedReplacing[row]
        }
        if pickerView == newDatesPicker{
            return numberUsedReplacing[row]
        }
        
        return "Empty"
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

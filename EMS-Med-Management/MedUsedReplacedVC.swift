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
    
    
    var trucks = ["A1", "A2", "A3", "A4", "A5"]
    var boxes = ["Medic", "Intermediate"]
    var drugUsed = ["D10", "Albuterol","NTG"]
    var expDate = ["3/31/2017", "12/31/2016", "6/30/2017"]
    var numberUsedReplacing = ["1", "2", "3", "4", "5"] // This array fills both the number of used and replacing pickers.
    
    
    
    
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
            return expDate.count
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
            return expDate[row]
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

//
//  MedUsedVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 10/11/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MedUsedVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var truckPicker: UIPickerView!
    @IBOutlet weak var boxPicker: UIPickerView!
    @IBOutlet weak var drugUsedPicker: UIPickerView!
    
    var dataService = DataService.instance
    var trucks = ["A1", "A2", "A3", "A4", "A5"] // TODO: Load the seperate DB
    var boxes = ["Medic", "Intermediate"]       // TODO: Load the seperate DB
    var drugUsed = ["D10", "Albuterol","NTG"]   // TODO: Load the seperate DB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        truckPicker.dataSource = self
        truckPicker.delegate = self
        boxPicker.delegate = self
        boxPicker.dataSource = self
        drugUsedPicker.delegate = self
        drugUsedPicker.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        return "Empty"
    }


}

extension MedUsedVC: DataServiceDelegate {
    func medicationsLoaded() {
        DispatchQueue.main.async {
            print("medsLoaded()")
            self.tableView.reloadData()
        }
    }
}

extension MedUsedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Med count is: \(dataService.emsMeds.count)" )
        return dataService.meds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MedCell", for: indexPath) as? MedCell {
            cell.configureCell(med: dataService.meds[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

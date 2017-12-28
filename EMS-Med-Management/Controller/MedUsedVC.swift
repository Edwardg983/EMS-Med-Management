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
    @IBOutlet weak var medUsedPicker: UIPickerView!
    
    var dataService = DataService.instance
//    var trucks = ["A1", "A2", "A3", "A4", "A5"] // TODO: Load the seperate DB
//    var boxes = ["Medic", "Intermediate"]       // TODO: Load the seperate DB
//    var drugUsed = ["D10", "Albuterol","NTG"]   // TODO: Load the seperate DB
//    var medNames = [MedName]() // This array will be used to hold the distinct names of meds in the collection which will than be used to populate the drugUsedPicker. To find this array used the .distinct() in MongoDB (db.getCollection('medications').distinct("name") This is the command used in Robo 3T to create the distinct list.) Will actual what to do this for the other pickers in this VC also.
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//  Moved these to mainVC in the viewDidLoad() so that they would be populated before this VC loads, otherwise the pickers don't populate unless I leave page and come back.
//        DataService.instance.getDistinctMedNames()
//        DataService.instance.getDistinctTruckNames()
//        DataService.instance.getDistinctBoxNames()
        
        dataService.delegate = self
        truckPicker.dataSource = self
        truckPicker.delegate = self
        boxPicker.delegate = self
        boxPicker.dataSource = self
        medUsedPicker.delegate = self
        medUsedPicker.dataSource = self
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
            return DataService.instance.distinctTruckNames.count
        }
        if pickerView == boxPicker{
            return DataService.instance.distinctBoxNames.count
        }
        if pickerView == medUsedPicker{
            return DataService.instance.distinctMedNames.count
        }
        
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == truckPicker{
            return dataService.distinctTruckNames[row]
        }
        if pickerView == boxPicker{
            return dataService.distinctBoxNames[row]
        }
        if pickerView == medUsedPicker{
            return dataService.distinctMedNames[row]
        }
        
        return "Empty"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMedUsedReplaced" {
            let destinationVC = segue.destination as! MedUsedReplacedVC
            
            destinationVC.data = sender as? MedCell
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Think this is the func I need to use to trigger segue
        
        performSegue(withIdentifier: "goToMedUsedReplaced", sender: self)
    }
    
    
    
    
    
    
    
    
    
    
}

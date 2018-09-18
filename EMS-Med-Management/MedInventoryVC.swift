//
//  MedInventoryVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MedInventoryVC: UIViewController {
  
    @IBOutlet weak var txtMedName: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var txtTruck: UITextField!
    
    var dataService = DataService.instance
    
    let df : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getAllMedications()
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addMedBtnTapped(_ sender: UIButton) {

        dataService.addNewMedication(txtMedName.text!, expDate: txtExpDate.text!, quantity: Int(txtQuantity.text!)!, truck: txtTruck.text!, box: txtBox.text!) { Success in
            if Success {
                print("Med was successfully saved")
            } else {
                print("An Error occurred while saving the med")
            }
        }
    }
    
    @IBAction func removeMedBtnTapped(_ sender: Any) {
    }
    
}

extension MedInventoryVC: DataServiceDelegate {
    func medicationsLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MedInventoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

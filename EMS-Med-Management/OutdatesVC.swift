//
//  OutdatesVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class OutdatesVC: UIViewController {
    
    var medsToReplace: [ExpMedication] = [ExpMedication]()
    var dataService = DataService.instance
    var expirationDate: Date = Date()
    var convertedUniqueMedNames: [String] = []
    var uniqueMedNames: [String:Int] = [:]
    

    
    @IBOutlet weak var txtDateOfExpBy: UITextField!
    @IBOutlet weak var txtBox: UITextField!
    @IBOutlet weak var txtTruck: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
                let dateString = date
                dateFormatter.dateFormat = "MM-dd-yy"
        
                let dateFromString: Date? = dateFormatter.date(from: dateString)
        
                return dateFromString!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // This loads the entire DB just as getAllMedications does. Not sure why I duplicated this method.
        DataService.instance.getAllExpiringMedications()
   }

   @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // TODO: Need to add code to verifiy fields are not blank and contain appropriate type of data.
    @IBAction func generateListBtnPressed(_ sender: Any) {
        expirationDate = stringToDate(date: txtDateOfExpBy.text!)
        
        // This clears the arrays and dictionary in case the info in the text fields is changed and Generate button is pushed during the same session.
        convertedUniqueMedNames = []
        uniqueMedNames = [:]
        medsToReplace = []

        
        if txtTruck.text == "All" && txtBox.text == "All" {
            for med in dataService.expiringMeds {
                if med.expDate < expirationDate {
                    medsToReplace.append(med)
                }
            }
        } else if txtTruck.text == "All" {
            for med in dataService.expiringMeds {
                if med.box == txtBox.text && med.expDate < expirationDate {
                    medsToReplace.append(med)
                }
            }
        } else if txtBox.text == "All" {
            for med in dataService.expiringMeds {
                if med.truck == txtTruck.text && med.expDate < expirationDate {
                    medsToReplace.append(med)
                }
            }
        } else {
            for med in dataService.expiringMeds {
                if med.truck == txtTruck.text && med.box == txtBox.text && med.expDate < expirationDate {
                    medsToReplace.append(med)
                }
            }
        }

        
// This will create the dictionary that holds the unique med names along with the count of how many need to be replace of each unique med in the list.
        
        medsToReplace.forEach() {
            item in

            if !uniqueMedNames.keys.contains(item.name) {
               uniqueMedNames[item.name] = item.quantity
            } else {
                let count:Int = uniqueMedNames[item.name]!
                let newCount:Int = item.quantity + count
                uniqueMedNames.updateValue(newCount, forKey: item.name)
            }
        }
        
// Converts the dictionary back to an array. I did this because I have not been able to figure out how to fill a tableview from a dictionary.
        convertedUniqueMedNames = Array(self.uniqueMedNames.keys)
       
        medicationsLoaded()
        
    }
}

extension OutdatesVC: DataServiceDelegate {
    func medicationsLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func boxsLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension OutdatesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertedUniqueMedNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpMedCell", for: indexPath) as? ExpMedCell {
            cell.configureCell(name:convertedUniqueMedNames[indexPath.row], quantity:uniqueMedNames) //, indexPath: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

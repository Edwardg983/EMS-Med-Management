//
//  ListOfTrucksVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class ListOfTrucksVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtNameLbl: UITextField!
    
    var dataService = DataService.instance
    var truck = TruckName()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getAllTrucks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        
        dataService.deleteTruck(truck.id) { Success in
            if Success {
                print("Med was successfully deleted")
            } else {
                print("An Error occurred while deleteing the med")
            }
        }
    }
    @IBAction func addBtnTapped(_ sender: Any) {
        dataService.addNewTruck(txtNameLbl.text!) { Success in
            if Success {
                print("Truck was successfully saved")
            } else {
                print("An Error occurred while saving the truck")
            }
        }
    }
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ListOfTrucksVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.trucks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCell", for: indexPath) as? TruckCell {
            cell.configureCell(truck: dataService.trucks[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        truck = dataService.trucks[indexPath.row]
    }
}

extension ListOfTrucksVC: DataServiceDelegate {
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

//
//  MedInventoryVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MedInventoryVC: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    
    var dataService = DataService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.instance.getAllMedications()
        //dataService.getAllMedications { Success in
        //}

        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

  
}

extension MedInventoryVC: DataServiceDelegate {
    func medicationsLoaded() {
        DispatchQueue.main.async {
            print("medsLoaded()")
            self.tableView.reloadData()
        }
    }
}

extension MedInventoryVC: UITableViewDelegate, UITableViewDataSource {
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

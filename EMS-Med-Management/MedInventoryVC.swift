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
        
        dataService.getAllMeds { Success in
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MedInventoryVC: DataServiceDelegate {
    func medsLoaded() {
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
        print("Med count is: \(dataService.emsMeds.count)" )
        return dataService.emsMeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EMSMedCell", for: indexPath) as? EMSMedCell {
            cell.configureCell(med: dataService.emsMeds[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

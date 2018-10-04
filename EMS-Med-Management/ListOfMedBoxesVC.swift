//
//  ListOfMedBoxesVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class ListOfMedBoxesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtNameLbl: UITextField!
    var dataService = DataService.instance
    var box = BoxName()
    var box1 = BoxName()
    var box2 = BoxName()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
//        dataService.delegate = self
        
        dataService.getAllBoxs { (Success) in
            
        }
        
    }
    
    func boxesLoaded() {
        dataService.getAllBoxs { Success in
            if Success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // change 0.25 to desired number of seconds your code with delay
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("An Error occured while reloading array")
            }
        }
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        dataService.deleteBox(box1.id) { Success in
            if Success {
                print("Box was successfully deleted")
                self.boxesLoaded()
            } else {
                print("An Error occurred while deleteing the box")
            }
        }
//        dataService.deleteBox(box1.id) { Success in
//            print("Returned from callback")
//            if Success {
//                print("After deleting box, count is: ", self.dataService.boxs.count)
//                self.dataService.getAllBoxs { Success in
//                    if Success {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // change 0.25 to desired number of seconds your code with delay
//                            print("Returned from 2 callback")
//                            print("After getting All the boxs, count is: ", self.dataService.boxs.count)
//                            OperationQueue.main.addOperation {
//                                self.tableView.reloadData()
//                                print("After reloading the tableview, count is: ", self.dataService.boxs.count)
//                            }
//                        }
//                        } else {
//                            print("An Error occured while reloading array")
//                        }
//                    }
//
//                print("Box was successfully deleted")
//                //self.boxesLoaded()
//            } else {
//                print("An Error occurred while deleteing the box")
//            }
//        }
        

    }
    @IBAction func addBtnTapped(_ sender: Any) {
        dataService.addNewBox(txtNameLbl.text!) { Success in
            if Success {
                print("Box was successfully saved")
                self.boxesLoaded()
            } else {
                print("An Error occurred while saving the box")
            }
        }
    }
    @IBAction func homeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ListOfMedBoxesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Boxes count is: ", dataService.boxs.count)
        return dataService.boxs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BoxCell", for: indexPath) as? BoxCell {
            box2 = dataService.boxs[indexPath.row]
            //print("The index of box2 is: ",dataService.boxs.index(of: box2))
            cell.configureCell(box: dataService.boxs[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Row selected: ", dataService.boxs[indexPath.row])
        box1 = dataService.boxs[indexPath.row]
        //print("The index of box is: ",dataService.boxs.index(of: box1))
    }
}

extension ListOfMedBoxesVC: DataServiceDelegate {
    func medicationsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }

    func boxsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }

//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//   }
    
//    func reviewsLoaded() {
//        OperationQueue.main.addOperation {
//            self.tableView.reloadData()
//        }
  }
}

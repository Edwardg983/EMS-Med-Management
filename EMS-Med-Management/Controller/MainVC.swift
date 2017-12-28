//
//  MainVC.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var medUsedReplacedBtn: UIButton!
    @IBOutlet weak var truckInventory: UIButton!
    @IBOutlet weak var listOfMedBoxes: UIButton!
    @IBOutlet weak var outdates: UIButton!
    @IBOutlet weak var listOfTrucks: UIButton!
    @IBOutlet weak var medInventory: UIButton!
    
    var logInVC: LogInVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.delegate = self
        //DataService.instance.getAllMedications()
        DataService.instance.getDistinctMedNames()
        DataService.instance.getDistinctTruckNames()
        DataService.instance.getDistinctBoxNames()
    }
}

extension MainVC: DataServiceDelegate {
    func medicationsLoaded() {
 //      print(DataService.instance.meds)
    }
}

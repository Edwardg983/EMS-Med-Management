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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

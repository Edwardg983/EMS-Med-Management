//
//  MedCell.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 10/6/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import UIKit

class MedCell: UITableViewCell {
    
    var id: String = ""
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtTruck: UITextField!
    @IBOutlet weak var txtBox: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(med: Medication) {
        id = med.id
        txtName.text = med.name
        txtQuantity.text = String(med.quantity)
        txtExpDate.text = med.expDate
        txtTruck.text = med.truck
        txtBox.text = med.box
    }

}

//
//  ExpMedCell.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/11/18.
//  Copyright © 2018 Edward Greene. All rights reserved.
//

import UIKit
import Foundation

class ExpMedCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Name is an array. Quantity is a dictionary.
    func configureCell(name: String, quantity: [String:Int]) {
        txtName.text = name
        txtQuantity.text = String(quantity[name]!)
    }
    
    func stringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd" //"dd-MM-yyyy"
        let unwrappedDate = formatter.string(from:date)
        return unwrappedDate
    }
    
}


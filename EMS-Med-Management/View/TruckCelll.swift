//
//  TruckCellTableViewCell.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 9/25/18.
//  Copyright © 2018 Edward Greene. All rights reserved.
//

import UIKit

class TruckCell: UITableViewCell {

    @IBOutlet weak var txtNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(truck: TruckName ) {
        txtNameLbl.text = truck.name
    }

}

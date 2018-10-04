//
//  MyButton.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 3/7/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation
import UIKit


class myButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
//        self.backgroundColor = UIColor(red: 129.0/255.0, green: 128.0/255.0, blue: 137.0/255.0, alpha: 1)
        self.backgroundColor = UIColor(red: 219.0/255.0, green: 226.0/255.0, blue: 239.0/255.0, alpha: 1)
        
    }    
}


//
//  Medication.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 10/5/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

class Medication: NSObject {
    var id: String = ""
    var name: String = ""
    var expDate: String = ""
    var quantity: Int = 0
    var truck: String = ""
    var box: String = ""
    
    static func parseMedicationJSONData(data: Data) -> [Medication] {
        var medications = [Medication]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

// Parse JSON Data.
            if let meds = jsonResult as? [Dictionary<String, AnyObject>] {
                for med in meds {
                    let newMed = Medication()
                    newMed.id = med["_id"] as! String
                    newMed.name = med["name"] as! String
                    newMed.expDate = med["expDate"] as! String
                    newMed.quantity = med["quantity"] as! Int
                    newMed.truck = med["truck"] as! String
                    newMed.box = med["box"] as! String
                    
                    medications.append(newMed)
                }
            }
        } catch let err {
            print(err)
        }
        return medications
    }
    
    override var description:String {
        return "name: \(self.name) \nExp Date: \(self.expDate) \nQuantity: \(self.quantity) \nTruck: \(self.truck) \nBox: \(self.box) \n"
    }
}

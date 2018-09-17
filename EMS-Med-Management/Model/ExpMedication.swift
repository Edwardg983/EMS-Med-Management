//
//  ExpMedication.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 2/19/18.
//  Copyright © 2018 Edward Greene. All rights reserved.
//

import Foundation

//  This class is used to perform all the functions for compiling the expiration list.

class ExpMedication: NSObject {
    var id: String = ""
    var name: String = ""
    var expDate: Date = Date()
    var quantity: Int = 0
    var truck: String = ""
    var box: String = ""
    
    
    
//  This function parses the list of meds with the expDate as a Date object instead of a String.
    static func parseExpMedicationJSONData(data: Data) -> [ExpMedication] {
        
        var expMedications = [ExpMedication]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
// Parse JSON Data.
            
            if let meds = jsonResult as? [Dictionary<String, AnyObject>] {
                for med in meds {
                    let newMed = ExpMedication()
                    newMed.id = med["_id"] as! String
                    newMed.name = med["name"] as! String
                    newMed.expDate = stringToDate(date: med["expDate"] as! String)
                    newMed.quantity = med["quantity"] as! Int
                    newMed.truck = med["truck"] as! String
                    newMed.box = med["box"] as! String
                    
                    expMedications.append(newMed)
                }
            }
        } catch let err {
            print(err)
        }
        return expMedications
    }
        
    static func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        let dateString = date
        dateFormatter.dateFormat = "MM-dd-yy"
        
        let dateFromString: Date? = dateFormatter.date(from: dateString)
        
        return dateFromString!
    }
    
    override var description:String {
        return "name: \(self.name) \nExp Date: \(self.expDate) \nQuantity: \(self.quantity) \nTruck: \(self.truck) \nBox: \(self.box) \n"
    }
    
}

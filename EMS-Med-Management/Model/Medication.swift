//
//  Medication.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 10/5/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

class Medication {
    var id: String = ""
    var name: String = ""
    var expDate: String = ""   //Date = Date()
    var quantity: Int = 0
    var truck: String = ""
    var box: String = ""
    
    static func parseMedicationJSONData(data: Data) -> [Medication] {
        var medications = [Medication]()
        //let dateFormatter = DateFormatter()
        let dateFormatter = ISO8601DateFormatter()
        
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ" //iso 8601
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON Data.
            if let meds = jsonResult as? [Dictionary<String, AnyObject>] {
                for med in meds {
                    
                    let newMed = Medication()
                    newMed.id = med["_id"] as! String
                    //print(newMed.id)
                    newMed.name = med["name"] as! String
                    //print(newMed.name)
                    newMed.expDate = med["expDate"] as! String
                    
                    
                    //let inputDate = "2015-06-18T19:00:53-07:00"
                    
                    
                    //let outputDate = dateFormatter.date(from: inputDate)
                    
                    
                    //print(newMed.expDate)
                    newMed.quantity = med["quantity"] as! Int
                    //print(newMed.quantity)
                    newMed.truck = med["truck"] as! String
                    //print(newMed.truck)
                    newMed.box = med["box"] as! String
                    //print(newMed.box)
                    
                    //print(newMed)
                    medications.append(newMed)
                }
            }
        } catch let err {
            print(err)
        }
        return medications
    }
}

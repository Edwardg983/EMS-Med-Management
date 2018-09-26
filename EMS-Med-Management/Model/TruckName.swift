//
//  TruckName.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 9/26/18.
//  Copyright © 2018 Edward Greene. All rights reserved.
//

import Foundation

class TruckName: NSObject {
    var id: String = ""
    var name: String = ""
    
    
    static func parseTruckNameJSONData(data: Data) -> [TruckName] {
        var trucksArray = [TruckName]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON Data.
            if let trucks = jsonResult as? [Dictionary<String, AnyObject>] {
                for truck in trucks {
                    let newTruck = TruckName()
                    newTruck.id = truck["_id"] as! String
                    newTruck.name = truck["name"] as! String
                    
                   trucksArray.append(newTruck)
                }
            }
        } catch let err {
            print(err)
        }
        return trucksArray
    }
}

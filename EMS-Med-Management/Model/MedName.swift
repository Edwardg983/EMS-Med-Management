//
//  MedName.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 12/27/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

class MedName {
    var name: String = ""
    
    
    static func parseMedNameJSONData(data: Data) -> [MedName] {
        var medNames = [MedName]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            // Parse JSON Data.
            
            if let names = jsonResult as? [String] {
                print(names)
//                for name in names {
//                    let newName = MedName()
//                    //print(name)
//                    newName.name = name
//
//                    medNames.append(newName)
//                }
//                print(medNames)
//                print("medNames should have printed")
            }
//            if let names = jsonResult as? [Dictionary<String, AnyObject>] {
//                for name in names {
//
//                    let newName = MedName()
//                    newName.name = name["name"] as! String
//
//                    medNames.append(newName)
//                }
//            }
        } catch let err {
            print(err)
        }
        return medNames
    }
}

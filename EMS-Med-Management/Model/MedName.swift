//
//  MedName.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 12/27/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

class MedName {
    
    static func parseMedNameJSONData(data: Data) -> [String] {
        var medNames = [String]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
// Parse JSON Data.
            
            if let names = jsonResult as? [String] {
                for name in names {
                    var newName = ""
                    newName = name

                    medNames.append(newName)
                }
           }
            
        } catch let err {
            print(err)
        }
        return medNames
    }
}

//
//  MedUsed.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 12/28/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

class MedUsed {
    
    static func parseMedUsedJSONData(data: Data) -> [String] {
        var medUsed = [String]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
 // Parse JSON Data.
            
            if let names = jsonResult as? [String] {
                for name in names {
                    var newName = ""
                    newName = name
                    
                    medUsed.append(newName)
                }
            }
            
        } catch let err {
            print(err)
        }
        return medUsed
    }
}

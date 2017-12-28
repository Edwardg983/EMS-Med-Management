//
//  BoxName.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 12/28/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

class BoxName {
    
    static func parseBoxNameJSONData(data: Data) -> [String] {
        var boxNames = [String]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            // Parse JSON Data.
            
            if let names = jsonResult as? [String] {
                for name in names {
                    var newName = ""
                    newName = name
                    boxNames.append(newName)
                }
            }
            
        } catch let err {
            print(err)
        }
        print("Box Names count \(boxNames.count)")
        return boxNames
    }
}

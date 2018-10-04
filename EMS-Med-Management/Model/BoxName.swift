//
//  BoxName.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 9/26/18.
//  Copyright © 2018 Edward Greene. All rights reserved.
//

import Foundation

class BoxName: NSObject {
    var id: String = ""
    var name: String = ""
    
    
    static func parseBoxNameJSONData(data: Data) -> [BoxName] {
        var boxsArray = [BoxName]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON Data.
            if let boxs = jsonResult as? [Dictionary<String, AnyObject>] {
                for box in boxs {
                    let newBox = BoxName()
                    newBox.id = box["_id"] as! String
                    newBox.name = box["name"] as! String
                    
                    boxsArray.append(newBox)
                }
            }
        } catch let err {
            print(err)
        }
        return boxsArray
    }
    
    override var description:String {
        return "name: \(self.name) \nId: \(self.id) \n"
    }
}

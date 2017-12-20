//
//  DataService.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 10/5/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

protocol DataServiceDelegate: class {
    func medicationsLoaded()
}

class DataService {
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    var meds = [Medication]()  // All meds
    var medsUsed = [Medication]() // Meds used on a call
    
    // GET all medications
    func getAllMedications() {
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the request
        // Get all medications (GET /api/v1/medication
        guard let URL = URL(string: GET_ALL_MEDS_URL) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if let data = data {
                    self.meds = Medication.parseMedicationJSONData(data: data)
                    self.delegate?.medicationsLoaded()
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // POST add a new medication
    func addNewMedication(_ name: String, expDate: Date, quantity: Int, truck: String, box: String, completion: @escaping callback) {
        
        // Construct JSON
        let json: [String: Any] = [
            "name": name,
            "expDate": expDate,
            "quantity": quantity,
            "truck": truck,
            "box": box
        ]
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_NEW_MED) else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler:  { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    // Check for status code 200 here. If it's not 200, then
                    // authenication was not successful. If it is, we're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session task succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        self.getAllMedications()
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            completion(false)
            print(err)
        }
    }
    
    // TODO: Need to create a function that works with the MedUsedVC. This function will need to take the info from the text fields and search the DB. The returned info will populate the table view. This function will be similar to the functions Jack used to find a specific truck, only it will use  more fields which need to be matched.
}































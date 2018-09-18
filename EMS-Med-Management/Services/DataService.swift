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
    var expiringMeds = [ExpMedication]() // Expiring meds
    var distinctMedNames = [String]()
    var distinctTruckNames = [String]()
    var distinctBoxNames = [String]()
    
    
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
    
    // GET all expiring medications
    func getAllExpiringMedications() {
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the request
        // Get all medications (GET /api/v1/medication)
        guard let URL = URL(string: GET_ALL_MEDS_URL) else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                if let data = data {
                    self.expiringMeds = ExpMedication.parseExpMedicationJSONData(data: data)
                    self.delegate?.medicationsLoaded()
                    
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
        
    }
    
    // POST add a new medication
    func addNewMedication(_ name: String, expDate: String, quantity: Int, truck: String, box: String, completion: @escaping callback) {
        print("Inside DataService add new med before the construct JSON")
        // Construct JSON
        let json: [String: Any] = [
            "name": name,
            "expDate": expDate,
            "quantity": quantity,
            "truck": truck,
            "box": box
        ]
        
        // Debugging code
        print("This is the JSON object: \(json)")
        
        if JSONSerialization.isValidJSONObject(json) {
            print("Object is valid")
        } else {
            print("Object is not valid")
        }
        // End Debugging code
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_NEW_MED) else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
//   Commented out until AuthService is implemented.
//            guard let token = AuthService.instance.authToken else {
//                completion(false)
//                return
//            }
//
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
    
    func updateMedUsed(_ id: String, name: String, expDate: String, quantity: Int, truck: String, box: String, completion: @escaping callback){
        
        let json: [String: Any] = [
            "id": id,
            "name": name,
            "expDate": expDate,
            "quantity": quantity,
            "truck": truck,
            "box": box
        ]
        
        print("The JSON consists of: ",id,name,expDate,quantity,truck,box)
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: "\(PUT_UPDATE_MED_USED)/\(id)") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "PUT"
            //   Commented out until AuthService is implemented.
            //            guard let token = AuthService.instance.authToken else {
            //                completion(false)
            //                return
            //            }
            //
            //            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
    
    
    // TODO: Need to create a function that works with the MedUsedVC. This function will need to take the info from the text fields and search the DB. The returned info will populate the table view. This function will be similar to the functions Jack used to find a specific truck for its reviews, only it will use  more fields which need to be matched. DataService video at 22 min mark.
    
    // ********  12/27/17 This function has not been tested yet. Since I'm not sure how the actual collection name is determined. This function might create a medsUsed collection which will need to be reset to an empty array after useage  *******
    // ********  12/28/17 Has been tested and works as hoped. One problem encountered, not able to search for Epi 1:10000. Assume Epi 1:1000 will be the same. Also need to add error handling, if it searches and does not come back with any results.
    
    // GET med used on a call
    func getMedUsed(_ name: String, truck: String, box: String) {
        print("These are the variables passed in: \(name) \(truck) \(box)")
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_MED_USED)/\(name)" + "/" + "\(truck)" + "/" + "\(box)") else { return }
        print(URL)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                // Parse JSON data
//                print(data)
                if let data = data {
                    self.medsUsed = Medication.parseMedicationJSONData(data: data)
//                    print(self.medsUsed)
                    self.delegate?.medicationsLoaded()
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func getDistinctMedNames() {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_DISTINCT_MED_NAMES)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                // Parse JSON data
                if let data = data {
                    self.distinctMedNames = MedName.parseMedNameJSONData(data: data)
//                    self.delegate?.medicationsLoaded() // May need to institute a specific function (distinctMedNamesLoaded())
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func getDistinctTruckNames() {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_DISTINCT_TRUCK_NAMES)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                // Parse JSON data
                if let data = data {
                    self.distinctTruckNames = TruckName.parseTruckNameJSONData(data: data)
//                    self.delegate?.medicationsLoaded() // May need to institute a specific function (distinctTruckNamesLoaded())
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func getDistinctBoxNames() {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_DISTINCT_BOX_NAMES)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                // Parse JSON data
                if let data = data {
                    self.distinctBoxNames = BoxName.parseBoxNameJSONData(data: data)
//                    self.delegate?.medicationsLoaded() // May need to institute a specific function (distinctBoxNamesLoaded())
               }
            } else {
                // Failure
                print("URL Session Task Failed: \(error?.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}































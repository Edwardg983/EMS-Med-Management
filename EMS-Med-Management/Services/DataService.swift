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
    func boxsLoaded()
}

class DataService {
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    var meds = [Medication]()  // All meds
    var medsUsed = [Medication]() // Meds used on a call
    var expiringMeds = [ExpMedication]() // Expiring meds
    var medExist = [Medication]() // Does med with new expDate already exist
    var trucks = [TruckName]()
    var boxs = [BoxName]()
    var distinctMedNames = [String]()
    var distinctTruckNames = [String]()
    var distinctBoxNames = [String]()
    
    
    // GET all medications
    func getAllMedications() {
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
    
    // GET med used on a call
    func getMedUsed(_ name: String, truck: String, box: String) {
        medsUsed = []
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_MED_USED)/\(name)" + "/" + "\(truck)" + "/" + "\(box)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task In getMedUsed Succeeded: HTTP \(statusCode)")
                // Parse JSON data
                if let data = data {
                    self.medsUsed = Medication.parseMedicationJSONData(data: data)
                    self.delegate?.medicationsLoaded()
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(String(describing: error?.localizedDescription))")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // GET check if meds with new expDate already exist in DB
    func doesMedExist(_ name: String, truck: String, box: String, expDate: String) {
        print("These are the variables passed in: \(name) \(truck) \(box) \(expDate)")
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(GET_MED_EXISTS)/\(name)" + "/" + "\(truck)" + "/" + "\(box)" + "/" + "\(expDate)") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task In doesMedExist Succeeded: HTTP \(statusCode)")
                // Parse JSON data
                if let data = data {
                    self.medExist = Medication.parseMedicationJSONData(data: data)
                    print("MedExist: ",self.medExist)
                    self.delegate?.medicationsLoaded()
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(String(describing: error?.localizedDescription))")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // DELETE delete a med by ID
    func deleteMed(_ id: String, completion: @escaping callback){
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(DELETE_MED)/\(id)") else {return}
        
        var request = URLRequest(url: URL)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task in DELETE Succeeded: HTTP \(statusCode)")
                completion(true)
            } else {
                // Failure
                print("URL Session Task in DELETE Failed: \(String(describing: error?.localizedDescription))")
                completion(false)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func deleteTruck(_ id: String, completion: @escaping callback){
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(DELETE_TRUCK)/\(id)") else {return}
        
        var request = URLRequest(url: URL)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task in DELETE Succeeded: HTTP \(statusCode)")
                completion(true)
            } else {
                // Failure
                print("URL Session Task in DELETE Failed: \(String(describing: error?.localizedDescription))")
                completion(false)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // POST add a new truck
    func addNewTruck(_ name: String, completion: @escaping callback) {
        
        // Construct JSON
        let json: [String: Any] = [
            "name": name,
        ]
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_NEW_TRUCK) else { return }
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
                        //self.getAllMedications()
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
    
    // GET all trucks
    func getAllTrucks() {
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the request
        // Get all trucks (GET /api/v1/truck)
        guard let URL = URL(string: "\(GET_ALL_TRUCKS_URL)") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                if let data = data {
                    self.trucks = TruckName.parseTruckNameJSONData(data: data)
                    print("Trucks: ", self.trucks)
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
    
    // POST add a new box
    func addNewBox(_ name: String, completion: @escaping callback) {
        
        // Construct JSON
        let json: [String: Any] = [
            "name": name,
            ]
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_NEW_BOX) else { return }
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
                        //self.getAllMedications()
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
    
    func deleteBox(_ id: String, completion: @escaping callback){
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "\(DELETE_BOX)/\(id)") else {return}
        print("URL: ", URL)
        var request = URLRequest(url: URL)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                // self.delegate?.boxsLoaded()
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task in DELETE Succeeded: HTTP \(statusCode)")
                completion(true)
            } else {
                // Failure
                completion(false)
                print("URL Session Task in DELETE Failed: \(String(describing: error?.localizedDescription))")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // GET all boxes
    func getAllBoxs(completion: @escaping callback) {
        //boxs = []
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the request
        // Get all boxs (GET /api/v1/box)
        guard let URL = URL(string: "\(GET_ALL_BOXS_URL)") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                completion(true)
                
                
                if let data = data {
                    self.boxs = BoxName.parseBoxNameJSONData(data: data)
                    print("Boxs have loaded")
                    //print("Boxs array contains: ", self.boxs)
                    //self.delegate?.boxsLoaded()                    
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
                completion(false)
                
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
                print("URL Session Task Failed: \(String(describing: error?.localizedDescription))")
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
                    self.distinctTruckNames = UniqueTruckName.parseTruckNameJSONData(data: data)
//                    self.delegate?.medicationsLoaded() // May need to institute a specific function (distinctTruckNamesLoaded())
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(String(describing: error?.localizedDescription))")
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
                    self.distinctBoxNames = UniqueBoxName.parseBoxNameJSONData(data: data)
//                    self.delegate?.medicationsLoaded() // May need to institute a specific function (distinctBoxNamesLoaded())
               }
            } else {
                // Failure
                print("URL Session Task Failed: \(String(describing: error?.localizedDescription))")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}































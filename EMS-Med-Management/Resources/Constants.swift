//
//  Constants.swift
//  EMS-Med-Management
//
//  Created by Edward Greene on 10/5/17.
//  Copyright © 2017 Edward Greene. All rights reserved.
//

import Foundation

// Callbacks
// Typealias for callbacks used in Data Service
typealias callback = (_ success: Bool) -> ()

// Base URL
let BASE_API_URL = "http://localhost:3005/api/v1"

// GET methods - These are all the GET methods in the API
// -------------------------------------------------------
// GET all meds
let GET_ALL_MEDS_URL = "\(BASE_API_URL)/medication"

// GET all trucks
let GET_ALL_TRUCKS_URL = "\(BASE_API_URL)/truck"

// GET all boxs
let GET_ALL_BOXS_URL = "\(BASE_API_URL)/box"

// GET med used data
let GET_MED_USED = "\(BASE_API_URL)/medication/medUsed"

// GET distinct med names
let GET_DISTINCT_MED_NAMES = "\(BASE_API_URL)/medication/getDistinctMedNames"

// GET distinct truck names
let GET_DISTINCT_TRUCK_NAMES = "\(BASE_API_URL)/medication/getDistinctTruckNames"

// GET distinct box names
let GET_DISTINCT_BOX_NAMES = "\(BASE_API_URL)/medication/getDistinctBoxNames"

// GET check if meds with new expDate already exist in DB
let GET_MED_EXISTS = "\(BASE_API_URL)/medication/getMedExists"

// POST add new medication
let POST_ADD_NEW_MED = "\(BASE_API_URL)/medication/add"

// POST add new truck
let POST_ADD_NEW_TRUCK = "\(BASE_API_URL)/truck/add"

// POST add new box
let POST_ADD_NEW_BOX = "\(BASE_API_URL)/box/add"

// PUT update med used
let PUT_UPDATE_MED_USED = "\(BASE_API_URL)/medication/update"

// DELETE delete med by ID
let DELETE_MED = "\(BASE_API_URL)/medication"

// DELETE delete truck by ID
let DELETE_TRUCK = "\(BASE_API_URL)/truck"

// DELETE delete box by ID
let DELETE_BOX = "\(BASE_API_URL)/box"

// Boolean auth UserDefaults keys
let DEFAULTS_REGISTERED = "isRegistered"
let DEFAULTS_AUTHENTICATED = "isAuthenicated"

// Auth Email
let DEFAULTS_EMAIL = "email"

// Auth Token
let DEFAULTS_TOKEN = "authToken"

// REGISTER url
let POST_REGISTER_ACCT = "\(BASE_API_URL)/account/register"

let POST_LOGIN_ACCT = "\(BASE_API_URL)/account/login"

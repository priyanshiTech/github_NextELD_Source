//
//  DvirOfflinedataModel.swift
//  NextEld
//
//  Created by priyanshi on 13/12/25.
//

import Foundation

//MARK: -  Offline Data
struct DvirOfflinedataModel : Codable {
    let dvirStatusData : [DvirStatusDataOffline]?
}

struct DvirStatusDataOffline : Codable {
    let clientId : Int?
    let companyName : String?
    let dateTime : String?
    let driverId : Int?
    let driverSignFile : String?
    let engineHour : String?
    let localId : String?
    let location : String?
    let notes : String?
    let odometer : Int?
    let timestamp : Int?
    let trailer : [String]?
    let trailerDefect : [String]?
    let truckDefect : [String]?
    let vehicleCondition : String?
    let vehicleId : Int?
}


// MARK: - DVIR API Response Model
struct DVIROfflineResponseModel: Codable {
    let result: [DVIROffResult]?
    let arrayData: [String]?
    let status: String?
    let message: String?
    let token: String?
}

// MARK: - Result Item
struct DVIROffResult: Codable {
    let localId: String?
    let serverId: String?
}


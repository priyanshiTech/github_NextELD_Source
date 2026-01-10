//
//  ofParamDataModel.swift
//  NextEld
//
//  Created by priyanshi   on 17/07/25.
//

import Foundation
import Foundation

// MARK: - Main API Request Body



struct SyncRequest: Codable {
    var eldLogData: [String] = []
    var driveringStatusData: [DriveringStatusData] = []
    var splitLog: SplllitLogss? = nil
}

//MARK: - for Device data
struct EldLogData : Codable {
    let id : String?
    let clientId : Int?
    let coolantTemp : String?
    let dateTime : String?
    let driverId : String?
    let engineHours : Double?
    let fuelTankTemp : Int?
    let latLong : String?
    let mac : String?
    let model : String?
    let odometer : String?
    let oilTemp : Int?
    let rpm : Int?
    let serialNo : String?
    let speed : Int?
    let utcDateTime : Int?
    let vehicleId : String?
    let version : String?
    let vin : String?
}


struct DriveringStatusData : Codable {
    let appVersion : String?
    let clientId : Int?
    let currentLocation : String?
    let customLocation : String?
    let dateTime : String?
    let days : Int?
    let driverId : Int?
    let engineHour : String?
    let engineStatus : String?
    let identifier : Int?
    let isSplit : Int?
    let isVoilation : String?
    let lastOnSleepTime : Int?
    let lattitude : Double?
    let localId : String?
    let logType : String?
    let longitude : Double?
    let note : String?
    let odometer : Double?
    let origin : String?
    let osVersion : String?
    let remainingDriveTime : Int?
    let remainingDutyTime : Int?
    let remainingSleepTime : Int?
    let remainingWeeklyTime : Int?
    let shift : Int?
    let status : String?
    let utcDateTime : Int?
    let vehicleId : String?
    
}


struct SplllitLogss: Codable {
    let day: Int
    let dbId: Int
    let driverId: Int
    let shift: Int
}


//DVIR Certify Log




// MARK: - Driver Certified Log
struct DriverCertifiedLog: Codable, Identifiable {
    let id = UUID()   // local unique id for SwiftUI List
    let _id: String?          // null in JSON, keep as optional String
    let driverId: Int?
    let driverName: String?   // Can be null in API response
    let vehicleId: Int?
    let vehicleName: String?  // Can be null in API response
    let trailers: [String]?
    let shippingDocs: [String]?
    let coDriverId: Int?
    let coDriverName: String?
    let certifiedSignature: String?  // Can be null in API response
    let certifiedDate: String?
    let lCertifiedDate: Int64?
    let certifiedDateTime: Int?
    let certifiedAt: Int64?  // Changed to Int64? as API can have Int or null
    let addedTimestamp: Int64?

    enum CodingKeys: String, CodingKey {
        case _id
        case driverId, driverName, vehicleId, vehicleName, trailers, shippingDocs
        case coDriverId, coDriverName, certifiedSignature, certifiedDate
        case lCertifiedDate, certifiedDateTime, certifiedAt, addedTimestamp
    }
}

//MARK: -  DriverDVirLog Model Login API

struct DriverDvirLogResponse: Codable {
    let driverDvirLog: [DriverDvirLog]
}



struct DriverDvirLog: Codable, Identifiable {

    let id: String
    let tokenNo: String?
    let fromDate: String?
    let toDate: String?
    let email: String?
    let clientId: Int?
    let dvirLogId: Int?

    let driverId: Int
    let driverName: String

    let dateTime: String
    let lDateTime: Int64

    let location: String?

    let truckDefect: String?
    let trailerDefect: String?
    let trailer: String?

    let truckDefectImage: String?
    let trailerDefectImage: String?

    let notes: String?
    let vehicleCondition: String?

    let driverSignFile: String?

    let companyName: String?

    let odometer: Double?
    let engineHour: String?

    let vehicleId: Int?
    let vehicleNo: String?
    let vin: String?

    let timezoneName: String?
    let timezoneOffSet: String?

    let timestamp: String?
    let receivedTimestamp: Int64?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tokenNo
        case fromDate
        case toDate
        case email
        case clientId
        case dvirLogId
        case driverId
        case driverName
        case dateTime
        case lDateTime
        case location
        case truckDefect
        case trailerDefect
        case trailer
        case truckDefectImage
        case trailerDefectImage
        case notes
        case vehicleCondition
        case driverSignFile
        case companyName
        case odometer
        case engineHour
        case vehicleId
        case vehicleNo
        case vin
        case timezoneName
        case timezoneOffSet
        case timestamp
        case receivedTimestamp
    }
}

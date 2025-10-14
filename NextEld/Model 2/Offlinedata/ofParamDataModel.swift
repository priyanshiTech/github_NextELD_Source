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
    let eldLogData: [String]
    let driveringStatusData: [DriveringStatusData]
    let splitLog: SplllitLogss
}

struct DriveringStatusData: Codable {
    let appVersion: String
    let clientId: Int
    let currentLocation: String
    let customLocation: String
    let dateTime: String
    let days: Int
    let driverId: Int
    let engineHour: String
    let engineStatus: String
    let identifier: Int
    let isSplit: Int
   // let isVoilation: Int
    let isVoilation: String
    let lastOnSleepTime: Int
    let lattitude: Double
    let localId: String
    let logType: String
    let longitude: Double
    let note: String
    let odometer: Int
    let origin: String
    let osVersion: String
    let remainingDriveTime: Int
    let remainingDutyTime: Int
    let remainingSleepTime: Int
    let remainingWeeklyTime: Int
    let shift: Int
    let status: String
    let utcDateTime: Int64
    let vehicleId: Int
}


struct SplllitLogss: Codable {
    let day: Int
    let dbId: Int
    let driverId: Int
    let shift: Int
}


//DVIR Certify Log

import Foundation




// MARK: - Driver Certified Log
struct DriverCertifiedLog: Codable, Identifiable {
    let id = UUID()   // local unique id for SwiftUI List
    let _id: String?          // null in JSON, keep as optional String
    let driverId: Int
    let driverName: String
    let vehicleId: Int
    let vehicleName: String
    let trailers: [String]
    let shippingDocs: [String]
    let coDriverId: Int
    let coDriverName: String?
    let certifiedSignature: String
    let certifiedDate: String
    let lCertifiedDate: Int64
    let certifiedDateTime: Int
    let certifiedAt: Int
    let addedTimestamp: Int64

    enum CodingKeys: String, CodingKey {
        case _id
        case driverId, driverName, vehicleId, vehicleName, trailers, shippingDocs
        case coDriverId, coDriverName, certifiedSignature, certifiedDate
        case lCertifiedDate, certifiedDateTime, certifiedAt, addedTimestamp
    }
}


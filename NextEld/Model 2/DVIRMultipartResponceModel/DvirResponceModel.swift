//
//  DvirResponceModel.swift
//  NextEld
//
//  Created by priyanshi   on 11/09/25.
//

import Foundation
import Foundation

// MARK: - DVIR Response
struct DvirResponse: Codable {
    
    let result: DvirResult?
    let arrayData: [String]? // Agar hamesha null aata hai to optional string array
    let status: String?
    let message: String?
    let token: String?
}

// MARK: - DVIR Result
struct DvirResult: Codable {
    let id: String?
    let tokenNo: String?
    let fromDate: String?
    let toDate: String?
    let email: String?
    let clientId: Int?
    let dvirLogId: String?
    let driverId: Int?
    let driverName: String?
    let dateTime: String?
    let lDateTime: Int64?
    let location: String?
    let truckDefect: [String]?
    let trailerDefect: [String]?
    let trailer: [String]?
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
    

}

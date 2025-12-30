//
//  DvirEmailModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation

// MARK: - API Request Model
struct ReportRequestModel: Codable {
    let clientId:Int
    let driverId: Int
    let fromDate: String
    let toDate: String
    let email: String
    let tokenNo: String
}


//MARK: -  response model

/*struct DVIRResponseModel: Codable {
    let result: [String]?
    let arrayData: String?
    let status: String
    let message: String
    let token: String
}*/


struct DVIRResponseModel: Codable {
    let result: [DVIREmailModel]
    let arrayData: String?
    let status: String
    let message: String
    let token: String?
}

struct DVIREmailModel: Codable, Identifiable {

    let id: String
    let driverId: Int?
    let driverName: String?
    let dateTime: String?
    let lDateTime: Int?
    let location: String?
    let trailer: [String]?
    let notes: String?
    let vehicleCondition: String?
    let driverSignFile: String?
    let companyName: String?
    let odometer: Double?
    let engineHour: String?
    let vehicleId: Int?
    let vehicleNo: String?
    let vin: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case driverId, driverName, dateTime, lDateTime, location
        case trailer, notes, vehicleCondition, driverSignFile
        case companyName, odometer, engineHour
        case vehicleId, vehicleNo, vin
    }
}

//
//  DVIRModel.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//

import Foundation
import SQLite


struct DvirRecord {
    var id: Int64?
    var driver: String
    var time: String
    var date: String
    var odometer: String
    var company: String
    var location: String
    var vehicle: String
    var trailer: String
    var truckDefect: String
    var trailerDefect: String
    var vehicleCondition: String
    var notes: String
    var signature: Data?   //  Added Signature as PNG/JPEG Data
}
import UIKit

struct DvirRecordss {
    let driverId: Int
    let dateTime: String
    let location: String
    let truckDefect: [String]
    let trailerDefect: [String]
    let notes: String
    let vehicleCondition: String
    let image: UIImage?
}

//MARK: - Request & Response Model


struct DvirResult: Codable {
    let driverId: Int
    let vehicleId: Int
    let clientId: Int
    let dateTime: String
    let location: String
    let truckDefect: [String]
    let trailerDefect: [String]
    let notes: String
    let vehicleCondition: String
    let driverSignFile: String?
    let companyName: String?
    let odometer: Double
}

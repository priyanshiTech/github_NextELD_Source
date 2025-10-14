//
//  DVIRModel.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//

import Foundation
import SQLite


//struct DvirRecord : Identifiable, Codable, Hashable, Equatable {
//    var id: Int64?
//    var driver: String
//    var time: String
//    var date: String
//    var odometer: Double
//    var company: String
//    var location: String
//    var vehicleID: String
//   // var vehicleID: Int
//    var trailer: String
//    var truckDefect: String
//    var trailerDefect: String
//    var vehicleCondition: String
//    var notes: String
//    var engineHour: Int
//    var signature: Data?   //  Added Signature as PNG/JPEG Data
//}

struct DvirRecord : Identifiable, Codable, Hashable, Equatable {
    var id: Int64?
    var UserID: String
    var UserName: String
    var startTime: String
    var DAY: String
    var Shift: String
    var DvirTime: String
    var odometer: Double?
    var location: String
    var truckDefect: String
    var trailerDefect: String
    var vehicleCondition: String
    var notes: String
    var vehicleName: String
    var vechicleID: String
    var Sync: Int
    var timestamp: String
    var Server_ID: String
    var Trailer: String
    var signature: Data?
}

//
//  DVIRModel.swift
//  NextEld
//
//  Created by priyanshi   on 26/07/25.
//

import Foundation
import SQLite


struct DvirRecord : Identifiable, Codable, Hashable, Equatable {
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


 

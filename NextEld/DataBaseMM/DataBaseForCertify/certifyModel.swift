//
//  certifyModel.swift
//  NextEld
//
//  Created by priyanshi   on 13/08/25.
//

import Foundation

struct CertifyRecord: Codable{
    
    
    var userID: String
    var userName: String
    var startTime: String
    var date: String
    var shift: Int
    var selectedVehicle: String
    var selectedTrailer: String
    var selectedShippingDoc: String
    var selectedCoDriver: String
    var vehicleID: Int?
    var coDriverID: Int?
    var signature: Data?
    var syncStatus: Int
    var isCertify: String
}

//
//  CertifySignatureModel.swift
//  NextEld
//
//  Created by priyanshi on 13/08/25.
//

import Foundation

//MARK: -  API Request Model For Certify Driver
struct CertifiedLogRequest {
    var driverId: String
    var vehicleId: String
    var coDriverId: String
    var trailers: String
    var shippingDocs: String
    var certifiedDate: String
    var fileURL: URL
    var tokenNo: String
    var certifiedDateTime: String
    var certifiedAt: String
}

//MARK: API Responce Model  For Certify Driver

struct CertifiedLogResponse: Codable {
    let message: String
    let result: String
    let status: String
    let token: String
}

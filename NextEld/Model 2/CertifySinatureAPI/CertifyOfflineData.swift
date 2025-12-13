//
//  CertifyOfflineData.swift
//  NextEld
//
//  Created by priyanshi  on 13/12/25.
//

import Foundation


//MARK: -  Request Data
struct CertifyOfflineData : Codable {
    
    let certifiedLogData : [CertifiedLogOfflineData]?
}

struct CertifiedLogOfflineData : Codable {
    
    let certifiedAt : Int?
    let certifiedDate : String?
    let certifiedDateTime : Int?
    let certifiedSignature : String?
    let coDriverId : Int?
    let driverId : Int?
    let localId : String?
    let shippingDocs : [String]?
    let trailers : [String]?
    let vehicleId : Int?

}

//MARK: -  Responce Data

struct CertifiedOfflineResponse: Codable {
    let message: String
    let result: [CertifiedOfflineResult]
    let status: String
    let token: String
}

// MARK: - Result Item
struct CertifiedOfflineResult: Codable, Identifiable {
    let localId: String
    let serverId: String

    var id: String { localId } // SwiftUI List support
}


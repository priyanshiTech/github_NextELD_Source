//
//  SupportModel.swift
//  NextEld
//
//  Created by priyanshi  on 12/08/25.
//

import Foundation
// MARK: - Request Model
struct MessageRequestSupport: Codable {
    let companyId: Int
    let driverId: Int
    let message: String
    let tokenNo: String
    let utcDateTime: Int64
    let vehicleId: Int
}
struct HelpSupportResponce  : Codable {
    let result : String?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?

   
}

// MARK: - API Request Model
struct MessageRequestSupportNew: Codable {
    let driverId: Int
    let message: String
    let companyDomainName: String

}

// MARK: - Response Model
struct HelpSupportResponceNew: Codable {
    let status: Bool
    let message: String
}


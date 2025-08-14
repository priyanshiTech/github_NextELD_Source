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

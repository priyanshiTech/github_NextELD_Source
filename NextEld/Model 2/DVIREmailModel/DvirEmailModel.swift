//
//  DvirEmailModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation

// MARK: - API Request Model
struct ReportRequestModel: Codable {
    let driverId: Int
    let fromDate: String
    let toDate: String
    let email: String
    let tokenNo: String
}


//MARK: -  response model

struct DVIRResponseModel: Codable {
    let result: [String]?
    let arrayData: String?
    let status: String
    let message: String
    let token: String
}

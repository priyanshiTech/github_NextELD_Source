//
//  DeleteModelAPI.swift
//  NextEld
//
//  Created by Priyanshi  on 22/07/25.
//

import Foundation

struct DeleteDriverResponse: Codable {    //MARK: -  Responce API
    let result: String?
    let arrayData: String?
    let status: String?
    let message: String?
    let token: String?
}


struct DeleteAllDriverStatusRequest: Encodable {    //MARK: - Request Model
    let driverId: Int
}

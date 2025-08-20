//
//  Macaddresss.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation

// MARK: - Request Model
struct AddMacAddressRequest: Codable {
    let macAddress: String
    let driverId: Int
    let tokenNo: String
    let vehicleId: Int
    let modelNo: String
    let version: String
    let serialNo: String
}

// MARK: - Response Model
struct AddMacAddressResponse: Codable {
    let result: String
    let arrayData: String?   
    let status: String
    let message: String
    let token: String
}

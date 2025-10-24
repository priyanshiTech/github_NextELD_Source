//
//  DisconnectAPIModel.swift
//  NextEld
//
//  Created by priyanshi  on 21/08/25.
//

import Foundation

// MARK: - API Request Model
struct DeviceStatusRequest: Codable {
    let driverId: Int
    let tokenNo: String
    let status: String
}

// MARK: - API Response Model
struct DeviceStatusResponse: Codable {
    let result: String
    let arrayData: [String]?  // nullable in response
    let status: String
    let message: String
    let token: String
}

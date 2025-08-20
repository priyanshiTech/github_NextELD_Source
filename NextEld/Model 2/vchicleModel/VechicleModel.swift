//
//  VechicleModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
//MARK: -  For Request Model


struct VehicleInfoRequest: Codable {
    let vehicleId: Int
    let clientId: Int
    let driverId: Int
    let tokenNo: String
}

//MARK: -  Responce Model

import Foundation

struct VehicleInfoResponse: Codable {
    let result: [VehicleResult]?
    let arrayData: String?   
    let status: String
    let message: String
    let token: String
}

struct VehicleResult: Codable, Identifiable {
    var id: Int { vehicleId }
    
    let vehicleId: Int
    let clientId: Int
    let vehicleNo: String
    let make: String
    let model: String
    let manufacturingYear: Int
    let licensePlate: String
    let countryId: Int
    let stateId: Int
    let vin: String
    let fuelTypeId: Int
    let deviceId: Int
    let deviceName: String
    let status: String
    let eldConnectionInterfaceId: Int
    let macAddress: String?
    let serialNo: String?
    let version: String?
    let modelNo: String?
    let deviceStatus: String?
    let addedTimestamp: Int64
    let updatedTimestamp: Int64
}


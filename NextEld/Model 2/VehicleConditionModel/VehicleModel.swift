//
//  VehicleModel.swift
//  NextEld
//
//  Created by priyanshi on 03/11/25.
//

import Foundation

struct VehicleModel : Codable {
    let result : [VehicleConditionResult]?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?

}
struct VehicleConditionResult : Codable {
    let vehicleConditionId : Int?
    let vehicleConditionName : String?
    let clientId : Int?
    let addedTimestamp : Int?
    let updatedTimestamp : Int?

}

//enum CodingKeys: String, CodingKey {
//
//    case vehicleConditionId = "vehicleConditionId"
//    case vehicleConditionName = "vehicleConditionName"
//    case clientId = "clientId"
//    case addedTimestamp = "addedTimestamp"
//    case updatedTimestamp = "updatedTimestamp"
//}
//
//init(from decoder: Decoder) throws {
//    let values = try decoder.container(keyedBy: CodingKeys.self)
//    vehicleConditionId = try values.decodeIfPresent(Int.self, forKey: .vehicleConditionId)
//    vehicleConditionName = try values.decodeIfPresent(String.self, forKey: .vehicleConditionName)
//    clientId = try values.decodeIfPresent(Int.self, forKey: .clientId)
//    addedTimestamp = try values.decodeIfPresent(Int.self, forKey: .addedTimestamp)
//    updatedTimestamp = try values.decodeIfPresent(Int.self, forKey: .updatedTimestamp)
//}

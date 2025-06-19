//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation
struct SplitLog : Codable {
	let dbId : Int?
	let status : String?
	let splitTiming : String?
	let driverId : Int?
	let shift : Int?
	let day : Int?
	let updatedTimestamp : Int?

	enum CodingKeys: String, CodingKey {

		case dbId = "dbId"
		case status = "status"
		case splitTiming = "splitTiming"
		case driverId = "driverId"
		case shift = "shift"
		case day = "day"
		case updatedTimestamp = "updatedTimestamp"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dbId = try values.decodeIfPresent(Int.self, forKey: .dbId)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		splitTiming = try values.decodeIfPresent(String.self, forKey: .splitTiming)
		driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
		shift = try values.decodeIfPresent(Int.self, forKey: .shift)
		day = try values.decodeIfPresent(Int.self, forKey: .day)
		updatedTimestamp = try values.decodeIfPresent(Int.self, forKey: .updatedTimestamp)
	}

}

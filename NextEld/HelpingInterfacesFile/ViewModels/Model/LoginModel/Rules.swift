//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation
struct Rules : Codable {
	let cycleTime : Int?
	let cycleDays : Int?
	let onDutyTime : Int?
	let onDriveTime : Int?
	let onSleepTime : Int?
	let continueDriveTime : Int?
	let breakTime : Int?
	let cycleRestartTime : Int?
	let warningOnDutyTime1 : Int?
	let warningOnDutyTime2 : Int?
	let warningOnDriveTime1 : Int?
	let warningOnDriveTime2 : Int?
	let warningBreakTime1 : Int?
	let warningBreakTime2 : Int?

	enum CodingKeys: String, CodingKey {

		case cycleTime = "cycleTime"
		case cycleDays = "cycleDays"
		case onDutyTime = "onDutyTime"
		case onDriveTime = "onDriveTime"
		case onSleepTime = "onSleepTime"
		case continueDriveTime = "continueDriveTime"
		case breakTime = "breakTime"
		case cycleRestartTime = "cycleRestartTime"
		case warningOnDutyTime1 = "warningOnDutyTime1"
		case warningOnDutyTime2 = "warningOnDutyTime2"
		case warningOnDriveTime1 = "warningOnDriveTime1"
		case warningOnDriveTime2 = "warningOnDriveTime2"
		case warningBreakTime1 = "warningBreakTime1"
		case warningBreakTime2 = "warningBreakTime2"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cycleTime = try values.decodeIfPresent(Int.self, forKey: .cycleTime)
		cycleDays = try values.decodeIfPresent(Int.self, forKey: .cycleDays)
		onDutyTime = try values.decodeIfPresent(Int.self, forKey: .onDutyTime)
		onDriveTime = try values.decodeIfPresent(Int.self, forKey: .onDriveTime)
		onSleepTime = try values.decodeIfPresent(Int.self, forKey: .onSleepTime)
		continueDriveTime = try values.decodeIfPresent(Int.self, forKey: .continueDriveTime)
		breakTime = try values.decodeIfPresent(Int.self, forKey: .breakTime)
		cycleRestartTime = try values.decodeIfPresent(Int.self, forKey: .cycleRestartTime)
		warningOnDutyTime1 = try values.decodeIfPresent(Int.self, forKey: .warningOnDutyTime1)
		warningOnDutyTime2 = try values.decodeIfPresent(Int.self, forKey: .warningOnDutyTime2)
		warningOnDriveTime1 = try values.decodeIfPresent(Int.self, forKey: .warningOnDriveTime1)
		warningOnDriveTime2 = try values.decodeIfPresent(Int.self, forKey: .warningOnDriveTime2)
		warningBreakTime1 = try values.decodeIfPresent(Int.self, forKey: .warningBreakTime1)
		warningBreakTime2 = try values.decodeIfPresent(Int.self, forKey: .warningBreakTime2)
	}

}

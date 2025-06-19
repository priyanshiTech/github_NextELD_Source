//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//

import Foundation
struct Result : Codable {
	let tokenNo : String?
	let status : String?
	let employeeId : Int?
	let clientId : Int?
	let mainTerminalId : Int?
	let clientName : String?
	let timezone : String?
	let timezoneOffSet : String?
	let title : String?
	let firstName : String?
	let lastName : String?
	let email : String?
	let username : String?
	let loginDateTime : Int?
	let macAddress : String?
	let vehicleId : Int?
	let vehicleNo : String?
	let isFirstLogin : String?
	let onDutyTime : Int?
	let onDriveTime : Int?
	let onSleepTime : Int?
	let continueDriveTime : Int?
	let breakTime : Int?
	let cycleRestartTime : Int?
	let exempt : String?
	let personalUse : String?
	let yardMoves : String?
	let shortHaulException : String?
	let unlimitedTrailers : String?
	let unlimitedShippingDocs : String?
	let driverLog : [DriverLog]?
	let driverDvirLog : [String]?
	let driverCertifiedLog : [String]?
	let loginLogoutLog : [LoginLogoutLog]?
	let splitLog : [SplitLog]?
	let rules : [Rules]?

	enum CodingKeys: String, CodingKey {

		case tokenNo = "tokenNo"
		case status = "status"
		case employeeId = "employeeId"
		case clientId = "clientId"
		case mainTerminalId = "mainTerminalId"
		case clientName = "clientName"
		case timezone = "timezone"
		case timezoneOffSet = "timezoneOffSet"
		case title = "title"
		case firstName = "firstName"
		case lastName = "lastName"
		case email = "email"
		case username = "username"
		case loginDateTime = "loginDateTime"
		case macAddress = "macAddress"
		case vehicleId = "vehicleId"
		case vehicleNo = "vehicleNo"
		case isFirstLogin = "isFirstLogin"
		case onDutyTime = "onDutyTime"
		case onDriveTime = "onDriveTime"
		case onSleepTime = "onSleepTime"
		case continueDriveTime = "continueDriveTime"
		case breakTime = "breakTime"
		case cycleRestartTime = "cycleRestartTime"
		case exempt = "exempt"
		case personalUse = "personalUse"
		case yardMoves = "yardMoves"
		case shortHaulException = "shortHaulException"
		case unlimitedTrailers = "unlimitedTrailers"
		case unlimitedShippingDocs = "unlimitedShippingDocs"
		case driverLog = "driverLog"
		case driverDvirLog = "driverDvirLog"
		case driverCertifiedLog = "driverCertifiedLog"
		case loginLogoutLog = "loginLogoutLog"
		case splitLog = "splitLog"
		case rules = "rules"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tokenNo = try values.decodeIfPresent(String.self, forKey: .tokenNo)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		employeeId = try values.decodeIfPresent(Int.self, forKey: .employeeId)
		clientId = try values.decodeIfPresent(Int.self, forKey: .clientId)
		mainTerminalId = try values.decodeIfPresent(Int.self, forKey: .mainTerminalId)
		clientName = try values.decodeIfPresent(String.self, forKey: .clientName)
		timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
		timezoneOffSet = try values.decodeIfPresent(String.self, forKey: .timezoneOffSet)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		loginDateTime = try values.decodeIfPresent(Int.self, forKey: .loginDateTime)
		macAddress = try values.decodeIfPresent(String.self, forKey: .macAddress)
		vehicleId = try values.decodeIfPresent(Int.self, forKey: .vehicleId)
		vehicleNo = try values.decodeIfPresent(String.self, forKey: .vehicleNo)
		isFirstLogin = try values.decodeIfPresent(String.self, forKey: .isFirstLogin)
		onDutyTime = try values.decodeIfPresent(Int.self, forKey: .onDutyTime)
		onDriveTime = try values.decodeIfPresent(Int.self, forKey: .onDriveTime)
		onSleepTime = try values.decodeIfPresent(Int.self, forKey: .onSleepTime)
		continueDriveTime = try values.decodeIfPresent(Int.self, forKey: .continueDriveTime)
		breakTime = try values.decodeIfPresent(Int.self, forKey: .breakTime)
		cycleRestartTime = try values.decodeIfPresent(Int.self, forKey: .cycleRestartTime)
		exempt = try values.decodeIfPresent(String.self, forKey: .exempt)
		personalUse = try values.decodeIfPresent(String.self, forKey: .personalUse)
		yardMoves = try values.decodeIfPresent(String.self, forKey: .yardMoves)
		shortHaulException = try values.decodeIfPresent(String.self, forKey: .shortHaulException)
		unlimitedTrailers = try values.decodeIfPresent(String.self, forKey: .unlimitedTrailers)
		unlimitedShippingDocs = try values.decodeIfPresent(String.self, forKey: .unlimitedShippingDocs)
		driverLog = try values.decodeIfPresent([DriverLog].self, forKey: .driverLog)
		driverDvirLog = try values.decodeIfPresent([String].self, forKey: .driverDvirLog)
		driverCertifiedLog = try values.decodeIfPresent([String].self, forKey: .driverCertifiedLog)
		loginLogoutLog = try values.decodeIfPresent([LoginLogoutLog].self, forKey: .loginLogoutLog)
		splitLog = try values.decodeIfPresent([SplitLog].self, forKey: .splitLog)
		rules = try values.decodeIfPresent([Rules].self, forKey: .rules)
	}

}

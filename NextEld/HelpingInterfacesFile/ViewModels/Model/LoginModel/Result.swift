//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//

import Foundation


struct Result : Decodable {
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




}

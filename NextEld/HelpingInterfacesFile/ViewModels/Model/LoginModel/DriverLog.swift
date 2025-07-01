//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation
/*struct DriverLog : Codable {
	let _id : String?
	let certifiedLogId : String?
	let statusId : Int?
	let driverId : Int?
	let clientId : Int?
	let companyDriverId : String?
	let driverName : String?
	let cdlNo : String?
	let countryName : String?
	let stateName : String?
	let exempt : String?
	let companyCoDriverId : String?
	let coDriverId : Int?
	let coDriverName : String?
	let trailers : [String]?
	let shippingDocs : [String]?
	let certifiedSignature : String?
	let certifiedSignatureName : String?
	let exception : String?
	let email : String?
	let mobileNo : Int?
	let status : String?
	let vehicleId : Int?
	let truckNo : String?
	let vin : String?
	let macAddress : String?
	let serialNo : String?
	let version : String?
	let modelNo : String?
	let lattitude : Double?
	let longitude : Double?
	let dateTime : String?
	let lDateTime : Int?
	let utcDateTime : Int?
	let fromDate : Int?
	let toDate : Int?
	let receivedTimestamp : Int?
	let logType : String?
	let appVersion : String?
	let osVersion : String?
	let simCardNo : String?
	let isVoilation : Int?
	let note : String?
	let customLocation : String?
	let engineHour : String?
	let engineStatus : String?
	let origin : String?
	let odometer : Double?
	let carrier : String?
	let mainOffice : String?
	let mainTerminalName : String?
	let dotNo : String?
	let companyName : String?
	let cycleUsaName : String?
	let eldProvider : String?
	let diagnosticIndicator : String?
	let malfunctionIndicator : String?
	let eldRegistrationId : String?
	let eldIdentifier : String?
	let periodStartingTime : String?
	let timezone : String?
	let timezoneName : String?
	let timezoneOffSet : String?
	let remainingWeeklyTime : String?
	let remainingDutyTime : String?
	let remainingDriveTime : String?
	let remainingSleepTime : String?
	let shift : Int?
	let days : Int?
	let isSplit : Int?
	let identifier : Int?
	let onDutyTime : String?
	let onDriveTime : String?
	let onSleepTime : String?
	let lastOnSleepTime : String?
	let weeklyTime : String?
	let onBreak : String?
	let distance : Double?
	let isReportGenerated : Int?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case certifiedLogId = "certifiedLogId"
		case statusId = "statusId"
		case driverId = "driverId"
		case clientId = "clientId"
		case companyDriverId = "companyDriverId"
		case driverName = "driverName"
		case cdlNo = "cdlNo"
		case countryName = "countryName"
		case stateName = "stateName"
		case exempt = "exempt"
		case companyCoDriverId = "companyCoDriverId"
		case coDriverId = "coDriverId"
		case coDriverName = "coDriverName"
		case trailers = "trailers"
		case shippingDocs = "shippingDocs"
		case certifiedSignature = "certifiedSignature"
		case certifiedSignatureName = "certifiedSignatureName"
		case exception = "exception"
		case email = "email"
		case mobileNo = "mobileNo"
		case status = "status"
		case vehicleId = "vehicleId"
		case truckNo = "truckNo"
		case vin = "vin"
		case macAddress = "macAddress"
		case serialNo = "serialNo"
		case version = "version"
		case modelNo = "modelNo"
		case lattitude = "lattitude"
		case longitude = "longitude"
		case dateTime = "dateTime"
		case lDateTime = "lDateTime"
		case utcDateTime = "utcDateTime"
		case fromDate = "fromDate"
		case toDate = "toDate"
		case receivedTimestamp = "receivedTimestamp"
		case logType = "logType"
		case appVersion = "appVersion"
		case osVersion = "osVersion"
		case simCardNo = "simCardNo"
		case isVoilation = "isVoilation"
		case note = "note"
		case customLocation = "customLocation"
		case engineHour = "engineHour"
		case engineStatus = "engineStatus"
		case origin = "origin"
		case odometer = "odometer"
		case carrier = "carrier"
		case mainOffice = "mainOffice"
		case mainTerminalName = "mainTerminalName"
		case dotNo = "dotNo"
		case companyName = "companyName"
		case cycleUsaName = "cycleUsaName"
		case eldProvider = "eldProvider"
		case diagnosticIndicator = "diagnosticIndicator"
		case malfunctionIndicator = "malfunctionIndicator"
		case eldRegistrationId = "eldRegistrationId"
		case eldIdentifier = "eldIdentifier"
		case periodStartingTime = "periodStartingTime"
		case timezone = "timezone"
		case timezoneName = "timezoneName"
		case timezoneOffSet = "timezoneOffSet"
		case remainingWeeklyTime = "remainingWeeklyTime"
		case remainingDutyTime = "remainingDutyTime"
		case remainingDriveTime = "remainingDriveTime"
		case remainingSleepTime = "remainingSleepTime"
		case shift = "shift"
		case days = "days"
		case isSplit = "isSplit"
		case identifier = "identifier"
		case onDutyTime = "onDutyTime"
		case onDriveTime = "onDriveTime"
		case onSleepTime = "onSleepTime"
		case lastOnSleepTime = "lastOnSleepTime"
		case weeklyTime = "weeklyTime"
		case onBreak = "onBreak"
		case distance = "distance"
		case isReportGenerated = "isReportGenerated"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		certifiedLogId = try values.decodeIfPresent(String.self, forKey: .certifiedLogId)
		statusId = try values.decodeIfPresent(Int.self, forKey: .statusId)
		driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
		clientId = try values.decodeIfPresent(Int.self, forKey: .clientId)
		companyDriverId = try values.decodeIfPresent(String.self, forKey: .companyDriverId)
		driverName = try values.decodeIfPresent(String.self, forKey: .driverName)
		cdlNo = try values.decodeIfPresent(String.self, forKey: .cdlNo)
		countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
		stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
		exempt = try values.decodeIfPresent(String.self, forKey: .exempt)
		companyCoDriverId = try values.decodeIfPresent(String.self, forKey: .companyCoDriverId)
		coDriverId = try values.decodeIfPresent(Int.self, forKey: .coDriverId)
		coDriverName = try values.decodeIfPresent(String.self, forKey: .coDriverName)
		trailers = try values.decodeIfPresent([String].self, forKey: .trailers)
		shippingDocs = try values.decodeIfPresent([String].self, forKey: .shippingDocs)
		certifiedSignature = try values.decodeIfPresent(String.self, forKey: .certifiedSignature)
		certifiedSignatureName = try values.decodeIfPresent(String.self, forKey: .certifiedSignatureName)
		exception = try values.decodeIfPresent(String.self, forKey: .exception)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		mobileNo = try values.decodeIfPresent(Int.self, forKey: .mobileNo)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		vehicleId = try values.decodeIfPresent(Int.self, forKey: .vehicleId)
		truckNo = try values.decodeIfPresent(String.self, forKey: .truckNo)
		vin = try values.decodeIfPresent(String.self, forKey: .vin)
		macAddress = try values.decodeIfPresent(String.self, forKey: .macAddress)
		serialNo = try values.decodeIfPresent(String.self, forKey: .serialNo)
		version = try values.decodeIfPresent(String.self, forKey: .version)
		modelNo = try values.decodeIfPresent(String.self, forKey: .modelNo)
		lattitude = try values.decodeIfPresent(Double.self, forKey: .lattitude)
		longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
		dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
		lDateTime = try values.decodeIfPresent(Int.self, forKey: .lDateTime)
		utcDateTime = try values.decodeIfPresent(Int.self, forKey: .utcDateTime)
		fromDate = try values.decodeIfPresent(Int.self, forKey: .fromDate)
		toDate = try values.decodeIfPresent(Int.self, forKey: .toDate)
		receivedTimestamp = try values.decodeIfPresent(Int.self, forKey: .receivedTimestamp)
		logType = try values.decodeIfPresent(String.self, forKey: .logType)
		appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion)
		osVersion = try values.decodeIfPresent(String.self, forKey: .osVersion)
		simCardNo = try values.decodeIfPresent(String.self, forKey: .simCardNo)
		isVoilation = try values.decodeIfPresent(Int.self, forKey: .isVoilation)
		note = try values.decodeIfPresent(String.self, forKey: .note)
		customLocation = try values.decodeIfPresent(String.self, forKey: .customLocation)
		engineHour = try values.decodeIfPresent(String.self, forKey: .engineHour)
		engineStatus = try values.decodeIfPresent(String.self, forKey: .engineStatus)
		origin = try values.decodeIfPresent(String.self, forKey: .origin)
		odometer = try values.decodeIfPresent(Double.self, forKey: .odometer)
		carrier = try values.decodeIfPresent(String.self, forKey: .carrier)
		mainOffice = try values.decodeIfPresent(String.self, forKey: .mainOffice)
		mainTerminalName = try values.decodeIfPresent(String.self, forKey: .mainTerminalName)
		dotNo = try values.decodeIfPresent(String.self, forKey: .dotNo)
		companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
		cycleUsaName = try values.decodeIfPresent(String.self, forKey: .cycleUsaName)
		eldProvider = try values.decodeIfPresent(String.self, forKey: .eldProvider)
		diagnosticIndicator = try values.decodeIfPresent(String.self, forKey: .diagnosticIndicator)
		malfunctionIndicator = try values.decodeIfPresent(String.self, forKey: .malfunctionIndicator)
		eldRegistrationId = try values.decodeIfPresent(String.self, forKey: .eldRegistrationId)
		eldIdentifier = try values.decodeIfPresent(String.self, forKey: .eldIdentifier)
		periodStartingTime = try values.decodeIfPresent(String.self, forKey: .periodStartingTime)
		timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
		timezoneName = try values.decodeIfPresent(String.self, forKey: .timezoneName)
		timezoneOffSet = try values.decodeIfPresent(String.self, forKey: .timezoneOffSet)
		remainingWeeklyTime = try values.decodeIfPresent(String.self, forKey: .remainingWeeklyTime)
		remainingDutyTime = try values.decodeIfPresent(String.self, forKey: .remainingDutyTime)
		remainingDriveTime = try values.decodeIfPresent(String.self, forKey: .remainingDriveTime)
		remainingSleepTime = try values.decodeIfPresent(String.self, forKey: .remainingSleepTime)
		shift = try values.decodeIfPresent(Int.self, forKey: .shift)
		days = try values.decodeIfPresent(Int.self, forKey: .days)
		isSplit = try values.decodeIfPresent(Int.self, forKey: .isSplit)
		identifier = try values.decodeIfPresent(Int.self, forKey: .identifier)
		onDutyTime = try values.decodeIfPresent(String.self, forKey: .onDutyTime)
		onDriveTime = try values.decodeIfPresent(String.self, forKey: .onDriveTime)
		onSleepTime = try values.decodeIfPresent(String.self, forKey: .onSleepTime)
		lastOnSleepTime = try values.decodeIfPresent(String.self, forKey: .lastOnSleepTime)
		weeklyTime = try values.decodeIfPresent(String.self, forKey: .weeklyTime)
		onBreak = try values.decodeIfPresent(String.self, forKey: .onBreak)
		distance = try values.decodeIfPresent(Double.self, forKey: .distance)
		isReportGenerated = try values.decodeIfPresent(Int.self, forKey: .isReportGenerated)
	}

}*/



struct DriverLog: Decodable {
    let _id: String?
    let vehicleId: Int?
    let driverId: Int?
    let status: String?
    let dateTime: String?
    let utcDateTime: Int64?
    let lastUtcDateTime: Int64?
    let employeeStatus: String?
    let lattitude: Double?
    let longitude: Double?
    let customLocation: String?
    let origin: String?
    let odometer: Double?
    let engineHour: String?
    let note: String?
    let isVoilation: Int?
    let logType: String?
    let statusId: Int?
    let remainingWeeklyTime: String?
    let remainingDutyTime: String?
    let remainingDriveTime: String?
    let remainingSleepTime: String?
    let shift: Int?
    let days: Int?
    let identifier: Int?
    let lastOnSleepTime: String?
    let truckNo: String?
    let trailers: [String]?
}

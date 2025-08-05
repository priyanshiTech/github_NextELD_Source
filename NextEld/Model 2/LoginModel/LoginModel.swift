//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//

import Foundation
struct LoginLogoutLog : Codable {
    let _id : String?
    let vehicleId : Int?
    let driverId : Int?
    let driverStatusId : String?
    let driverName : String?
    let dateTime : String?
    let utcDateTime : Int?
    let lastUtcDateTime : Int?
    let status : String?
    let employeeStatus : String?
    let lattitude : Double?
    let longitude : Double?
    let customLocation : String?
    let origin : String?
    let odometer : Double?
    let engineHour : String?
    let note : String?
    let isVoilation : Int?
    let logType : String?
    let statusId : Int?
    let remainingWeeklyTime : String?
    let remainingDutyTime : String?
    let remainingDriveTime : String?
    let remainingSleepTime : String?
    let shift : Int?
    let days : Int?
    let isReportGenerated : Int?
    let totalSeconds : Int?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case vehicleId = "vehicleId"
        case driverId = "driverId"
        case driverStatusId = "driverStatusId"
        case driverName = "driverName"
        case dateTime = "dateTime"
        case utcDateTime = "utcDateTime"
        case lastUtcDateTime = "lastUtcDateTime"
        case status = "status"
        case employeeStatus = "employeeStatus"
        case lattitude = "lattitude"
        case longitude = "longitude"
        case customLocation = "customLocation"
        case origin = "origin"
        case odometer = "odometer"
        case engineHour = "engineHour"
        case note = "note"
        case isVoilation = "isVoilation"
        case logType = "logType"
        case statusId = "statusId"
        case remainingWeeklyTime = "remainingWeeklyTime"
        case remainingDutyTime = "remainingDutyTime"
        case remainingDriveTime = "remainingDriveTime"
        case remainingSleepTime = "remainingSleepTime"
        case shift = "shift"
        case days = "days"
        case isReportGenerated = "isReportGenerated"
        case totalSeconds = "totalSeconds"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        vehicleId = try values.decodeIfPresent(Int.self, forKey: .vehicleId)
        driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
        driverStatusId = try values.decodeIfPresent(String.self, forKey: .driverStatusId)
        driverName = try values.decodeIfPresent(String.self, forKey: .driverName)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
        utcDateTime = try values.decodeIfPresent(Int.self, forKey: .utcDateTime)
        lastUtcDateTime = try values.decodeIfPresent(Int.self, forKey: .lastUtcDateTime)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        employeeStatus = try values.decodeIfPresent(String.self, forKey: .employeeStatus)
        lattitude = try values.decodeIfPresent(Double.self, forKey: .lattitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        customLocation = try values.decodeIfPresent(String.self, forKey: .customLocation)
        origin = try values.decodeIfPresent(String.self, forKey: .origin)
        odometer = try values.decodeIfPresent(Double.self, forKey: .odometer)
        engineHour = try values.decodeIfPresent(String.self, forKey: .engineHour)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        isVoilation = try values.decodeIfPresent(Int.self, forKey: .isVoilation)
        logType = try values.decodeIfPresent(String.self, forKey: .logType)
        statusId = try values.decodeIfPresent(Int.self, forKey: .statusId)
        remainingWeeklyTime = try values.decodeIfPresent(String.self, forKey: .remainingWeeklyTime)
        remainingDutyTime = try values.decodeIfPresent(String.self, forKey: .remainingDutyTime)
        remainingDriveTime = try values.decodeIfPresent(String.self, forKey: .remainingDriveTime)
        remainingSleepTime = try values.decodeIfPresent(String.self, forKey: .remainingSleepTime)
        shift = try values.decodeIfPresent(Int.self, forKey: .shift)
        days = try values.decodeIfPresent(Int.self, forKey: .days)
        isReportGenerated = try values.decodeIfPresent(Int.self, forKey: .isReportGenerated)
        totalSeconds = try values.decodeIfPresent(Int.self, forKey: .totalSeconds)
    }

}
//MARK: Refresh APi Model


struct EmployeeToken: Codable {
    let employeeId: Int
    let tokenNo: String
}


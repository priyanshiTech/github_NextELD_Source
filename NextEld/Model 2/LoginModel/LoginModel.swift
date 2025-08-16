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

}
//MARK: Refresh APi Model


struct EmployeeToken: Codable {
    let employeeId: Int
    let tokenNo: String
}


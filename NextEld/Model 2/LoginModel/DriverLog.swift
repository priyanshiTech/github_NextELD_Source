//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation
struct DriverLog: Decodable {
    let _id: String?
    let vehicleId: Int?
    let driverId: Int?
    let driverName: String?
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
    let remainingWeeklyTime: Int?
    let remainingDutyTime: Int?
    let remainingDriveTime: Int?
    let remainingSleepTime: Int?
    let shift: Int?
    let days: Int?
    let identifier: Int?
    let lastOnSleepTime: Int?
    let truckNo: String?
    let trailers: [String]?
}

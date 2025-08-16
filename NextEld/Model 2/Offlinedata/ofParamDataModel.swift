//
//  ofParamDataModel.swift
//  NextEld
//
//  Created by priyanshi   on 17/07/25.
//

import Foundation
import Foundation

// MARK: - Main API Request Body




struct SyncRequest: Codable {
    let eldLogData: [String]
    let driveringStatusData: [DriveringStatusData]
    let splitLog: SplllitLogss
}

struct DriveringStatusData: Codable {
    let appVersion: String
    let clientId: Int
    let currentLocation: String
    let customLocation: String
    let dateTime: String
    let days: Int
    let driverId: Int
    let engineHour: String
    let engineStatus: String
    let identifier: Int
    let isSplit: Int
    let isVoilation: Int
    let lastOnSleepTime: Int
    let lattitude: Double
    let localId: String
    let logType: String
    let longitude: Double
    let note: String
    let odometer: Int
    let origin: String
    let osVersion: String
    let remainingDriveTime: Int
    let remainingDutyTime: Int
    let remainingSleepTime: Int
    let remainingWeeklyTime: Int
    let shift: Int
    let status: String
    let utcDateTime: Int64
    let vehicleId: Int
}


struct SplllitLogss: Codable {
    let day: Int
    let dbId: Int
    let driverId: Int
    let shift: Int
}

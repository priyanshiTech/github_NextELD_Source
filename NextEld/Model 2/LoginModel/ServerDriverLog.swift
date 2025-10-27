//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation
struct ServerDriverLog: Decodable {
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
    let remainingWeeklyTime: String?
    let remainingDutyTime: String?
    let remainingDriveTime: String?
    let remainingSleepTime: String?
    let breaktimerRemaning: Int?
    let shift: Int?
    let days: Int?
    let identifier: Int?
    let lastOnSleepTime: String?
    let truckNo: String?
    let trailers: [String]?
    
    // Add other fields from API response as optional
    let certifiedLogId: String?
    let clientId: Int?
    let companyDriverId: String?
    let cdlNo: String?
    let countryName: String?
    let stateName: String?
    let exempt: String?
    let shortHaulException: String?
    let companyCoDriverId: String?
    let coDriverId: Int?
    let coDriverName: String?
    let shippingDocs: [String]?
    let certifiedSignature: String?
    let certifiedSignatureName: String?
    let exception: String?
    let email: String?
    let mobileNo: Int?
    let isSystemGenerated: Int?
    let vin: String?
    let macAddress: String?
    let serialNo: String?
    let version: String?
    let modelNo: String?
    let lDateTime: Int64?
    let fromDate: Int64?
    let toDate: Int64?
    let receivedTimestamp: Int64?
    let appVersion: String?
    let osVersion: String?
    let simCardNo: String?
    let startEngineHour: String?
    let endEngineHour: String?
    let engineStatus: String?
    let startOdometer: Double?
    let endOdometer: Double?
    let carrier: String?
    let mainOffice: String?
    let mainTerminalName: String?
    let dotNo: String?
    let companyName: String?
    let cycleUsaName: String?
    let eldProvider: String?
    let diagnosticIndicator: String?
    let malfunctionIndicator: String?
    let eldRegistrationId: String?
    let eldIdentifier: String?
    let periodStartingTime: String?
    let timezone: String?
    let timezoneName: String?
    let timezoneOffSet: String?
    let onDutyTime: String?
    let onDriveTime: String?
    let onSleepTime: String?
    let weeklyTime: String?
    let onBreak: String?
    let unidentifiedLog: String?
    let distance: Double?
    let isReportGenerated: Int?
    let isPreviousLog: Int?
    let isSplit: Int?
}

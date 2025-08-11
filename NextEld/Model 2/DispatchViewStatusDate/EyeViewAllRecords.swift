//
//  EyeViewAllRecords.swift
//  NextEld
//
//  Created by Priyanshi  on 11/08/25.
//






/*struct DriverStatusResponse: Codable {
    let result: [DriverStatus]?
    let arrayData: [String]?
    let status: String?
    let message: String?
}

struct DriverStatus: Codable {
    let driverName: String?
    let email: String?
    let cdlNo: String?
    let stateName: String?
    let exempt: String?
    let isSystemGenerated: Int?
    let coDriverName: String?
    let companyCoDriverId: String?
    let dateTime: String?
    let customLocation: String?
    let certifiedSignatureName: String?
    let eldRegistrationId: String?
    let eldIdentifier: String?
    let eldProvider: String?
    let periodStartingTime: String?
    let diagnosticIndicator: String?
    let malfunctionIndicator: String?
    let truckNo: String?
    let vin: String?
    let odometer: Double?
    let distance: Double?
    let trailers: [String]?
    let shippingDocs: [String]?
    let carrier: String?
    let mainOffice: String?
    let engineHour: String?
    let mainTerminalName: String?
    let version: String?
    let status: String?
    let origin: String?
    let engineStatus: String?
    let note: String?
}*/
























import Foundation

struct DriverStatusResponse : Codable  {

    let result : [DriverStatus]?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?
}

// MARK: - responce Model
struct DriverStatus : Codable {
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
    let isSystemGenerated : Int?
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
    let isPreviousLog : Int?
  
}


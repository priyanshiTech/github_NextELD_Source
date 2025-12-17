//
//  TokenModelLog.swift
//  NextEld
//
//  Created by priyanshi on 18/06/25.
//

import Foundation


struct TokenModelLog: Decodable {
   // let result:TokenResult?
    let result:TokenResult?
    let arrayData: [String]?  // API response has arrayData field
    let status: String?
    let message: String?
    let token: String?
}

struct TokenResult: Decodable {
    
    let tokenNo : String?
    let disclaimerRead: Int?
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
  //  let driveringStatusData: [DriveringStatusData]
    let driverLog: [ServerDriverLog]?
    let driverDvirLog: [DvirLogItem]?  // API response has driverDvirLog array
    let driverCertifiedLog: [DriverCertifiedLog]?
    let loginLogoutLog: [LoginLogoutLog]?
    let splitLog: [SplitLog]?
    let rules: [Rules]?
    
    // Additional fields from API response
    let androidVersion: String?
    let androidCode: String?
    let iosVersion: String?
    let iosCode: String?
    let termsAndCondition: String?
    let disclaimer: String?
}

// MARK: - DvirLogItem for driverDvirLog array
struct DvirLogItem: Decodable {
    let _id: String?
    let tokenNo: String?
    let fromDate: String?
    let toDate: String?
    let email: String?
    let clientId: Int?
    let dvirLogId: String?
    let driverId: Int?
    let driverName: String?
    let dateTime: String?
    let lDateTime: Int64?
    let location: String?
    let truckDefect: [String]?
    let trailerDefect: [String]?
    let trailer: [String]?
    let truckDefectImage: String?
    let trailerDefectImage: String?
    let notes: String?
    let vehicleCondition: String?
    let driverSignFile: String?
    let companyName: String?
    let odometer: Double?
    let engineHour: String?
    let vehicleId: Int?
    let vehicleNo: String?
    let vin: String?
    let timezoneName: String?
    let timezoneOffSet: String?
    let timestamp: String?
    let receivedTimestamp: Int64?
}




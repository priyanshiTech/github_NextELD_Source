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
    let status: String?
    let message: String?
    let token: String?
}

struct TokenResult: Decodable {
    
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
 //   let driveringStatusData: [DriveringStatusData]
    let driverLog: [DriverLog]?
    let loginLogoutLog: [LoginLogoutLog]?
    let splitLog: [SplitLog]?
    let rules: [Rules]?
}




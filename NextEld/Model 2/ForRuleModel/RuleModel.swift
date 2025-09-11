//
//  RuleModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
//MARK: Request Model
struct EmployeeRulesRequest: Codable {
    let employeeId: Int
    let clientId: Int
    let tokenNo: String
}
//MARK: -  Responce Model

import Foundation

// MARK: - Top Level Response
struct EmployViewStatusResponse: Codable {
    let result: [EmployeeRule]
    let arrayData: String?
    let status: String
    let message: String
    let token: String
}

// MARK: - Employee Rule
struct EmployeeRule: Codable, Identifiable {
    let employeeId: Int
    let title: String?
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let status: String
    let deviceStatus: String?
    let driverId: String
    let password: String
    let restartId: Int
    let restartName: [String]
    let restBreakId: Int
    let restBreakName: [String]
    let shortHaulException: String
    let unlimitedTrailers: String
    let unlimitedShippingDocs: String
    let companyId: Int
    let languageId: Int
    let clientId: Int
    let clientName: [String]
    let startTime: String
    let appVersion: String?   // changed
    let osVersion: String?    //  changed
    let simCardNo: String?
    let cycleUsaId: Int
    let cycleUsaName: [String]
    let cycleCanadaId: Int
    let cycleCanadaName: [String]
    let mainTerminalId: Int
    let mainTerminalName: [String]
    let mobileNo: Int
    let cdlNo: String
    let cdlCountryId: Int
    let countryName: [String]
    let cdlStateId: Int
    let stateName: [String]
    let cdlExpiryDate: String
    let lCdlExpiryDate: Int
    let pdfEmail: String
    let flatRate: Double
    let exempt: String
    let personalUse: String
    let yardMoves: String
    let divR: String
    let cargoTypeId: Int
    let cargoTypeName: [String]
    let truckNo: Int
    let vehicleNo: [String]
    let manageEquipement: String
    let transferLog: String
    let remarks: String
    let workingStatus: String
    let onDutyTime: String?
    let onDriveTime: String?
    let onSleepTime: String?
    let weeklyTime: String?
    let onBreak: String?
    let addedTimestamp: Int64
    let updatedTimestamp: Int64
    let currentLocation: String?
    let timezoneName: String?
    let timezoneOffSet: String?
    
    var id: Int { employeeId }
}











































/*struct EmployeeResponse: Codable {
    let result: [EmployeeRuleResult]
    let arrayData: String?
    let status: String
    let message: String
    let token: String
}

struct EmployeeRuleResult: Codable, Identifiable {
    var id: UUID { UUID() }  // for SwiftUI list
    
    let employeeId: Int
    let title: String?
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let status: String
    let deviceStatus: String?
    let driverId: String
    let password: String
    let restartId: Int
    let restartName: [String]
    let restBreakId: Int
    let restBreakName: [String]
    let shortHaulException: String
    let unlimitedTrailers: String
    let unlimitedShippingDocs: String
    let companyId: Int
    let languageId: Int
    let clientId: Int
    let clientName: [String]
    let startTime: String
    let appVersion: String
    let osVersion: String
    let simCardNo: String?
    let cycleUsaId: Int
    let cycleUsaName: [String]
    let cycleCanadaId: Int
    let cycleCanadaName: [String]
    let mainTerminalId: Int
    let mainTerminalName: [String]
    let mobileNo: Int
    let cdlNo: String
    let cdlCountryId: Int
    let countryName: [String]
    let cdlStateId: Int
    let stateName: [String]
    let cdlExpiryDate: String
    let lCdlExpiryDate: Int
    let pdfEmail: String
    let flatRate: Double
    let exempt: String
    let personalUse: String
    let yardMoves: String
    let divR: String
    let cargoTypeId: Int
    let cargoTypeName: [String]
    let truckNo: Int
    let vehicleNo: Int
    let manageEquipement: String
    let transferLog: String
    let remarks: String
    let workingStatus: String
    let onDutyTime: String?
    let onDriveTime: String?
    let onSleepTime: String?
    let weeklyTime: String?
    let onBreak: String?
    let addedTimestamp: Int64
    let updatedTimestamp: Int64
    let currentLocation: String?
    let timezoneName: String?
    let timezoneOffSet: String?
}*/


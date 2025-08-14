//
//  CompanyInfo.swift
//  NextEld
//
//  Created by priyanshi   on 11/08/25.
//

import Foundation

struct Company : Codable {
    
    let result : [CompanyInformation]?
    let arrayData : String?
    let status : String?
    let message : String?
    let token : String?

}

struct CompanyInformation : Codable {
    let employeeId : Int?
    let title : String?
    let firstName : String?
    let lastName : String?
    let email : String?
    let status : String?
    let mobileNo : Int?
    let cdlNo : String?
    let companyId : Int?
    let companyName : String?
    let clientId : Int?
    let mainTerminalId : Int?
    let mainOfficeAddress : String?
    let homeTerminalAddress : String?
    let timeZone : String?
    let languageId : Int?
    let languageName : String?
    let odometer : Int?
    let cdlStateId : Int?
    let cdlStateName : String?

  
}

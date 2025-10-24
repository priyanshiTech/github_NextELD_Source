//
//  LogOutModel.swift
//  NextEld
//
//  Created by priyanshi  on 18/08/25.
//

import Foundation

struct LogoutRequestModel: Codable {
    let employeeId: Int
    let loginDateTime: Int64
    let tokenNo: String
    let logoutDateTime: Int64
}


//MARK: -  logout responce model


struct LogoutResponse: Codable {
    let result: LogoutResult?
    let arrayData: [String]?  // since it's null, can also be optional
    let status: String?
    let message: String?
    let token: String?
}

struct LogoutResult: Codable {
    let username: String?
    let password: String?
    let dateTime: String?
    let mobileNo: Int?
    let email: String?
    let employeeId: Int?
    let tokenNo: String?
    let loginDateTime: Int64?
    let logoutDateTime: Int64?
    let mobileDeviceId: String?
    let isCoDriver: Bool?
}


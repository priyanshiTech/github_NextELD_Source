//
//  forgetUserNmeModel.swift
//  NextEld
//
//  Created by Priyanshi   on 02/07/25.
//

import Foundation
struct ForgetUsernameResult: Codable {
    let username: String
    let password: String
    let dateTime: String
    let mobileNo: Int
    let email: String
    let employeeId: Int
    let tokenNo: String?
    let loginDateTime: Int
    let logoutDateTime: Int
    let mobileDeviceId: String?
    let isCoDriver: String?
}
struct ForgetUsernameResponse: Codable {
    let result: ForgetUsernameResult?
    let arrayData: String?
    let status: String
    let message: String
    let token: String?
}

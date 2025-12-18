//
//  loginLogModel.swift
//  NextEld
//
//  Created by priyanshi   on 18/08/25.
//

import Foundation
//Request Model 
struct LoginLogRequestModel: Codable {
    let driverId: Int
    let loginDateTime: Int
    let timestamp: Int
}



//MARK:  responce Model
struct LoginLogResponce: Codable {
    
    let result: String?
    let arrayData: [String]?
    let status: String?
    let message: String?
    let token: String?
}




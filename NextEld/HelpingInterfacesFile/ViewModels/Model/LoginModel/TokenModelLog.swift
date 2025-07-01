//
//  TokenModelLog.swift
//  NextEld
//
//  Created by priyanshi on 18/06/25.
//

import Foundation


struct TokenModelLog: Decodable {
    let result: TokenResult?
    let status: String?
    let message: String?
    let token: String?
}

struct TokenResult: Decodable {
    let driverLog: [DriverLog]?
    let splitLog: [SplitLog]?
    let rules: [Rules]?
}


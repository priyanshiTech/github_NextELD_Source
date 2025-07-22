//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation
struct SplitLog: Decodable {
    let dbId: Int?
    let status: String?
    let splitTiming: String?
    let driverId: Int?
    let shift: Int?
    let day: Int?
    let updatedTimestamp: Int64?
}

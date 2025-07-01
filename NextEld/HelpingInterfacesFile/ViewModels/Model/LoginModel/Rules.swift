//
//  LoginModel.swift
//  NextEld
//  Created by Priyanshi on 18/06/25.
//


import Foundation

struct Rules: Decodable {
    let cycleTime: Int?
    let cycleDays: Int?
    let onDutyTime: Int?
    let onDriveTime: Int?
    let onSleepTime: Int?
    let continueDriveTime: Int?
    let breakTime: Int?
    let cycleRestartTime: Int?
    let warningOnDutyTime1: Int?
    let warningOnDutyTime2: Int?
    let warningOnDriveTime1: Int?
    let warningOnDriveTime2: Int?
    let warningBreakTime1: Int?
    let warningBreakTime2: Int?
}

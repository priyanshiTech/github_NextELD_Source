//
//  WorkingDriveModel.swift
//  NextEld
//
//  Created by priyanshi   on 13/11/25.
//

import Foundation
import SwiftUI

struct ELDStatusRequest: Codable {
    let driverId: Int
    let shift: Int
    let days: Int
    let status: String
    let onDutyTime: String
    let onDriveTime: String
    let onSleepTime: String
    let weeklyTime: String
    let tokenNo: String
    let onBreak: String
}


struct ELDStatusResponse: Codable {
    let result: String
    let arrayData: String?   // null in response, so optional
    let status: String
    let message: String
    let token: String
}


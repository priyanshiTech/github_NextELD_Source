//
//  GlobalVariableclass.swift
//  NextEld
//
//  Created by priyanshi on 16/08/25.
//

import Foundation
import Foundation

struct DriverStatusConstants {
    
    static let onDuty = "OnDuty"
    static let onDrive = "OnDrive"
    static let onSleep = "OnSleep"
    static let weeklyCycle = "Weekly"
    static let offDuty = "OffDuty"
    static let personalUse = "PersonalUse"
    static let yardMove = "YardMove"
    
}

struct CurrentTimeHelperStamp {
    static var currentTimestamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

// MARK: - Timestamp Utility
struct TimeUtils {
    
    // Returns the current UTC timestamp in milliseconds
    static func currentUTCTimestamp() -> Int64 {
        let now = Date()
        return Int64(now.timeIntervalSince1970 * 1000)
    }
    // Converts a timezone offset string (e.g., "+05:30" or "-07:00") into milliseconds
    static func offsetMilliseconds(from offset: String) -> Int64 {
        let parts = offset.split(separator: ":")
        guard parts.count == 2,
              let hours = Int(parts[0].replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")),
              let minutes = Int(parts[1]) else {
            return 0
        }
        let totalSeconds = (hours * 3600) + (minutes * 60)
        return Int64(totalSeconds * 1000)
    }
    
    // Returns the adjusted timestamp based on UTC + offset
    static func currentTimestamp(with offset: String) -> Int64 {
        let utcMillis = currentUTCTimestamp()
        let offsetMillis = offsetMilliseconds(from: offset)
        if offset.starts(with: "-") {
            return utcMillis - offsetMillis
        } else {
            return utcMillis + offsetMillis
        }
    }
}

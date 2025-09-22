//
//  CurrentDT.swift
//  NextEld
//
//  Created by priyanshi   on 02/08/25.
//

import Foundation

struct DateTimeHelper {
    static func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }

    static func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    static func currentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
// MARK: - FOR STRING FUNCTION
func stringToInt(_ value: String?, fallback: Int) -> Int {
    if let value = value, let intValue = Int(value) {
        return intValue
    }
    return fallback
}


//MARK: -  dateTime Helper for voilation

struct DateTimeHelperVoilation {
    /// Returns formatted local and GMT time strings for the given date (default: now)
    static func getLocalAndGMT(from date: Date = Date()) -> (local: String, gmt: String) {
        
        // Local time formatter
        let localFormatter = DateFormatter()
        localFormatter.dateStyle = .medium
        localFormatter.timeStyle = .short
        let localString = localFormatter.string(from: date)
        
        // GMT/UTC time formatter
        let gmtFormatter = DateFormatter()
        gmtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'GMT'"
        gmtFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let gmtString = gmtFormatter.string(from: date)
        
        return (localString, gmtString)
    }
}


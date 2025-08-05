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

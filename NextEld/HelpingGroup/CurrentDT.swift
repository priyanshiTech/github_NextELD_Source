//
//  CurrentDT.swift
//  NextEld
//
//  Created by priyanshi   on 02/08/25.
//

import Foundation

enum DateFormatterConstants: String {
    
    case defaultDateTime = "yyyy-MM-dd HH:mm:ss"
    case timeFormat = "HH:mm:ss"
    case dateForaat = "yyyy-MM-dd"
}

struct DateTimeHelper {
    
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
    
    static func currentDateTime() -> Date {
        let currentTime = Date()
        let timezoneOffset = DriverInfo.timeZoneOffset
        
        // Convert current time to user's timezone
        if let userTime = convertToUserTimezone(currentTime, offset: timezoneOffset) {
            return userTime // current
        } else {
            return currentTime // UTC
        }
            
    }

    // Helper function to convert time to user's timezone
    static func convertToUserTimezone(_ date: Date, offset: String) -> Date? {
        let offsetString = offset.replacingOccurrences(of: ":", with: "")
        let sign = String(offsetString.prefix(1))
        let hours = Int(offsetString.dropFirst().prefix(2)) ?? 0
        let minutes = Int(offsetString.dropFirst().dropFirst(2)) ?? 0
        
        var totalMinutes = hours * 60 + minutes
        if sign == "-" {
            totalMinutes = -totalMinutes
        }
        
        let offsetSeconds = TimeInterval(totalMinutes * 60)
        return calendar.date(byAdding: .second, value: Int(offsetSeconds), to: date)//date.addingTimeInterval(offsetSeconds)
    }
    
    static func getCurrentDateTimeString() -> String {
        return getStringFromDate(Date())
    }
    
    static func currentTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterConstants.timeFormat.rawValue
        formatter.timeZone = TimeZone(identifier: DriverInfo.timezone)
        return formatter.string(from: currentDate)
    }

    static func currentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterConstants.dateForaat.rawValue
        formatter.timeZone = TimeZone(identifier: DriverInfo.timezone)
        return formatter.string(from: currentDate)
    }
    
    static func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    static func endOfDay(for date: Date) -> Date? {
        calendar.date(byAdding: .day, value: 1, to: self.startOfDay(for: date))
    }
    
    static func getStringFromDate(_ date: Date,
                                  timeZone: TimeZone? = TimeZone(identifier: DriverInfo.timezone),
                                  format: DateFormatterConstants = .defaultDateTime) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    static func getDateStringFrom(_ fromString: String, fromDateFormat: DateFormatterConstants, toDateFromat: DateFormatterConstants) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat.rawValue
        let dateFromOldFormat = dateFormatter.date(from: fromString) ?? Date()
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = toDateFromat.rawValue
        let stringFromNewFormat = dateFormatter.string(from: dateFromOldFormat)
        return stringFromNewFormat
    }
    
    static func getDateFromString(_ dateString: String, format: DateFormatterConstants = .defaultDateTime) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString) ?? Date()
    }
}


import Foundation

class DateHelper {
    static let shared = DateHelper()
    private init() {}

    // MARK: - Common App Date Formatters
    private let dbFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // your database date format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy" // e.g. Oct 05, 2025
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // 24-hour time format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // MARK: - Conversion Functions
    func formatForDB(_ date: Date) -> String {
        return dbFormatter.string(from: date)
    }

    func formatForDisplay(_ date: Date) -> String {
        return displayFormatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }

    func parseDBDate(_ dateString: String) -> Date? {
        return dbFormatter.date(from: dateString)
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
        gmtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        gmtFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let gmtString = gmtFormatter.string(from: date)
        
        return (localString, gmtString)
    }
}


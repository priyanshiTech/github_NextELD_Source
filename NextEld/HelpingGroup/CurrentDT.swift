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
    case dateOnlyFormat = "yyyy-MM-dd"
}

struct DateTimeHelper {
    
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
    
    static var currentCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = AppStorageHandler.shared.timeZone ?? ""
        calendar.timeZone = TimeZone(identifier: timeZone) ?? .current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
    
    static func get15MinBeforeDate(date: Date) -> Date? {
        return calendar.date(byAdding: .minute, value: -15, to: date)
    }
    
    static func get30MinBeforeDate(date: Date) -> Date? {
        return calendar.date(byAdding: .minute, value: -30, to: date)
    }
    
    static func getNoOfDaysBetween(from date1: Date, to date2: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let dayCount = components.day ?? 0
        return dayCount
    }
    
    static func currentDateTime() -> Date {
        let currentTime = Date()
        let timezoneOffset = AppStorageHandler.shared.timeZoneOffset ?? ""
        
        // Convert current time to user's timezone
        if let userTime = convertToUserTimezone(currentTime, offset: timezoneOffset) {
            return userTime // current
        } else {
            return currentTime // UTC
        }
            
    }
    static func getCurrentUTCDateTimeString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: Date())
    }

    // Helper function to convert time to user's timezone
    static func convertToUserTimezone(_ date: Date, offset: String) -> Date? {
        let timeStrings = offset.split(separator: ":")
        let sign = timeStrings.first?.first ?? "+"
        let minutes = Int(timeStrings.last ?? "0") ?? 0
        let hours = Int(timeStrings.first?.dropFirst() ?? "0") ?? 0
        
        
        var totalMinutes = hours * 60 + minutes
        if sign == "-" {
            totalMinutes = -totalMinutes
        }
        
        let offsetSeconds = TimeInterval(totalMinutes * 60)
        return calendar.date(byAdding: .second, value: Int(offsetSeconds), to: date)
    }
    
    static func getCurrentDateTimeString() -> String {
        return getStringFromDate(Date())
    }
    
    static func currentTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterConstants.timeFormat.rawValue
        formatter.timeZone = TimeZone(identifier: AppStorageHandler.shared.timeZone ?? "")
        return formatter.string(from: currentDate)
    }

    static func currentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterConstants.dateOnlyFormat.rawValue
        formatter.timeZone = TimeZone(identifier: AppStorageHandler.shared.timeZone ?? "")
        return formatter.string(from: currentDate)
    }
    
    static func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    static func endOfDay(for date: Date) -> Date? {
        calendar.date(byAdding: .day, value: 1, to: self.startOfDay(for: date))
    }
    
    static func getStringFromDate(_ date: Date,
                                  timeZone: TimeZone? = nil,
                                  format: DateFormatterConstants = .defaultDateTime) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Use provided timezone, or try to get from AppStorageHandler, or fall back to current timezone
        if let providedTimeZone = timeZone {
            dateFormatter.timeZone = providedTimeZone
        } else if let storedTimeZoneString = AppStorageHandler.shared.timeZone,
                  !storedTimeZoneString.isEmpty,
                  let storedTimeZone = TimeZone(identifier: storedTimeZoneString) {
            dateFormatter.timeZone = storedTimeZone
        } else {
            // Always use current timezone for display to ensure correct local time
            dateFormatter.timeZone = TimeZone.current
        }
        
        return dateFormatter.string(from: date)
    }
    //MARK: - to add a Correct Logsdetails time Formate
    // Format date/time exactly as stored in database (extract components directly without timezone conversion)
    static func formatDatabaseDateTime(_ date: Date) -> String {
        // Use DateTimeHelper calendar (GMT+0) to extract components exactly as stored
        let calendar = DateTimeHelper.calendar
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let year = components.year ?? 0
        let month = String(format: "%02d", components.month ?? 0)
        let day = String(format: "%02d", components.day ?? 0)
        let hour = String(format: "%02d", components.hour ?? 0)
        let minute = String(format: "%02d", components.minute ?? 0)
        let second = String(format: "%02d", components.second ?? 0)
        
        return "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"
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
    
    // Helper function to parse various date formats
    static func parseDate(_ dateString: String) -> Date? {
        let formats = [
            "yyyy-MM-dd",
            "dd-MM-yyyy",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "MM/dd/yyyy",
            "dd/MM/yyyy"
        ]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    // Helper function to format date to local time with date and time
    static func formatDateToLocalTime(_ date: Date) -> String {
        // Ensure we're using the device's current timezone
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        
        // Create formatter with current timezone
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = calendar
        
        // Format the date - DateFormatter automatically converts to the specified timezone
        let localTimeString = formatter.string(from: date)
        
        return localTimeString
    }
    
    // Helper function to format date only (without time)
    static func formatDateOnly(_ date: Date) -> String {
        // Ensure we're using the device's current timezone
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        
        // Create formatter with current timezone
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = calendar
        
        // Format the date - DateFormatter automatically converts to the specified timezone
        let localDateString = formatter.string(from: date)
        
        return localDateString
    }
    
}
struct CurrentTimeHelperStamp {
    static var currentTimestamp: Int {
        return Int(DateTimeHelper.currentDateTime().timeIntervalSince1970 * 1000)
    }
}
func currentTimestampMillis() -> String {
    let timestamp = Int(DateTimeHelper.currentDateTime().timeIntervalSince1970 * 1000)
    return "\(timestamp)"
}

// MARK: - Convert Timestamp (milliseconds) to DateTime String
func convertTimestampToDateTime(_ timestamp: Int) -> String {
    // Convert milliseconds timestamp to Date (dividing by 1000 to get seconds)
    // timeIntervalSince1970 always represents UTC time
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000.0)
    
    // Create UTC calendar to extract components in UTC timezone
    var calendar = Calendar(identifier: .gregorian)
    if let utcTimeZone = TimeZone(secondsFromGMT: 0) {
        calendar.timeZone = utcTimeZone
    } else {
        calendar.timeZone = TimeZone(identifier: "UTC") ?? TimeZone.current
    }
    calendar.locale = Locale(identifier: "en_US_POSIX")
    
    // Extract components directly from UTC date
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    let year = components.year ?? 0
    let month = String(format: "%02d", components.month ?? 0)
    let day = String(format: "%02d", components.day ?? 0)
    let hour = String(format: "%02d", components.hour ?? 0)
    let minute = String(format: "%02d", components.minute ?? 0)
    let second = String(format: "%02d", components.second ?? 0)
    
    return "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"
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


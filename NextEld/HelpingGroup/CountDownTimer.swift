//
//  CountDownTimer.swift
//  NextEld
//
//  Created by priyanshi   on 28/06/25.
//

import Foundation
import Combine

class CountdownTimer: ObservableObject {
    var remainingTime: TimeInterval = 0
    
    private var timer: Timer?
  //  private var endDate: Date?
    var isRunning: Bool = false
    
    let startDuration: TimeInterval  // original duration (e.g. 14 * 3600)

    // MARK: - Init
    init(startTime: TimeInterval) {
        self.startDuration = startTime
        self.remainingTime = startTime
    }

    // MARK: - Timer Display
    
    
    // MARK: - Internal Timer Value (for database)
    var internalTimeString: String {
        let absTime = abs(remainingTime)
        let hours = Int(absTime) / 3600
        let minutes = (Int(absTime) % 3600) / 60
        let seconds = Int(absTime) % 60
        
        if remainingTime <= 0 {
            return String(format: "-%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    // Timezone-aware time string
    var timezoneAwareTimeString: String {
        let currentTime = Date()
        let timezoneOffset = UserDefaults.standard.string(forKey: "userTimezoneOffset") ?? "+05:30"
        
        // Convert current time to user's timezone
        let userTime = convertToUserTimezone(currentTime, offset: timezoneOffset)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: getTimezoneIdentifier(from: timezoneOffset))
        
        return formatter.string(from: userTime)
    }

    // Helper function to convert time to user's timezone
    private func convertToUserTimezone(_ date: Date, offset: String) -> Date {
        let offsetString = offset.replacingOccurrences(of: ":", with: "")
        let sign = String(offsetString.prefix(1))
        let hours = Int(offsetString.dropFirst().prefix(2)) ?? 0
        let minutes = Int(offsetString.dropFirst().dropFirst(2)) ?? 0
        
        var totalMinutes = hours * 60 + minutes
        if sign == "-" {
            totalMinutes = -totalMinutes
        }
        
        let offsetSeconds = TimeInterval(totalMinutes * 60)
        return date.addingTimeInterval(offsetSeconds)
    }

    // Helper function to get timezone identifier from offset
    private func getTimezoneIdentifier(from offset: String) -> String {
        // Map common offsets to timezone identifiers
        switch offset {
        case "+05:30": return "Asia/Kolkata"
        case "+05:00": return "Asia/Karachi"
        case "+08:00": return "Asia/Shanghai"
        case "-05:00": return "America/New_York"
        case "-08:00": return "America/Los_Angeles"
        case "-06:00": return "America/Chicago"
        case "+00:00": return "UTC"
        default: return "UTC"
        }
    }

    // MARK: - Start Timer
    func start() {
       // endDate = DateTimeHelper.currentDateTime().addingTimeInterval(remainingTime)
        
        isRunning = true
        startTimer()
    }

    // MARK: - Stop Timer
    func stop() {
        timer?.invalidate()
        isRunning = false
    }

    // MARK: - Timer Loop
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            //guard let endDate = self.endDate else { return }

           // let timeLeft = endDate.timeIntervalSinceNow
            self.remainingTime -= 1
            // Keep timer running even when negative - don't stop it
        }
    }

    // MARK: - Restore from DB
    func restore(from remaining: TimeInterval, startedAt: Date?, wasRunning: Bool) {
        guard let startedAt = startedAt else {
            self.remainingTime = remaining
            return
        }

        let elapsed = DateTimeHelper.currentDateTime().timeIntervalSince(startedAt)
        let newRemaining = max(remaining - elapsed + 10, 0) // buffer

        self.remainingTime = newRemaining

        if wasRunning && newRemaining > 0 {
            start()
        } else {
            stop()
        }
    }

    // MARK: - Save state
    func getState() -> (remaining: TimeInterval, startedAt: Date?, isRunning: Bool) {
        return (remainingTime, Date(), isRunning)
    }


    // MARK: - Elapsed time
    var elapsed: TimeInterval {
        return startDuration - remainingTime
    }
    //MARK: -  Convert Into Second
    static func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let parts = timeString.split(separator: ":").map { Int($0) ?? 0 }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0], minutes = parts[1], seconds = parts[2]
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
  
   
    func reset(startTime: TimeInterval) {
        stop()
        self.remainingTime = startTime
     //   self.endDate = Date().addingTimeInterval(startTime)
    }

    func resetsSleep(to seconds: Double) {
        stop()
        self.remainingTime = seconds  // Use the parameter instead of hardcoded 36000
     //   self.endDate = nil             // calculation disable
        isRunning = false              // paused state
    }
  
}



import Foundation

extension String {
    /// Convert `HH:mm:ss` or `-HH:mm:ss` string to TimeInterval
    func asTimeInterval() -> TimeInterval {
        let isNegative = self.hasPrefix("-")
        let cleanString = isNegative ? String(self.dropFirst()) : self
        
        let parts = cleanString.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0]
        let minutes = parts[1]
        let seconds = parts[2]
        
        let timeInterval = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        return isNegative ? -timeInterval : timeInterval
    }

    /// Convert `yyyy-MM-dd HH:mm:ss` string to Date
    func asDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}



func formatTime(_ timeInterval: TimeInterval) -> String {
    // Always show 00:00:00 in UI when time is up
    if timeInterval <= 0 {
        return "00:00:00"
    }
    
    let hours = Int(timeInterval) / 3600
    let minutes = (Int(timeInterval) % 3600) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

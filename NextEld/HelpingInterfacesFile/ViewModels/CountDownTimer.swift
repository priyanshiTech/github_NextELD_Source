//
//  CountDownTimer.swift
//  NextEld
//
//  Created by priyanshi   on 28/06/25.
//

import Foundation
import Combine

class CountdownTimer: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    private var timer: Timer?
    private var endDate: Date?
    var isRunning: Bool = false
    
    let startDuration: TimeInterval  // original duration (e.g. 14 * 3600)

    // MARK: - Init
    init(startTime: TimeInterval) {
        self.startDuration = startTime
        self.remainingTime = startTime
    }

    // MARK: - Timer Display
    var timeString: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // MARK: - Start Timer
    func start() {
        endDate = Date().addingTimeInterval(remainingTime)
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
            guard let endDate = self.endDate else { return }

            let timeLeft = endDate.timeIntervalSinceNow
            if timeLeft > 0 {
                self.remainingTime = timeLeft
            } else {
                self.remainingTime = 0
                self.stop()
            }
        }
    }

    // MARK: - Restore from DB
    func restore(from remaining: TimeInterval, startedAt: Date?, wasRunning: Bool) {
        guard let startedAt = startedAt else {
            self.remainingTime = remaining
            return
        }

        let elapsed = Date().timeIntervalSince(startedAt)
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
        self.endDate = Date().addingTimeInterval(startTime)
    }


}



import Foundation

extension String {
    /// Convert `HH:mm:ss` string to TimeInterval
    func asTimeInterval() -> TimeInterval {
        let parts = self.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0]
        let minutes = parts[1]
        let seconds = parts[2]
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }

    /// Convert `yyyy-MM-dd HH:mm:ss` string to Date
    func asDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}







func formatTime(_ time: TimeInterval) -> String {
    let hrs = Int(time) / 3600
    let mins = (Int(time) % 3600) / 60
    let secs = Int(time) % 60
    return String(format: "%02d:%02d:%02d", hrs, mins, secs)
}

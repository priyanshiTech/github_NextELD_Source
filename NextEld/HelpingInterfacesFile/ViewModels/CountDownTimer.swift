//
//  CountDownTimer.swift
//  NextEld
//
//  Created by priyanshi   on 28/06/25.
//

import SwiftUI
import Combine

import Foundation
import Combine

class CountdownTimer: ObservableObject {
    @Published var remainingTime: TimeInterval
    let startTime: TimeInterval
    private var timer: Timer?
    var isRunning: Bool = false
    private var startDate: Date?

    
    //MARK: - TO SAVE TIMER
    var timeString: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    
    
    
    
    
    var elapsed: TimeInterval {
        return startTime - remainingTime
    }

    init(startTime: TimeInterval) {
        self.startTime = startTime
        self.remainingTime = startTime
    }

    func start() {
        startDate = Date()
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timer?.invalidate()
                self.isRunning = false
            }
        }
    }

    func stop() {
        timer?.invalidate()
        isRunning = false
    }

    /// Get current timer state for persistence
    func getState() -> (remaining: TimeInterval, startedAt: Date?) {
        return (remainingTime, startDate)
    }

    /// Restore a timer from persisted state with a 10-second grace buffer
    func restore(from remaining: TimeInterval, startedAt: Date?) {
        guard let startedAt = startedAt else {
            self.remainingTime = remaining
            return
        }

        let elapsed = Date().timeIntervalSince(startedAt)
        let adjustedRemaining = max(remaining - elapsed + 10, 0) // ⏱ Add 10-second grace

        self.remainingTime = adjustedRemaining
        print(" Restoring timer: Remaining adjusted to \(Int(adjustedRemaining))s")

        if adjustedRemaining > 0 {
            start()
        }
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








/*class CountdownTimer: ObservableObject {
    @Published var remainingTime: TimeInterval
    private var timer: AnyCancellable?
    private var isRunning = false

    init(startTime: TimeInterval) {
        self.remainingTime = startTime
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    self.stop()
                }
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
        isRunning = false
    }

    deinit {
        stop()
    }
}*/


func formatTime(_ time: TimeInterval) -> String {
    let hrs = Int(time) / 3600
    let mins = (Int(time) % 3600) / 60
    let secs = Int(time) % 60
    return String(format: "%02d:%02d:%02d", hrs, mins, secs)
}

//
//  CountDownTimer.swift
//  NextEld
//
//  Created by priyanshi   on 28/06/25.
//

import Foundation
import Combine

class CountdownTimer: ObservableObject {
   
    @Published var remainingTime: Double = 0
    
    private var timer: Timer?
  //  private var endDate: Date?
    var isRunning: Bool = false
    
    let startDuration: TimeInterval  // original duration (e.g. 14 * 3600)
    
    // Callback for time changes
    var onTimeChanged: ((TimeInterval) -> Void)?

    // MARK: - Init
    init(startTime: TimeInterval) {
        self.startDuration = startTime
        self.remainingTime = startTime
    }

    // MARK: - Start Timer
    func start() {
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
            
            // Notify about time change
            self.onTimeChanged?(self.remainingTime)
            
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
    
    func reset(startTime: TimeInterval) {
        stop()
        self.remainingTime = startTime
     //   self.endDate = Date().addingTimeInterval(startTime)
    }


}

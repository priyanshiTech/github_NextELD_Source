//
//  CountDownTimer.swift
//  NextEld
//
//  Created by priyanshi   on 28/06/25.
//

import SwiftUI
import Combine

class CountdownTimer: ObservableObject {
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
}


func formatTime(_ time: TimeInterval) -> String {
    let hrs = Int(time) / 3600
    let mins = (Int(time) % 3600) / 60
    let secs = Int(time) % 60
    return String(format: "%02d:%02d:%02d", hrs, mins, secs)
}

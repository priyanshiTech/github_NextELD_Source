//
//  SharedManager.swift
//  NextEld
//
//  Created by priyanshi on 21/08/25.
//

import Foundation
//class DutyStatusManager: ObservableObject {
//    @Published var dutyStatus: String = DriverStatusConstants.offDuty
//}

class DutyStatusManager: ObservableObject {
    @Published var dutyStatus: String = DriverStatusConstants.offDuty
    
    // Track total durations (in seconds)
    @Published var totalOffDutyTime: TimeInterval = 0
    @Published var totalSleepTime: TimeInterval = 0
    
    // Internal tracking
    private var statusStartDate: Date? = Date()
    private var lastStatus: String = DriverStatusConstants.offDuty
    
    /// Call this whenever duty status changes
    func updateStatus(to newStatus: String) {
        let now = Date()
        
        // Add elapsed time for the previous status
        if let start = statusStartDate {
            let elapsed = now.timeIntervalSince(start)
            if lastStatus == DriverStatusConstants.offDuty {
                totalOffDutyTime += elapsed
            } else if lastStatus == DriverStatusConstants.onSleep {
                totalSleepTime += elapsed
            }
        }
        
        // Update state
        lastStatus = newStatus
        dutyStatus = newStatus
        statusStartDate = now
    }
    
    /// Reset daily totals (call this at midnight or after a 34-hour reset)
    func resetDailyTotals() {
        totalOffDutyTime = 0
        totalSleepTime = 0
        statusStartDate = Date()
    }
}

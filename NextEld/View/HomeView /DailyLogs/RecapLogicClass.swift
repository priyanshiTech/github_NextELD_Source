//
//  RecapLogicClass.swift
//  NextEld
//
//  Created by priyanshi  on 29/08/25.
//

//import Foundation
//import SwiftUI
//
//class RecapCalculator {
//    private let calendar = Calendar.current
//    private let db = DatabaseManager.shared
//    
//    func calculateRecap() -> (
//        entries: [WorkEntry],
//        total7Day: TimeInterval,
//        todayWorked: TimeInterval,
//        todayAvailable: TimeInterval,
//        tomorrowAvailable: TimeInterval
//    ) {
//        var recapEntries: [WorkEntry] = []
//        var total7Day: TimeInterval = 0
//        var todayWorked: TimeInterval = 0
//        
//        // 14 hours max per day, 70 hours per 7-day cycle
//        let maxToday: TimeInterval = 14 * 3600
//        let maxCycle: TimeInterval = 70 * 3600
//        var todayAvailable: TimeInterval = maxToday
//        var tomorrowAvailable: TimeInterval = maxCycle
//        
//        let today = Date()
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        // Loop last 7 days (including today)
//        for offset in (-6...0) {
//            guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
//            let logs = db.getRecordByDay(day, afterDay8: false)
//            
//            var dutySeconds: TimeInterval = 0
//            
//            if logs.count > 1 {
//                for i in 0..<(logs.count - 1) {
//                    let curr = logs[i]
//                    let next = logs[i+1]
//                    
//                    guard let currDate = df.date(from: curr.startTime),
//                          let nextDate = df.date(from: next.startTime) else { continue }
//                    
//                    let duration = nextDate.timeIntervalSince(currDate)
//                    
//                    switch curr.status {
//                    case "OnDuty", "OnDrive":
//                        dutySeconds += duration
//                    case "OffDuty", "OnSleep":
//                        if duration <= 2 * 3600 {   // split rule
//                            dutySeconds += duration
//                        }
//                    default:
//                        break
//                    }
//                }
//            }
//            
//            // Save recap entry for that day
//            recapEntries.append(WorkEntry(date: day, hoursWorked: dutySeconds))
//            
//            // Today vs past days
//            if calendar.isDateInToday(day) {
//                todayWorked = dutySeconds
//                todayAvailable = max(0, maxToday - dutySeconds)
//            } else {
//                total7Day += dutySeconds
//            }
//        }
//        
//        // Tomorrow’s availability = cycle max - (last 7 days worked)
//        tomorrowAvailable = max(0, maxCycle - (total7Day + todayWorked))
//        
//        return (recapEntries, total7Day, todayWorked, todayAvailable, tomorrowAvailable)
//    }
//}

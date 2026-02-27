import Foundation

extension DatabaseManager {
    
    func getRecapeAfterSevenDays() -> WorkEntry? {
        var dutySeconds: TimeInterval = 0
        var sleepDuration: TimeInterval = 0
        let calendar = DateTimeHelper.calendar
        let today = DateTimeHelper.currentDateTime()
        let dayValue = -(AppStorageHandler.shared.cycleDays ?? 0)
        guard let day = calendar.date(byAdding: .day, value: dayValue, to: today) else { return nil }
        let startOfDay = calendar.startOfDay(for: day)
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: startOfDay, endDate: startOfNextDay)])
        
        var logsForDay = allLogs.compactMap { log -> (Date, String)? in
            return (log.startTime, log.status)
        }
        
        if let lastlog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.specificDate(date: startOfDay)]),
           (lastlog.status == AppConstants.onDuty || lastlog.status == AppConstants.onDrive || lastlog.status == AppConstants.yardMove || lastlog.status == AppConstants.personalUse),
           startOfDay > lastlog.startTime  {
            logsForDay.append((startOfDay, lastlog.status))
        }
        
        let soredLog = logsForDay.sorted(by: { $0.0 < $1.0 })
        
        for (i, log) in soredLog.enumerated() {
            let startDate = log.0
            let status = log.1
            
            let endDate: Date
            if i + 1 < soredLog.count {
                endDate = soredLog[i+1].0
            } else {
                let endOfDay = (DateTimeHelper.endOfDay(for: log.0) ?? Date())
                endDate = today > endOfDay ? endOfDay : today
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.onDuty || status == AppConstants.onDrive || status == AppConstants.yardMove || status == AppConstants.personalUse {
                
                // checking the continuous sleep or offduty
                if sleepDuration < (2 * 3600) {
                    dutySeconds += sleepDuration
                }
                dutySeconds += duration
                sleepDuration = 0
            } else if (status == AppConstants.offDuty || status == AppConstants.onSleep) {
                if i != (logsForDay.count - 1) {
                    sleepDuration += duration
                }
            }
        }
        return WorkEntry(date: day, hoursWorked: dutySeconds)
    }
    
    func fetchWorkEntriesLast7Days() -> [WorkEntry] {
        let totalCycle = AppStorageHandler.shared.cycleDays ?? 8
        let calendar = DateTimeHelper.calendar
        let today = DateTimeHelper.currentDateTime()
        var results: [WorkEntry] = []
        for offset in (1..<totalCycle) {
            var dutySeconds: TimeInterval = 0
            var sleepDuration: TimeInterval = 0
            let dayOffset = offset - totalCycle
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: startOfDay, endDate: startOfNextDay)])
            var logsForDay = allLogs.compactMap { log -> (Date, String)? in
                return (log.startTime, log.status)
            }
            
            if let lastlog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.specificDate(date: startOfDay)]),
               (lastlog.status == AppConstants.onDuty || lastlog.status == AppConstants.onDrive || lastlog.status == AppConstants.yardMove || lastlog.status == AppConstants.personalUse),
               startOfDay > lastlog.startTime  {
                logsForDay.append((startOfDay, lastlog.status))
            }
            
            let soredLog = logsForDay.sorted(by: { $0.0 < $1.0 })
            
            for (i, log) in soredLog.enumerated() {
                let startDate = log.0
                let status = log.1
                
                let endDate: Date
                if i + 1 < soredLog.count {
                    endDate = soredLog[i+1].0
                } else {
                    let endOfDay = (DateTimeHelper.endOfDay(for: log.0) ?? Date())
                    endDate = today > endOfDay ? endOfDay : today
                }
                
                let duration = max(0, endDate.timeIntervalSince(startDate))
                
                if status == AppConstants.onDuty || status == AppConstants.onDrive || status == AppConstants.yardMove || status == AppConstants.personalUse {
                    
                    // checking the continuous sleep or offduty
                    if sleepDuration < (2 * 3600) {
                        dutySeconds += sleepDuration
                    }
                    dutySeconds += duration
                    sleepDuration = 0
                } else if (status == AppConstants.offDuty || status == AppConstants.onSleep) {
                    if i != (logsForDay.count - 1) {
                        sleepDuration += duration
                    }
                }
            }
             print("day--> \(day)--> \(dutySeconds.timeString)")
            results.append(WorkEntry(date: day, hoursWorked: dutySeconds))
            
        }
        return results//.sorted { $0.date < $1.date }
    }
    
    func getRemainingWorkedToday() -> TimeInterval {
        if let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.shift]),
           let remainingWeeklyTime = lastLog.remainingDutyTime {
            let status = DriverStatusType(fromName: lastLog.status) ?? .none
            let duration = DateTimeHelper.currentDateTime().timeIntervalSince(lastLog.startTime)
            let isYardMove = (status == .yardMode)
            let isDrive   = (status == .onDrive)
            let isOnDuty  = (status == .onDuty) || isDrive || isYardMove
            if isOnDuty {
                return TimeInterval(remainingWeeklyTime - Int(duration))
            } else {
                return TimeInterval(remainingWeeklyTime)
            }
        }
        return 0
    }
    
    func getTodaysWork() -> (totalWorkedToday: TimeInterval, remainingWorkedToday: TimeInterval) {
        let OnDutyTodayTotalTime = TimeInterval(AppStorageHandler.shared.onDutyTime ?? 0)
        var dutySeconds: TimeInterval = 0
        var sleepDuration: TimeInterval = 0
        let allLogs = fetchLogs(filterTypes: [.getTodayRecord])
        let startOfToday =  DateTimeHelper.startOfDay(for: DateTimeHelper.currentDateTime())
        var logsForDay = allLogs.compactMap { log -> (Date, String)? in
            return (log.startTime, log.status)
        }
            
        if let lastlog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.specificDate(date: startOfToday)]),
           (lastlog.status == AppConstants.onDuty || lastlog.status == AppConstants.onDrive || lastlog.status == AppConstants.yardMove || lastlog.status == AppConstants.personalUse) {
            logsForDay.append((startOfToday, lastlog.status))
        }
        let sortedLogs = logsForDay.sorted(by: { $0.0 < $1.0 })
        
        for (i, log) in sortedLogs.enumerated() {
            let startDate = log.0
            let status = log.1
            
            let endDate: Date
            if (i + 1) < sortedLogs.count {
                endDate = sortedLogs[i+1].0
            } else {
                endDate = DateTimeHelper.currentDateTime()//log.0//calendar.isDateInToday(day) ? Date() : startOfNextDay
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.onDuty || status == AppConstants.onDrive || status == AppConstants.yardMove || status == AppConstants.personalUse {
                
                // checking the continuous sleep or offduty
                if sleepDuration < (2 * 3600) {
                    dutySeconds += sleepDuration
                }
                dutySeconds += duration
                sleepDuration = 0
            } else if (status == AppConstants.offDuty || status == AppConstants.onSleep) {
                if i != (logsForDay.count - 1) {
                    sleepDuration += duration
                }
            }
            
        }
        let dutyTime = max(0, OnDutyTodayTotalTime - dutySeconds)
        
        return (dutySeconds, dutyTime)
    }
    
    func getRemainingCycleTime() -> TimeInterval {
        if let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.shift]),
           let remainingWeeklyTime = lastLog.remainingWeeklyTime {
            let status = DriverStatusType(fromName: lastLog.status) ?? .none
            let duration = DateTimeHelper.currentDateTime().timeIntervalSince(lastLog.startTime)
            let isCycle   = !(status == .offDuty || status == .onsleep || status == .personalUse)
            if isCycle {
                return TimeInterval(remainingWeeklyTime - Int(duration))
            } else {
                return TimeInterval(remainingWeeklyTime)
            }
        }
        return 0
//        let today = DateTimeHelper.currentDateTime()
//        let cycleLimit: TimeInterval = TimeInterval(AppStorageHandler.shared.cycleTime ?? 0)
//        
//        let allLogs = fetchLogs(filterTypes: [.shift])
//        if allLogs.isEmpty {
//            return cycleLimit
//        }
//        let logsForDay = allLogs.compactMap { log -> (Date, String)? in
//            return (log.startTime, log.status)
//        }
//        .sorted { $0.0 < $1.0 }
//        
//        var dutySeconds: TimeInterval = 0
//        var sleepDuration: TimeInterval = 0
//        
//        for (i, log) in logsForDay.enumerated() {
//            let startDate = log.0
//            let status = log.1
//            
//            let endDate: Date
//            if i + 1 < logsForDay.count {
//                endDate = logsForDay[i+1].0
//            } else {
//                endDate = today
//            }
//            
//            let duration = max(0, endDate.timeIntervalSince(startDate))
//            
//            // cycle time include onDuty, onDrive, yardMove, personalUse
//            // When offduty or sleep or together is < 2 hour count in cycle and onduty
//            
//            if status == AppConstants.onDuty || status == AppConstants.onDrive || status == AppConstants.yardMove || status == AppConstants.personalUse {
//                
//                // checking the continuous sleep or offduty
//                if sleepDuration < (2 * 3600) {
//                    dutySeconds += sleepDuration
//                }
//                dutySeconds += duration
//                sleepDuration = 0
//            } else if (status == AppConstants.offDuty || status == AppConstants.onSleep) {
//                // if last record is offduty will not check < 2hour condition
//                if i != (logsForDay.count - 1) {
//                    sleepDuration += duration
//                }
//            }
//            print("duration===",duration)
    //    }
        
//        let cycleTime = max(0, cycleLimit - dutySeconds)
//        return cycleTime
    }
    
    
}

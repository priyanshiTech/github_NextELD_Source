import Foundation

extension DatabaseManager {
    
    func getRecapeAfterSevenDays() -> WorkEntry? {
        var dutySeconds: TimeInterval = 0
        let calendar = DateTimeHelper.calendar
        let today = DateTimeHelper.currentDateTime()
        let dayValue = -(AppStorageHandler.shared.cycleDays ?? 0)
        guard let day = calendar.date(byAdding: .day, value: dayValue, to: today) else { return nil }
        let startOfDay = calendar.startOfDay(for: day)
        let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: startOfDay, endDate: startOfNextDay)])
        for (i, log) in allLogs.enumerated() {
            let startDate = log.startTime
            let status = log.status
            
            let endDate: Date
            if i + 1 < allLogs.count {
                endDate = allLogs[i+1].startTime
            } else {
                endDate = today
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.onDuty || status == AppConstants.onDrive {
                dutySeconds += duration
            }
            else if status == AppConstants.offDuty {
                // optional split rule: short off-duty counts as duty
                if duration < (2 * 3600) {
                    dutySeconds += duration
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
            let dayOffset = offset - totalCycle
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: startOfDay, endDate: startOfNextDay)])
            for (i, log) in allLogs.enumerated() {
                let startDate = log.startTime
                let status = log.status
                
                let endDate: Date
                if i + 1 < allLogs.count {
                    endDate = allLogs[i+1].startTime
                } else {
                    let endOfDay = (DateTimeHelper.endOfDay(for: log.startTime) ?? Date())
                    endDate = today > endOfDay ? endOfDay : today
                }
                
                let duration = max(0, endDate.timeIntervalSince(startDate))
                
                if status == AppConstants.onDuty || status == AppConstants.onDrive {
                    dutySeconds += duration
                }
                else if status == AppConstants.offDuty {
                    // optional split rule: short off-duty counts as duty
                    if duration < (2 * 3600) {
                        dutySeconds += duration
                    }
                }
            }
            
            if allLogs.isEmpty {
                let lastDate = calendar.date(byAdding: .day, value: -1, to: startOfDay) ?? Date()
                let endOfLastDate = DateTimeHelper.endOfDay(for: lastDate) ?? Date()
                if let lastlog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.betweenDates(startDate: lastDate, endDate: endOfLastDate)]),
                    (lastlog.status != AppConstants.onSleep || lastlog.status != AppConstants.offDuty),
                    startOfDay > lastlog.startTime  {
                    let startOfToday = DateTimeHelper.startOfDay(for: today)
                    if startOfDay < startOfToday {
                        dutySeconds = 24 * 60 * 60
                    }
                }
            }
            results.append(WorkEntry(date: day, hoursWorked: dutySeconds))
            
        }
        return results//.sorted { $0.date < $1.date }
    }
    
    func getTodaysWork() -> (totalWorkedToday: TimeInterval, remainingWorkedToday: TimeInterval) {
        let OnDutyTodayTotalTime = TimeInterval(AppStorageHandler.shared.onDutyTime ?? 0)
        var dutySeconds: TimeInterval = 0
        let allLogs = fetchLogs(filterTypes: [.getTodayRecord])
        if allLogs.isEmpty {
            let yesterDay =  DateTimeHelper.calendar.date(byAdding: .day, value: -1, to: DateTimeHelper.currentDateTime()) ?? Date()
            let yesterDayStartOfDay =  DateTimeHelper.startOfDay(for: yesterDay)
            let yesterDayEndOfDay =  DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: yesterDayStartOfDay) ?? Date()
            let startOfToday =  DateTimeHelper.startOfDay(for: DateTimeHelper.currentDateTime())
            
            if let lastlog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.betweenDates(startDate: yesterDayStartOfDay, endDate: yesterDayEndOfDay)]) {
                let elapsed = DateTimeHelper.currentDateTime().timeIntervalSince(startOfToday)
                if lastlog.status == AppConstants.onDuty || lastlog.status == AppConstants.onDrive {
                    dutySeconds = elapsed
                    let dutyTime = max(0, OnDutyTodayTotalTime - dutySeconds)
                    return (dutySeconds,dutyTime)
                }
            }
            return (0,OnDutyTodayTotalTime)
        }
        let logsForDay = allLogs.compactMap { log -> (Date, String)? in
            return (log.startTime, log.status)
        }
        // .filter { $0.0 >= startOfDay && $0.0 < startOfNextDay }
            .sorted { $0.0 < $1.0 }
        
        
        for (i, log) in logsForDay.enumerated() {
            let startDate = log.0
            let status = log.1
            
            let endDate: Date
            if (i + 1) < logsForDay.count {
                endDate = logsForDay[i+1].0
            } else {
                endDate = DateTimeHelper.currentDateTime()//log.0//calendar.isDateInToday(day) ? Date() : startOfNextDay
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.onDuty || status == AppConstants.onDrive {
                dutySeconds += duration
            }
            else if status == AppConstants.offDuty {
                // optional split rule: short off-duty counts as duty
                if duration < (2 * 3600) {
                    dutySeconds += duration
                }
            }
        }
        let dutyTime = max(0, OnDutyTodayTotalTime - dutySeconds)
        
        return (dutySeconds, dutyTime)
    }
    
    func getRemainingCycleTime() -> TimeInterval {
        let today = DateTimeHelper.currentDateTime()
        let cycleLimit: TimeInterval = TimeInterval(AppStorageHandler.shared.cycleTime ?? 0)
        
        let allLogs = fetchLogs(filterTypes: [.shift])
        if allLogs.isEmpty {
            return cycleLimit
        }
        let logsForDay = allLogs.compactMap { log -> (Date, String)? in
            return (log.startTime, log.status)
        }
        .sorted { $0.0 < $1.0 }
        
        var dutySeconds: TimeInterval = 0
        
        for (i, log) in logsForDay.enumerated() {
            let startDate = log.0
            let status = log.1
            
            let endDate: Date
            if i + 1 < logsForDay.count {
                endDate = logsForDay[i+1].0
            } else {
                endDate = today
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.onDuty || status == AppConstants.onDrive {
                dutySeconds += duration
            }
        }
        
        let cycleTime = max(0, cycleLimit - dutySeconds)
        return cycleTime
    }
    
    
}

import Foundation

extension DatabaseManager {
    func fetchWorkEntriesLast7Days() -> [WorkEntry] {
        let calendar = DateTimeHelper.calendar
        let today = DateTimeHelper.currentDateTime()
        
        // Fetch all logs
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [])
        
        var results: [WorkEntry] = []
        
        for offset in ((-7)...(-1)) {
            guard let day = calendar.date(byAdding: .day, value: offset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            // Filter logs for this day
            let logsForDay = allLogs.compactMap { log -> (Date, String)? in
                // guard let startDate = df.date(from: log.startTime) else { return nil }
                return (log.startTime, log.status)
            }
                .filter { $0.0 >= startOfDay && $0.0 < startOfNextDay }
                .sorted { $0.0 < $1.0 }
            
            var dutySeconds: TimeInterval = 0
            
            for (i, log) in logsForDay.enumerated() {
                let startDate = log.0
                let status = log.1
                
                let endDate: Date
                if i + 1 < logsForDay.count {
                    endDate = logsForDay[i+1].0
                } else {
                    endDate = calendar.isDateInToday(day) ? today : startOfNextDay
                }
                
                let duration = max(0, endDate.timeIntervalSince(startDate))
                
                if status == AppConstants.on_Duty || status == AppConstants.on_Drive {
                    dutySeconds += duration
                }
                
//                else if status == AppConstants.off_Duty || status == AppConstants.sleep {
//                    // optional split rule: short off-duty counts as duty
//                    if duration <= 2 * 3600 {
//                        dutySeconds += duration
//                    }
//                }
            }
            
            results.append(WorkEntry(date: day, hoursWorked: dutySeconds))
        }
        
        return results//.sorted { $0.date < $1.date }
    }
    
    func getTodaysWork() -> (totalWorkedToday: TimeInterval, remainingWorkedToday: TimeInterval) {
        let OnDutyTodayTotalTime = TimeInterval(AppStorageHandler.shared.onDutyTime ?? 0)
        let calendar = DateTimeHelper.calendar
        let allLogs = fetchLogs(filterTypes: [.getTodayRecord])
        if allLogs.isEmpty {
            return (0,OnDutyTodayTotalTime)
        }
        let logsForDay = allLogs.compactMap { log -> (Date, String)? in
            return (log.startTime, log.status)
        }
        // .filter { $0.0 >= startOfDay && $0.0 < startOfNextDay }
            .sorted { $0.0 < $1.0 }
        var dutySeconds: TimeInterval = 0
        
        for (i, log) in logsForDay.enumerated() {
            let startDate = log.0
            let status = log.1
            
            let endDate: Date
            if i + 1 < logsForDay.count {
                endDate = logsForDay[i+1].0
            } else {
                endDate = DateTimeHelper.currentDateTime()//log.0//calendar.isDateInToday(day) ? Date() : startOfNextDay
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.on_Duty || status == AppConstants.on_Drive {
                dutySeconds += duration
            }
//            else if status == AppConstants.off_Duty || status == AppConstants.sleep {
//                // optional split rule: short off-duty counts as duty
//                if duration <= 2 * 3600 {
//                    dutySeconds += duration
//                }
//            }
        }
        let dutyTime = max(0, OnDutyTodayTotalTime - dutySeconds)
        
        return (dutySeconds, dutyTime)
    }
    
    func getRemainingCycleTime() -> TimeInterval {
        let calendar = DateTimeHelper.calendar
        let today = DateTimeHelper.currentDateTime()
        let cycleLimit: TimeInterval = TimeInterval(AppStorageHandler.shared.cycleTime ?? 0)
        guard let startDate = calendar.date(byAdding: .day, value: -((AppStorageHandler.shared.cycleDays ?? 8) - 1), to: today) else {
            return 0
        }
        
        let allLogs = fetchLogs(filterTypes: [])
        if allLogs.isEmpty {
            return cycleLimit
        }
        let logsForDay = allLogs.compactMap { log -> (Date, String)? in
            return (log.startTime, log.status)
        }
        .filter { $0.0 >= startDate }
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
            
            if status == AppConstants.on_Duty || status == AppConstants.on_Drive {
                dutySeconds += duration
            }
//            else if status == AppConstants.off_Duty || status == AppConstants.sleep {
//                // optional split rule: short off-duty counts as duty
//                if duration <= 2 * 3600 {
//                    dutySeconds += duration
//                }
//            }
        }
        
        let cycleTime = max(0, cycleLimit - dutySeconds)
        return cycleTime
    }
}

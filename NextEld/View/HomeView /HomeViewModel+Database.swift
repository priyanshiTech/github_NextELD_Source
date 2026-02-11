import Foundation


extension HomeViewModel {
    
    func saveTimerStateForStatus(status: String, originType: OriginType, note: String? = nil, date: Date? = nil) {
        
        let driverStatus = DriverStatusType(fromName: status) ?? .offDuty
        let dutyTypeValue = driverStatus.getName()
        let startTime = date ?? DateTimeHelper.currentDateTime()
        let originDescription = originType.description
        
        DatabaseManager.shared.saveTimerLog(
            status: status,
            startTime: startTime,
            dutyType: driverStatus.getName(),
            remainingWeeklyTime: Int(cycleTimer?.remainingTime ?? 0),
            remainingDriveTime: Int(onDriveTimer?.remainingTime ?? 0),
            remainingDutyTime: Int(onDutyTimer?.remainingTime ?? 0),
            remainingSleepTime: Int(sleepTimer?.remainingTime ?? 0),
            breakTimeRemaning: Int(breakTimer?.remainingTime ?? 0),
            lastSleepTime: Int(breakTimer?.remainingTime ?? 0),
            RemaningRestBreak: "True",
            isVoilations: false,
            origin: originDescription,
            notes: note ?? ""
        )
    }
    
    
    func saveViolation(for violationData: ViolationData, originType: OriginType = .auto, date: Date? = nil) {
        DatabaseManager.shared.saveTimerLog(
            status: violationData.getTitle(),
            startTime: date ?? DateTimeHelper.currentDateTime(),
            dutyType: violationData.getWarningText(),
            remainingWeeklyTime: Int(cycleTimer?.remainingTime ?? 0),
            remainingDriveTime: Int(onDriveTimer?.remainingTime ?? 0),
            remainingDutyTime: Int(onDutyTimer?.remainingTime ?? 0),
            remainingSleepTime: Int(sleepTimer?.remainingTime ?? 0),
            breakTimeRemaning: Int(breakTimer?.remainingTime ?? 0),
            lastSleepTime: Int(breakTimer?.remainingTime ?? 0),
            RemaningRestBreak: "true",
            isVoilations: violationData.violation,
            origin: originType.description,
            notes: ""
        )
    }
    
    func calculateTimeForSplitShift() -> (onDuty: Double, onDrive: Double) {
        let splitLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.day, .splitShiftIdentifier], order: [DatabaseManager.shared.startTime.desc], limit: 2)
        
        guard let firstLog = splitLogs.last, let last = splitLogs.first else { // reverse order
            return (0, 0)
        }
        let logs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: firstLog.startTime, endDate: last.startTime)])
        
        var totalOnDutyTime: Double = 0
        var totalOnDriveTime: Double = 0
        for (i, log) in logs.enumerated() {
            let startDate = log.startTime
            let status = log.status
            
            var endDate: Date = last.startTime
            if i + 1 < logs.count {
                endDate = logs[i+1].startTime
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.onDuty {
                totalOnDutyTime += duration
            }
            
            if status == AppConstants.onDrive {
                totalOnDriveTime += duration
            }
            
            debugPrint("total on duty split time: \(totalOnDutyTime.getHours())")
            debugPrint("total on drive split time: \(totalOnDriveTime.getHours())")
        }
        return (totalOnDutyTime, totalOnDriveTime)
    }
}

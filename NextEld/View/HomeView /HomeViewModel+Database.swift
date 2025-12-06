import Foundation


extension HomeViewModel {

    func saveTimerStateForStatus(status: String, originType: OriginType, note: String? = nil, date: Date? = nil) {
        // print("Saving timer state for status: \(status)")
        var messge = note ?? ""
        if messge.isEmpty {
            messge = status
        }
        
        let startTime = date ?? DateTimeHelper.currentDateTime()
        let originDescription = originType.description
        
//        // Check for duplicate entry: same status, origin, and startTime within 30 seconds
//        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.day])
//        let tolerance: TimeInterval = 30 // 30 seconds tolerance
//        let hasDuplicate = allLogs.contains { log in
//            log.status == status &&
//            log.origin == originDescription &&
//            abs(log.startTime.timeIntervalSince(startTime)) <= tolerance
//        }
//        
//        if hasDuplicate {
//            // print(" ⚠️ Duplicate log entry detected - skipping save for \(status) at \(startTime)")
//            return
//        }

        DatabaseManager.shared.saveTimerLog(
            status: status,
            startTime: startTime,
            dutyType: messge,
            remainingWeeklyTime: Int(cycleTimer?.remainingTime ?? 0),
            remainingDriveTime: Int(onDriveTimer?.remainingTime ?? 0),
            remainingDutyTime: Int(onDutyTimer?.remainingTime ?? 0),
            remainingSleepTime: Int(sleepTimer?.remainingTime ?? 0),
            breakTimeRemaning: Int(breakTimer?.remainingTime ?? 0),
            lastSleepTime: Int(breakTimer?.remainingTime ?? 0),
            RemaningRestBreak: "True",
            isVoilations: false,
            origin: originDescription
        )

        // print(" Timer state saved successfully for \(status)")
    }

//MARK: -  for Continue Drive DB
//    func saveContinueDriveDB(status: String){
//        
//        // Check if break timer is completed (30 minutes = 1800 seconds)
//        let breakTimeRemaining = Int(breakTimer?.remainingTime ?? 0)
//        let breakTimeCompleted = breakTimeRemaining <= 0 // Timer completed when remaining time is 0 or less
//        
//        // Set breakTime value based on completion status
//        let breakTimeValue = breakTimeCompleted ? "\(breakTimeRemaining)" : ""
//        
//        let existingData = ContinueDriveDBManager.shared.fetchLatestContinueDriveData()
//        
//        if let existingEntry = existingData {
//            // Update existing entry instead of inserting new one
//            // Only update status, startTime, and breakTime - don't overwrite endTime
//            ContinueDriveDBManager.shared.updateLatestContinueDriveData(
//                status: status,
//                startTime: DateTimeHelper.getCurrentDateTimeString(),
//                breakTime: breakTimeValue
//            )
//            // print(" ContinueDrive DB entry UPDATED: \(status) at \(DateTimeHelper.getCurrentDateTimeString())")
//            // print(" Break timer completed: \(breakTimeCompleted), Break time value: '\(breakTimeValue)'")
//           
//        } else {
//            ContinueDriveDBManager.shared.saveContinueDriveData(
//                userId: Int(AppStorageHandler.shared.driverId ?? 0),
//                status: status,
//                startTime: DateTimeHelper.getCurrentDateTimeString(),
//                endTime: "", // Will be updated when break timer ends
//                breakTime: breakTimeValue
//                
//            )
//            // print(" ContinueDrive DB entry INSERTED: \(status) at \(DateTimeHelper.getCurrentDateTimeString())")
//            // print(" Break timer completed: \(breakTimeCompleted), Break time value: '\(breakTimeValue)'")
//        }
//    }
//    
//    //MARK: - Update Continue Drive DB when break timer ends
//    func updateContinueDriveDBEndTime(){
//        // Update the latest ContinueDrive entry with end time
//        ContinueDriveDBManager.shared.updateLatestContinueDriveData(
//            endTime:  DateTimeHelper.getCurrentDateTimeString()
//        )
//        
//        // print(" ContinueDrive DB end time updated at \(DateTimeHelper.getCurrentDateTimeString())")
//    }
//    
    
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
        origin: originType.description
        )
    }
    
    func calculateTimeForSplitShift() -> (onDuty: Double, onDrive: Double) {
        let logs = DatabaseManager.shared.fetchLogs(filterTypes: [.splitShiftIdentifier])
        var totalOnDutyTime: Double = 0
        var totalOnDriveTime: Double = 0
        for (i, log) in logs.enumerated() {
            let startDate = log.startTime
            let status = log.status
            
            let endDate: Date
            if i + 1 < logs.count {
                endDate = logs[i+1].startTime
            } else {
                endDate = DateTimeHelper.currentDateTime()
            }
            
            let duration = max(0, endDate.timeIntervalSince(startDate))
            
            if status == AppConstants.on_Duty {
                totalOnDutyTime += duration
            }
            
            if status == AppConstants.on_Drive {
                totalOnDriveTime += duration
            }
        }
        return (totalOnDutyTime, totalOnDriveTime)
    }
}

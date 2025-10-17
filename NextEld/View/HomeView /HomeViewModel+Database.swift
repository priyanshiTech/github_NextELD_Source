

extension HomeViewModel {

    func saveTimerStateForStatus(status: String, note: String) {
        print("Saving timer state for status: \(status)")

        DatabaseManager.shared.saveTimerLog(
            status: status,
            startTime: DateTimeHelper.getCurrentDateTimeString(),
            dutyType: status,
            remainingWeeklyTime: Int(cycleTimer?.remainingTime ?? 0),
            remainingDriveTime: Int(onDriveTimer?.remainingTime ?? 0),
            remainingDutyTime: Int(onDutyTimer?.remainingTime ?? 0),
            remainingSleepTime: Int(sleepTimer?.remainingTime ?? 0),
            breakTimeRemaning: Int(breakTimer?.remainingTime ?? 0),
            lastSleepTime: Int(breakTimer?.remainingTime ?? 0),
            RemaningRestBreak: "True",
            isruning: true,
            isVoilations: false
        )

        print(" Timer state saved successfully for \(status)")
    }

//MARK: -  for Continue Drive DB
    func saveContinueDriveDB(status: String){
        
        // Check if break timer is completed (30 minutes = 1800 seconds)
        let breakTimeRemaining = Int(breakTimer?.remainingTime ?? 0)
        let breakTimeCompleted = breakTimeRemaining <= 0 // Timer completed when remaining time is 0 or less
        
        // Set breakTime value based on completion status
        let breakTimeValue = breakTimeCompleted ? "\(breakTimeRemaining)" : ""
        
        let existingData = ContinueDriveDBManager.shared.fetchLatestContinueDriveData()
        
        if let existingEntry = existingData {
            // Update existing entry instead of inserting new one
            // Only update status, startTime, and breakTime - don't overwrite endTime
            ContinueDriveDBManager.shared.updateLatestContinueDriveData(
                status: status,
                startTime: DateTimeHelper.getCurrentDateTimeString(),
                breakTime: breakTimeValue
            )
            print(" ContinueDrive DB entry UPDATED: \(status) at \(DateTimeHelper.getCurrentDateTimeString())")
            print(" Break timer completed: \(breakTimeCompleted), Break time value: '\(breakTimeValue)'")
           
        } else {
            ContinueDriveDBManager.shared.saveContinueDriveData(
                userId: Int(DriverInfo.driverId ?? 0),
                status: status,
                startTime: DateTimeHelper.getCurrentDateTimeString(),
                endTime: "", // Will be updated when break timer ends
                breakTime: breakTimeValue
                
            )
            print(" ContinueDrive DB entry INSERTED: \(status) at \(DateTimeHelper.getCurrentDateTimeString())")
            print(" Break timer completed: \(breakTimeCompleted), Break time value: '\(breakTimeValue)'")
        }
    }
    
    //MARK: - Update Continue Drive DB when break timer ends
    func updateContinueDriveDBEndTime(){
        // Update the latest ContinueDrive entry with end time
        ContinueDriveDBManager.shared.updateLatestContinueDriveData(
            endTime:  DateTimeHelper.getCurrentDateTimeString()
        )
        
        print(" ContinueDrive DB end time updated at \(DateTimeHelper.getCurrentDateTimeString())")
    }
    
}

import Foundation

extension  HomeViewModel {
    // Show the next day dialog once sleep exceed to 10 hours
    func showNextShiftAlert() {
        guard currentDriverStatus == .offDuty || currentDriverStatus == .onsleep || currentDriverStatus == .personalUse else {
            return
        }
        // check whether 34 hours completed or not
        let uniqueValueForShiftChange = "shift_changed_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
        let shiftChangeAlertValue = UserDefaults.standard.string(forKey: AppConstants.shiftChanged)
        if check34HoursSleepOrOffDutyCompleted() {
            if shiftChangeAlertValue != uniqueValueForShiftChange {
                // Shift change
                AppStorageHandler.shared.is34HourStarted = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.changeShiftAfter34HoursComplete(uniqueValue: uniqueValueForShiftChange)
                }
                
                debugPrint("34 hour completed...")
            }
            
            return
        }
                
        if isCycleTimeCompleted() == false { // when cycle is running
            AppStorageHandler.shared.is34HourStarted = nil
            let nextDayAlertValue = UserDefaults.standard.string(forKey: AppConstants.nextDayAlert)
            let uniqueValueForNextDayAlert = "nextday_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
            if  check10HoursSleepOrOffDutyCompleted() && nextDayAlertValue != uniqueValueForNextDayAlert {
                // next day popup show
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.changeDayAfter10HoursCompleted(uniqueValue: uniqueValueForNextDayAlert)
                    debugPrint("Next Day Stared")
                }
                DatabaseManager.shared.deleteAllSplitShiftLogs()
            }
        }
    }
    
    // MARK: - Check Sleep Timer Completion
    
    // calucate sleep time to 10 hours to change day to next
    func calculateOffDutyAndSleepTime() -> TimeInterval {
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.day, .shift])
        
        guard !allLogs.isEmpty,
                let status = allLogs.last?.status,
                let driverStatus = DriverStatusType(fromName: status),
              (driverStatus == .onsleep || driverStatus == .offDuty || driverStatus == .personalUse) else {
            debugPrint("calculateOffDutyAndSleepTime: No logs found in database")
            return 0
        }
        // Sort logs by timestamp
        let sortedLogs = allLogs.sorted { $0.startTime > $1.startTime } // required reverse order
        
        var totalSleep: TimeInterval = 0
        for log in sortedLogs {
            let duration = getElapsedTime(lastLog: log)
            let status = DriverStatusType(fromName: log.status) ?? .none
            if status == .onsleep || status == .offDuty || driverStatus == .personalUse {
                totalSleep = duration
            } else {
                break // for other status will break the loop
            }
          }
        debugPrint("Total sleep: \(totalSleep.getHours()) hours")
        return totalSleep
    }
    
    func resetContinueDriveAfter30MinBreak() {
        resetBreakTime()
        resetContinueDriveTimeWhenMoveFromOnDrvieToOnDuty()
    }
    
    func changeDayAfter10HoursCompleted(uniqueValue: String) {
        self.resetToInitialState()
        
        TimeBox.updateDayNotification.send() // update day count on cycle timer
        AppStorageHandler.shared.days += 1
        UserDefaults.standard.setValue(uniqueValue, forKey: AppConstants.nextDayAlert)
        UserDefaults.standard.synchronize()
        calculateTimeWhenDaysIsGreaterThan8days() // When days greater than 8 days cycle
        showAlert(alertType: .nextDay)
    }
    
    func changeShiftAfter34HoursComplete(uniqueValue: String) {
        cycleMessage = ""
        AppStorageHandler.shared.is34HourStarted = nil
        AppStorageHandler.shared.shift += 1
        AppStorageHandler.shared.days = 1
        resetToInitialState(isResetCycleTimer: true)
        UserDefaults.standard.setValue(uniqueValue, forKey: AppConstants.shiftChanged)
        UserDefaults.standard.synchronize()
        
        showAlert(alertType: .shiftChange)
    }
    
    func isCycleTimeCompleted() -> Bool {
        return (cycleTimer?.remainingTime ?? 0) < 0
    }
    
    
    func check34HoursSleepOrOffDutyCompleted() -> Bool {
        let shiftChangeSleepTotalSeconds = AppStorageHandler.shared.cycleRestartTime ?? 0 // 34 hours
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        // print("Total sleep taken: \(shiftChangeSleepTotalSeconds) - \(calculatedSleepTaken)")
        return calculatedSleepTaken > TimeInterval(shiftChangeSleepTotalSeconds)// return true if calculatedSleepTaken > shiftChangeSleepTotalSeconds
    }
    
    func check10HoursSleepOrOffDutyCompleted() -> Bool {
        let totalSleepAllowed = AppStorageHandler.shared.onSleepTime ?? 0
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        return calculatedSleepTaken > TimeInterval(totalSleepAllowed)
    }
    
    func check30MinBreakCompleted(status: DriverStatusType) {
        if (breakTimer?.remainingTime ?? 0) < 0 {
            resetContinueDriveAfter30MinBreak()
        } else if status == .onDrive {
            resetBreakTime()
        }
    }
}

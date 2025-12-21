import Foundation

extension  HomeViewModel {
    // Show the next day dialog once sleep exceed to 10 hours
    func showNextShiftAlert() {
        guard currentDriverStatus == .offDuty || currentDriverStatus == .sleep else {
            return
        }
        // check whether 34 hours completed or not
        let uniqueValueForShiftChange = "shift_changed_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
        let shiftChangeAlertValue = UserDefaults.standard.string(forKey: AppConstants.shiftChanged)
        if check34HoursSleepOrOffDutyCompleted() {
            if shiftChangeAlertValue != uniqueValueForShiftChange {
                // Shift change
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.changeShiftAfter34HoursComplete(uniqueValue: uniqueValueForShiftChange)
                }
                debugPrint("34 hour completed...")
            }
            
            return
        }
                
        
        let nextDayAlertValue = UserDefaults.standard.string(forKey: AppConstants.nextDayAlert)
        let uniqueValueForNextDayAlert = "nextday_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
        if  check10HoursSleepOrOffDutyCompleted() && nextDayAlertValue != uniqueValueForNextDayAlert {
            // next day popup show
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.changeDayAfter10HoursCompleted(uniqueValue: uniqueValueForNextDayAlert)
                debugPrint("Next Day Shift Stared")
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
              (driverStatus == .sleep || driverStatus == .offDuty) else {
            debugPrint("calculateOffDutyAndSleepTime: No logs found in database")
            return 0
        }
        // Sort logs by timestamp
        let sortedLogs = allLogs.sorted { $0.timestamp > $1.timestamp } // required reverse order
        
        var totalSleep: TimeInterval = 0
        for log in sortedLogs {
            let duration = getElapsedTime(lastLog: log)
            let status = DriverStatusType(fromName: log.status) ?? .none
            if status == .sleep || status == .offDuty {
                totalSleep = duration
            } else {
                continue // for other status will break the loop
            }
          }
        debugPrint("Total sleep: \(totalSleep.getHours()) hours")
        return totalSleep
    }
    
    func changeDayAfter10HoursCompleted(uniqueValue: String) {
        showAlert(alertType: .nextDay)
        self.resetToInitialState()
        self.saveTimerStateForStatus(status: AppConstants.nextDayAlertTitle, originType: .auto, note: "Next Day Started")
        AppStorageHandler.shared.days += 1
        UserDefaults.standard.setValue(uniqueValue, forKey: AppConstants.nextDayAlert)
        calculateTimeWhenDaysIsGreaterThan8days() // When days greater than 8 days cycle
        
    }
    
    func changeShiftAfter34HoursComplete(uniqueValue: String) {
        showAlert(alertType: .shiftChange)
        cycleMessage = ""
        resetToInitialState(isResetCycleTimer: true)
        self.saveTimerStateForStatus(status: AppConstants.shiftChangeAlertTitle, originType: .auto, note: "New Shift Started")
        AppStorageHandler.shared.shift += 1
        AppStorageHandler.shared.days = 1
        UserDefaults.standard.setValue(uniqueValue, forKey: AppConstants.shiftChanged)
        UserDefaults.standard.synchronize()
    }
    
    func isCycleTimeCompleted() -> Bool {
        return (cycleTimer?.remainingTime ?? 0) <= 0
    }
    
    
    func check34HoursSleepOrOffDutyCompleted() -> Bool {
        let shiftChangeSleepTotalSeconds = AppStorageHandler.shared.cycleRestartTime ?? 0 // 34 hours
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        // print("Total sleep taken: \(shiftChangeSleepTotalSeconds) - \(calculatedSleepTaken)")
        return calculatedSleepTaken >= TimeInterval(shiftChangeSleepTotalSeconds)// return true if calculatedSleepTaken > shiftChangeSleepTotalSeconds
    }
    
    func check10HoursSleepOrOffDutyCompleted() -> Bool {
        let totalSleepAllowed = AppStorageHandler.shared.onSleepTime ?? 0
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        return calculatedSleepTaken >= TimeInterval(totalSleepAllowed)
    }
    
}

import Foundation

enum SplitShiftType: Int {
    case sleep8hours = 8
    case sleep7hours = 7
    case sleep2hours = 2
    case sleep3hours = 3
    case sleep10hours = 10
    case none = 0
    
    func getSeconds() -> TimeInterval {
        return TimeInterval(self.rawValue*60*60)
    }
    
    
}

struct SplitShiftLog {
    let id: Int
    let status: String
    let splitTime: Double
    let day: Int
    let shift: Int
    let userId: Int
}

extension HomeViewModel {
    
    func checkForSplitShift() {
        let totalSleepAndOffdutyTimeTaken = calculateOffDutyAndSleepTime()
        let totalSleepRequired = AppStorageHandler.shared.onSleepTime ?? 0
        guard let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.day, .shift]), (lastLog.status == AppConstants.onSleep || lastLog.status == AppConstants.offDuty || lastLog.status == AppConstants.personalUse), totalSleepAndOffdutyTimeTaken < totalSleepRequired else {
            return
        }
        
         if let lastSplitRecord = getLastRecordFromSplitShiftLog() {
             var totalSleep: TimeInterval = totalSleepAndOffdutyTimeTaken
             let alternateSplitType = getAlternateSplitType(duration: lastSplitRecord.splitTime)
             
             if alternateSplitType == .sleep8hours || alternateSplitType == .sleep7hours {
                 totalSleep = calculateTotalSleepTimeOnly()
             }
             
             let alternateDuration = alternateSplitType.getSeconds()
             if totalSleep > alternateDuration {
                 DatabaseManager.shared.updateIdentifier(uniqueId: lastLog.id ?? 0, identifier: 1)
                 // reset sleep time to alertnate remaining sleep
                 let remainingSleepTime = totalSleepRequired - alternateDuration
                 self.sleepTimer = CountdownTimer(startTime: remainingSleepTime)
                 updateSplitDuration(id: lastSplitRecord.id, duration: alternateDuration)
                 updateTimeAfterSplitShiftEnds()
             } else {
                 let shiftType = getSplitShiftType()
                 if shiftType != .none {
                     DatabaseManager.shared.updateIdentifier(uniqueId: lastLog.id ?? 0, identifier: 1)
                     let remainingSleepTime = totalSleepRequired - shiftType.getSeconds()
                     self.sleepTimer = CountdownTimer(startTime: remainingSleepTime)
                     updateSplitDuration(id: lastSplitRecord.id, duration: shiftType.getSeconds())
                     updateTimeAfterSplitShiftEnds()
                 } else {
                     self.sleepTimer = CountdownTimer(startTime: totalSleepRequired)
                 }
             }
         } else {
             let shiftType = getSplitShiftType()
             if shiftType != .none {
                 DatabaseManager.shared.updateIdentifier(uniqueId: lastLog.id ?? 0, identifier: 1)
                 let remainingSleepTime = totalSleepRequired - shiftType.getSeconds()
                 self.sleepTimer = CountdownTimer(startTime: remainingSleepTime)
                 saveSplitShiftRecord(for: shiftType, status: currentDriverStatus.getName())
             } else {
                 self.sleepTimer = CountdownTimer(startTime: totalSleepRequired)
             }
         }
    }
    
    func updateTimeAfterSplitShiftEnds() {
        let splitWorkTime = calculateTimeForSplitShift()
        let onDutyTime = splitWorkTime.onDuty + splitWorkTime.onDrive
        let onDriveTime = splitWorkTime.onDrive
        debugPrint("used time between sleep onDuty: \(onDutyTime.getHours()) onDrive: \(onDriveTime.getHours())")
        let remainingOnDutyTime = (AppStorageHandler.shared.onDutyTime ?? onDutyTime) - onDutyTime
        let remainingOnDriveTime = (AppStorageHandler.shared.onDriveTime ?? onDriveTime) - onDriveTime
        
        self.onDutyTimer = CountdownTimer(startTime: remainingOnDutyTime)
        self.onDriveTimer = CountdownTimer(startTime: remainingOnDriveTime)
        
        if currentDriverStatus == .onDuty {
            startTimers(for: [.onDuty, .cycleTimer])
        }
        if currentDriverStatus == .onDrive {
            startTimers(for: [.onDrive, .cycleTimer, .onDuty])
        }
      
    }
    
    func getSplitShiftType() -> SplitShiftType {
        guard !check10HoursSleepOrOffDutyCompleted() else {
            return .none
        }
        let calculatedSleepTime = calculateOffDutyAndSleepTime()
        let totalSleepTime = calculateTotalSleepTimeOnly() // used for 7 hour and 8 hours
        
        var splitShiftType: SplitShiftType = .none
        
        if calculatedSleepTime > SplitShiftType.sleep2hours.getSeconds() && calculatedSleepTime < SplitShiftType.sleep3hours.getSeconds() {
            splitShiftType = .sleep2hours
        } else if calculatedSleepTime > SplitShiftType.sleep3hours.getSeconds() && calculatedSleepTime < SplitShiftType.sleep7hours.getSeconds() {
            splitShiftType = .sleep3hours
        } else if totalSleepTime > SplitShiftType.sleep7hours.getSeconds() && calculatedSleepTime < SplitShiftType.sleep8hours.getSeconds() {
            splitShiftType = .sleep7hours
        } else if totalSleepTime > SplitShiftType.sleep8hours.getSeconds() && calculatedSleepTime < SplitShiftType.sleep10hours.getSeconds() {
            splitShiftType = .sleep8hours
        } else {
            splitShiftType = .none
            DatabaseManager.shared.deleteAllSplitShiftLogs()
        }
        return splitShiftType
    }
    
    func saveSplitShiftRecord(for shiftType: SplitShiftType, status: String) {
        DatabaseManager.shared.insertSplitShiftLog(status: status, time: shiftType.getSeconds())
    }
    
    func getLastRecordFromSplitShiftLog() -> SplitShiftLog? {
        return DatabaseManager.shared.getLastRecordForSplitShiftLog()
    }
    
    func updateSplitDuration(id: Int, duration: Double) {
        DatabaseManager.shared.updateSplitDurationForID(Int64(id), duration)
    }
    
    func getAlternateSplitType(duration: Double) -> SplitShiftType {
        var splitShiftType: SplitShiftType = .none
        switch duration {
        case SplitShiftType.sleep2hours.getSeconds():
            splitShiftType = .sleep8hours
        case SplitShiftType.sleep3hours.getSeconds():
            splitShiftType = .sleep7hours
        case SplitShiftType.sleep7hours.getSeconds():
            splitShiftType = .sleep3hours
        case SplitShiftType.sleep8hours.getSeconds():
            splitShiftType = .sleep2hours
        default:
            splitShiftType = .none
        }
        return splitShiftType
    }
}

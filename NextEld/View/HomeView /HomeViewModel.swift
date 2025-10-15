import Foundation
import SwiftUI
import Combine

enum DriverStutusType: Hashable, CaseIterable {
    case onDuty
    case offDuty
    case onDrive
    case sleep
    case personalUse
    case yardMode
    case none
    
    func getName() -> String {
        
        var title = ""
        switch self {
        case .onDuty:
            title = AppConstants.on_Duty
        case .offDuty:
            title = AppConstants.off_Duty
        case .onDrive:
            title = AppConstants.on_Drive
           case .personalUse:
            title = AppConstants.personalUse
        case .yardMode:
            title = AppConstants.yardMove
        case .sleep:
            title = AppConstants.sleep
        case .none:
            return ""
        }
        return title
    }
    
    init?(fromName name: String) {
        switch name {
        case AppConstants.on_Duty:
            self = .onDuty
        case AppConstants.off_Duty:
            self = .offDuty
        case AppConstants.on_Drive:
            self = .onDrive
        case AppConstants.personalUse:
            self = .personalUse
        case AppConstants.yardMove:
            self = .yardMode
        case AppConstants.sleep:
            self = .sleep
        default:
            return nil
        }
    }
}

enum TimerType: Hashable, CaseIterable {
    case onDuty
    case onDrive
    case breakTimer
    case sleepTimer
    case continueDrive
    case cycleTimer
    case none
    
    func getName() -> String {
        var title = ""
        switch self {
        case .onDuty:
            title = AppConstants.onDuty
        case .onDrive:
            title = AppConstants.onDrive
        case .breakTimer:
            title = AppConstants.restBreak
        case .sleepTimer:
            title = AppConstants.onSleep
        case .continueDrive:
            title = AppConstants.continueDrive
        case .cycleTimer:
            title = AppConstants.cycle
        case .none:
            return ""
        }
        return title
    }
}

enum VoilationType: Hashable {
    case onDutyVoilation
    case onContinueDriveVoilation
    case onDriveVoilation
    case cycleTimerVoilation
    case none
}

struct ViolationData: Equatable {
    var violationType: VoilationType = .none
    var thirtyMinWarning: Bool = false
    var fifteenMinWarning: Bool = false
    var violation: Bool = false
    
}
struct ViolationBoxData: Identifiable {
    let id = UUID()
    let text: String
    let date: String
    let time: String
    let timestamp: Date
}


class HomeViewModel: ObservableObject {
    
    // Driver Status to show selected status on view
    @Published var currentDriverStatus: DriverStutusType = .offDuty
    
    // Violation publiser to show alerts on view
    @Published var violationType: ViolationData = ViolationData()
    
    // Showing the alert on Home when change the driver Status
    @Published var showDriverStatusAlert: (showAlert: Bool, status: DriverStutusType) = (false, .offDuty)
    
    // Timer Publisher to show timer on view
    @Published var onDutyTimer: CountdownTimer? = nil
    @Published var cycleTimer: CountdownTimer? = nil
    @Published var breakTimer: CountdownTimer? = nil
    @Published var sleepTimer: CountdownTimer? = nil
    @Published var onDriveTimer: CountdownTimer? = nil
    @Published var continueDriveTimer: CountdownTimer? = nil
    @Published var breakTime: CountdownTimer? = nil
    @Published var refreshView: UUID = UUID()
    
    //Create #P
    @Published var isRestoringTimers: Bool = false
    var cancellable: Set<AnyCancellable> = []
    
 //   #P commit
//    init() {
//        restoreAllTimersFromLastStatus()
//    }
    
    deinit {
        debugPrint("Deinit called...")
        _ = cancellable.map({$0.cancel()})
        onDutyTimer = nil
        breakTimer = nil
        sleepTimer = nil
        onDriveTimer = nil
        cycleTimer = nil
        continueDriveTimer = nil
    }
    
    func stopTimers(for types: [TimerType]) {
        for type in types {
            switch type {
            case .onDuty:
                onDutyTimer?.stop()
            case .breakTimer:
                breakTimer?.stop()
            case .sleepTimer:
                sleepTimer?.stop()
            case .onDrive:
                onDriveTimer?.stop()
            case .continueDrive:
                continueDriveTimer?.stop()
            case .cycleTimer:
                cycleTimer?.stop()
            case .none:
                continue
            }
        }
    }
    
    func startTimers(for types: [TimerType]) {
        stopTimers(for: TimerType.allCases)
        for type in types {
            switch type {
            case .onDuty:
                onDutyTimer?.start()
            case .breakTimer:
                breakTimer?.start()
            case .sleepTimer:
                sleepTimer?.start()
            case .onDrive:
                onDriveTimer?.start()
            case .continueDrive:
                continueDriveTimer?.start()
            case .cycleTimer:
                cycleTimer?.start()
            case .none:
                continue
            }
        }
    }
    
    // MARK: - Timer Helpers #P
    func isTimerRunning(_ type: TimerType) -> Bool {
        switch type {
        case .breakTimer:
            return breakTimer?.isRunning ?? false
        case .onDuty:
            return onDutyTimer?.isRunning ?? false
        case .onDrive:
            return onDriveTimer?.isRunning ?? false
        case .cycleTimer:
            return cycleTimer?.isRunning ?? false
        case .sleepTimer:
            return sleepTimer?.isRunning ?? false
        case .continueDrive:
            return continueDriveTimer?.isRunning ?? false
        case .none:
            return false
        }
    }
    
    func resetToInitialState() {
        
        onDutyTimer = CountdownTimer(startTime: DriverInfo.onDutyTime ?? 0)
        breakTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.breakTime ?? 0))
        sleepTimer = CountdownTimer(startTime: DriverInfo.onSleepTime ?? 0)
        onDriveTimer = CountdownTimer(startTime: DriverInfo.onDriveTime ?? 0)
        continueDriveTimer = CountdownTimer(startTime: DriverInfo.continueDriveTime ?? 0)
        cycleTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.cycleTime ?? 0))
    }
    
    // MARK: - Delete All App Data
    func deleteAllAppData() {

        UserDefaults.standard.removePersistentDomain(forName: "Inurum.Technology.EldTruckTrace")
        //  Clear SessionManager token
        SessionManagerClass.shared.clearToken()
        DatabaseManager.shared.deleteAllLogs()
        stopTimers(for: TimerType.allCases)
       currentDriverStatus = .offDuty
        print(" All app data deleted successfully")
    }

    
    
    func setDriverStatus(status: DriverStutusType) {
        let previousStatus = currentDriverStatus
        currentDriverStatus = status
        
        var timerTypes: [TimerType] = []
        
        switch status {
            
        case .onDuty:
            if previousStatus == .onDrive {
                timerTypes = [.breakTimer, .onDuty, .cycleTimer]
                startBreakTimerIfNeeded()
                saveContinueDriveDB(status: AppConstants.onDuty)
            } else {
                timerTypes = [.cycleTimer, .onDuty]
            }
            
        case .onDrive:
            if let breakTimer = breakTimer {
                if isTimerRunning(.breakTimer) {
                    breakTimer.stop()
                    breakTimer.reset(startTime: breakTimer.startDuration)
                    updateContinueDriveDBEndTime()
                }
            }
            timerTypes = [.cycleTimer, .onDuty, .continueDrive, .onDrive]
            
        case .sleep:
            timerTypes = isTimerRunning(.breakTimer) ? [.sleepTimer, .breakTimer] : [.sleepTimer]
            saveContinueDriveDB(status: AppConstants.sleep)
            
        case .offDuty:
            if isTimerRunning(.breakTimer) {
                timerTypes = [.onDuty, .cycleTimer, .breakTimer]
            } else {
                timerTypes = [.breakTimer]
            }
            saveContinueDriveDB(status: AppConstants.offDuty)
            
        case .personalUse:
            timerTypes = isTimerRunning(.breakTimer) ? [.breakTimer] : [.breakTimer]
            saveContinueDriveDB(status: AppConstants.personalUse)
            
        case .yardMode:
            timerTypes = [.cycleTimer, .onDuty]
            
        case .none:
            timerTypes = []
        }
        
        startTimers(for: timerTypes)
    }

    //MARK: -  Restore All Timer

    func restoreAllTimersFromLastStatus() {
      //  isRestoringTimers = true
        print(" Restoring timers from last saved log...")

        // Fetch the last saved record from database
        guard let latestLog = DatabaseManager.shared.fetchLogs().last else {
            print(" No saved logs found. Starting fresh.")
            print(" Setting default status to Off Duty")
            currentDriverStatus = .offDuty
            resetToInitialState()
            return
        }
        
        print(" Found saved log with status: \(latestLog.status)")
        print(" Current driver status before restoration: \(currentDriverStatus.getName())")

        // Extract last saved date - use timezone-aware parsing
        guard let savedDate = DateTimeHelper.getDateFromString(latestLog.startTime) else {
            return
        }

        // Get current time in the same timezone as saved time
        let currentTime = DateTimeHelper.currentDateTime()
        
        // Time elapsed since last save (both in same timezone)
        let elapsed = currentTime.timeIntervalSince(savedDate)
        print(" Elapsed since saved: \(Int(elapsed)) sec (\(elapsed/60) min)")
        print(" Saved time: \(latestLog.startTime)")
        print(" Current time: \(DateTimeHelper.getCurrentDateTimeString())")

        onDutyTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingDutyTime ?? 0) - elapsed)

        onDriveTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingDriveTime ?? 0) - elapsed)

        cycleTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingWeeklyTime ?? 0) - elapsed)

        sleepTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingSleepTime ?? 0) - elapsed)

      //  breakTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.breakTime ?? 0) - elapsed)
        breakTimer = CountdownTimer(startTime: TimeInterval(latestLog.breaktimerRemaning ?? 0) - elapsed)

        
        continueDriveTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.continueDriveTime ?? 0) - elapsed)

        let restoredStatus = DriverStutusType(fromName: latestLog.status) ?? .none
        setDriverStatus(status: restoredStatus)
        
        // Check if break timer was running before and start it if needed
        if let breakTimeRemaining = latestLog.breaktimerRemaning, breakTimeRemaining > 0 {
            // Break timer was running before, start it
            breakTimer?.start()
            print(" Break timer auto-started after restoration: \(breakTimeRemaining) seconds remaining")
        }
        
        refreshView = UUID()

    }
    


    private func startBreakTimerIfNeeded() {
        guard let breakTimer = breakTimer else { return }
        if !isTimerRunning(.breakTimer) {
            breakTimer.start()
            print(" Break timer started (On-Drive → On-Duty transition)")
        }
    }

}

































    
    // MARK: - Helper function to map DriverStatusConstants to AppConstants format
//    private func mapDriverStatusToEnum(_ status: String) -> String {
//        switch status {
//        case DriverStatusConstants.onDuty:
//            return AppConstants.on_Duty
//        case DriverStatusConstants.onDrive:
//            return AppConstants.on_Drive
//        case DriverStatusConstants.offDuty:
//            return AppConstants.off_Duty
//        case DriverStatusConstants.onSleep:
//            return AppConstants.sleep
//        case DriverStatusConstants.personalUse:
//            return AppConstants.personalUse
//        case DriverStatusConstants.yardMove:
//            return AppConstants.yardMove
//        default:
//            return status
//        }
//    }


    //MARK: - Save current timer states before switching

//    func saveCurrentTimerStatesBeforeSwitch() {
//        // Save current timer states to our state variables
//        savedOnDutyRemaining = onDutyTimer?.remainingTime ?? 0
//        savedDriveRemaining = onDriveTimer?.remainingTime ?? 0
//        savedCycleRemaining = cycleTimer?.remainingTime ?? 0
//        savedSleepingRemaning = sleepTimer?.remainingTime ?? 0
//        savedBreakRemaining = breakTime?.remainingTime ?? 0
//        
//        print(" Saving timer states before switch:")
//        print(" OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
//        print(" Sleep: \(savedSleepingRemaning/60) min, Break: \(savedBreakRemaining/60) min")
//    }
    

    





































//    func saveEntriesToDB(type: DriverStutusType)  {
//        let remainingTime = getRemainingTime(type: type)
//        let driverModel = DriverLogModel(status: type.getName(),
//                                         startTime: <#T##String#>, userId: <#T##Int#>, day: <#T##Int#>, isVoilations: <#T##Int#>, dutyType: <#T##String#>, shift: <#T##Int#>, vehicle: <#T##String#>, isRunning: <#T##Bool#>, odometer: <#T##Double#>, engineHours: <#T##String#>, location: <#T##String#>, lat: <#T##Double#>, long: <#T##Double#>, origin: <#T##String#>, isSynced: <#T##Bool#>, vehicleId: <#T##Int#>, trailers: <#T##String#>, notes: <#T##String#>, serverId: <#T##String?#>, timestamp: <#T##Int64#>, identifier: <#T##Int#>, remainingWeeklyTime: <#T##String?#>, remainingDriveTime: <#T##String?#>, remainingDutyTime: <#T##String?#>, remainingSleepTime: <#T##String?#>, lastSleepTime: <#T##String#>, isSplit: <#T##Int#>, engineStatus: <#T##String#>, isCertifiedLog: <#T##String#>)
//
//        DatabaseManager.shared.insertLog(from: driverModel)
//    }
//    
//    func getRemainingTime(type: DriverStutusType)  -> Int {
//        switch type {
//            case .onDuty:
//
//        case .offDuty:
//            <#code#>
//        case .onDrive:
//            <#code#>
//        case .sleep:
//            <#code#>
//        case .personalUse:
//            <#code#>
//        case .yardMode:
//            <#code#>
//        case .none:
//            <#code#>
//        }
//    }
//}

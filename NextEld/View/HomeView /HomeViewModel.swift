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
    @Published var showBanner: Bool = false
    @Published var bannerMessage: String = ""
    @Published var bannerColor: Color = .green
    @Published var confirmedStatus: String? = nil
    @Published var isRestoringTimers: Bool = false
    @Published var savedOnDutyRemaining: TimeInterval = 0
    @Published var savedDriveRemaining: TimeInterval = 0
    @Published var savedCycleRemaining: TimeInterval = 0
    @Published var savedSleepingRemaning: TimeInterval = 0
    @Published var savedBreakRemaining: TimeInterval = 0
    @Published  var  isSleepTimerActive =  false
    @Published var selectedStatus: String? = nil

    @Published var isOnDutyActive: Bool = false
    @Published var isDriveActive: Bool = false
    @Published var isCycleTimerActive: Bool = false

    
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        restoreAllTimersFromLastStatus()
    }
    
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
//        print(" Starting to delete all app data...")
//
//        // 1. Clear all UserDefaults
//        let defaults = UserDefaults.standard
//        let allKeys = [
//            "driverName", "userId", "authToken", "isLoggedIn",
//            "companyId", "vehicleId", "coDriverId", "password",
//            "rememberMe", "lastLoginTime", "driverId", "clientId"
//        ]
//        allKeys.forEach { defaults.removeObject(forKey: $0) }
        UserDefaults.standard.removePersistentDomain(forName: "Inurum.Technology.EldTruckTrace")


        // 3. Clear SessionManager token
        SessionManagerClass.shared.clearToken()

        // 4. Clear Database
        DatabaseManager.shared.deleteAllLogs()

        // 5. Stop all timers
        stopTimers(for: TimerType.allCases)

        // 6. Reset all state variables
        
//        isDriveActive = false
//        isOnDutyActive = false
//        isCycleTimerActive = false
//        isSleepTimerActive = false

//        selectedStatus = DriverStatusConstants.offDuty
//        confirmedStatus = DriverStatusConstants.offDuty
        
        currentDriverStatus = .offDuty
 
//        savedDriveRemaining = 0
//        savedCycleRemaining = 0
//        savedSleepingRemaning = 0
//        savedBreakRemaining = 0
//        savedOnDutyRemaining = 0

        // 8. Reset appearance flag
      //  hasAppearedBefore = false

        // 9. Show success toast
      //  showToast(message: "All data deleted successfully", color: .green)

        print(" All app data deleted successfully")
    }

    
    func setDriverStatus(status: DriverStutusType) {
        let previousStatus = self.currentDriverStatus
        self.currentDriverStatus = status
        
        var timerTypes: [TimerType] = []
        switch status {
        case .onDuty:
            //ADD by Priyanshi
            if previousStatus == .onDrive {
                timerTypes =  [.breakTimer , .onDuty , .cycleTimer]
            } else {
                timerTypes = [.cycleTimer, .onDuty]
            }
        case .onDrive:
            
            if let breakTimer = breakTimer ,isTimerRunning(.breakTimer){
                breakTimer.stop()
                breakTimer.reset(startTime: breakTimer.startDuration)
            } else {
                timerTypes = [.cycleTimer, .onDuty , .continueDrive , .onDrive]
                print("Switched to Drive not break")
            }
            
        case .sleep:
            if isTimerRunning(.breakTimer) {
                timerTypes = [.sleepTimer , .breakTimer]
            } else {
                timerTypes = [.sleepTimer]
            }
        case .offDuty:
            timerTypes = [.breakTimer]
            
        case .personalUse:
            timerTypes = [.breakTimer]
        case .yardMode:
            timerTypes = [.cycleTimer, .onDuty]
        case .none:
            timerTypes = []
        }
        startTimers(for: timerTypes)
    }
    
    // MARK: - Save current timer states
        func saveCurrentTimerStates(){
//        guard let currentStatus = currentDriverStatus else {
//            print(" No confirmed status, cannot save timer states")
//            return
//        }
    
        // Prevent auto-save during timer restoration
//        if isRestoringTimers {
//            print(" Skipping auto-save during timer restoration")
//            return
//        }
    
//        print(" Saving timer states for status: \(currentDriverStatus)")
//        print("Current timer values - Duty: \(onDutyTimer?.timeString ?? ""), Drive: \(onDriveTimer?.timeString ?? ""), Cycle: \(cycleTimer?.timeString ?? "")")
//        print("Saved timers - OnDuty: \(savedOnDutyRemaining / 60) min, Drive: \(savedDriveRemaining / 60) min, Cycle: \(savedCycleRemaining / 60) min")

        // Use internal strings for storage (these handle negative values properly)
        let dutyTimeString = Int(onDutyTimer?.remainingTime ?? 0)
        let driveTimeString = Int(onDriveTimer?.remainingTime ?? 0)
        let cycleTimeString = Int(cycleTimer?.remainingTime ?? 0)
        let sleepTimeString = Int(sleepTimer?.remainingTime ?? 0)
        let breakTimeString = Int(breakTimer?.remainingTime ?? 0)
    
        DatabaseManager.shared.saveTimerLog(
            status: currentDriverStatus.getName(),
            startTime: DateTimeHelper.getCurrentDateTimeString(),
            dutyType: currentDriverStatus.getName(),
            remainingWeeklyTime: cycleTimeString,
            remainingDriveTime: driveTimeString,
            remainingDutyTime: dutyTimeString,
            remainingSleepTime: sleepTimeString,
            lastSleepTime: breakTimeString,
            RemaningRestBreak: "true",
            isruning: true,
            isVoilations: false
        )
      //  print(" Timer states saved successfully at \(DateTimeHelper.getCurrentDateTimeString())")
        print("Times saved - OnDuty: \(dutyTimeString), Drive: \(driveTimeString), Cycle: \(cycleTimeString)")
    }
//    // MARK: - Save current timer states
//    func saveCurrentTimerStates() 


    
    //MARK: -  Restore All Timer

    func restoreAllTimersFromLastStatus() {
      //  isRestoringTimers = true
        print(" Restoring timers from last saved log...")

        // Fetch the last saved record from database
        guard let latestLog = DatabaseManager.shared.fetchLogs().last else {
            print(" No saved logs found. Starting fresh.")
            print(" Setting default status to Off Duty")
            currentDriverStatus = .offDuty
//            confirmedStatus = DriverStatusConstants.offDuty
//            selectedStatus = DriverStatusConstants.offDuty
//            isRestoringTimers = false
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

        // Save current status for UI update
//        confirmedStatus = latestLog.status
//        selectedStatus = latestLog.status
        
        
        
        
        
        // Update the current driver status to match the restored status
//        if let restoredStatus = DriverStutusType(fromName: latestLog.status) {
//            print(" Direct mapping found for status: \(latestLog.status) -> \(restoredStatus.getName())")
//            currentDriverStatus = restoredStatus
//            print(" Restored driver status to: \(restoredStatus.getName())")
//        } else {
//            // Try to map from DriverStatusConstants to AppConstants format
//            let mappedStatus = mapDriverStatusToEnum(latestLog.status)
//            print(" Trying to map status: \(latestLog.status) -> \(mappedStatus)")
//            if let restoredStatus = DriverStutusType(fromName: mappedStatus) {
//                currentDriverStatus = restoredStatus
//                print(" Restored driver status to: \(restoredStatus.getName()) (mapped from \(latestLog.status))")
//            } else {
//                print(" Could not restore driver status: \(latestLog.status)")
//                print(" Available enum cases: \(DriverStutusType.allCases.map { $0.getName() })")
//            }
//        }
        
      //  print(" Final driver status after restoration: \(currentDriverStatus.getName())")

        // Helper: adjust remaining time by subtracting elapsed
//        func adjusted(_ saved: String?) -> TimeInterval {
//            guard let saved = saved?.asTimeInterval() else { return 0 }
//            let adjustedTime = max(saved - elapsed, 0)
//            print(" Original saved time: \(saved/60) min, Elapsed: \(elapsed/60) min, Adjusted: \(adjustedTime/60) min")
//            return adjustedTime
//        }
//        
//        // Helper: check if timer should be started (has positive remaining time)
//        func shouldStartTimer(_ timer: CountdownTimer?, adjustedTime: TimeInterval) -> Bool {
//            guard let timer = timer else { return false }
//            return adjustedTime > 0
//        }

        // Stop all running timers before restore
        

        // Restore each timer
       // let adjustedDuty = adjusted(latestLog.remainingDutyTime)
        onDutyTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingDutyTime ?? 0) - elapsed)
//        print(" OnDutyTimer reset with start time: \(formatTime(adjustedDuty))")
//        print(" OnDutyTimer remaining time after reset: \(formatTime(onDutyTimer?.remainingTime ?? 0))")
//        print(" OnDutyTimer original saved: \(latestLog.remainingDutyTime ?? "nil")")
        
      //  let adjustedDrive = adjusted(latestLog.remainingDriveTime)
        onDriveTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingDriveTime ?? 0) - elapsed)
//        print(" DriveTimer reset to: \(formatTime(adjustedDrive))")
//        print(" DriveTimer remaining time after reset: \(formatTime(onDriveTimer?.remainingTime ?? 0))")
//        print(" DriveTimer original saved: \(latestLog.remainingDriveTime ?? "nil")")

     //   let adjustedCycle = adjusted(latestLog.remainingWeeklyTime)
        cycleTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingWeeklyTime ?? 0) - elapsed)
//        print(" CycleTimer reset to: \(formatTime(adjustedCycle))")
//        print(" CycleTimer remaining time after reset: \(formatTime(cycleTimer?.remainingTime ?? 0))")
//        print(" CycleTimer original saved: \(latestLog.remainingWeeklyTime ?? "nil")")

     //   let adjustedSleep = adjusted(latestLog.remainingSleepTime)
        sleepTimer = CountdownTimer(startTime: TimeInterval(latestLog.remainingSleepTime ?? 0) - elapsed)
//        print(" SleepTimer reset to: \(formatTime(adjustedSleep))")
//        print(" SleepTimer remaining time after reset: \(formatTime(sleepTimer?.remainingTime ?? 0))")

      //  let adjustedBreak = adjusted(latestLog.lastSleepTime)
        breakTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.breakTime ?? 0) - elapsed)
        
        continueDriveTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.continueDriveTime ?? 0) - elapsed)
//        print(" BreakTimer reset to: \(formatTime(adjustedBreak))")
//        print(" BreakTimer remaining time after reset: \(formatTime(breakTimer?.remainingTime ?? 0))")
        let restoredStatus = DriverStutusType(fromName: latestLog.status) ?? .offDuty
        setDriverStatus(status: restoredStatus)
        refreshView = UUID()
        //  Restart based on last status
//        switch currentDriverStatus {
//        case .onDuty:
//            guard let onDutyTimer, let cycleTimer else { return }
//            if onDutyTimer.remainingTime > 0 {
//                startTimers(for: [.onDuty])
//            }
//            
//            if cycleTimer.remainingTime > 0 {
//                startTimers(for: [.cycleTimer])
//            }
////            if shouldStartTimer(onDutyTimer, adjustedTime: adjustedDuty) {
////                print(" Starting OnDuty timer - before start: \(formatTime(onDutyTimer?.remainingTime ?? 0))")
////                onDutyTimer?.start()
////                print(" Started OnDuty timer with remaining time: \(formatTime(adjustedDuty))")
////                print(" OnDuty timer after start - remaining: \(formatTime(onDutyTimer?.remainingTime ?? 0)), running: \(onDutyTimer?.isRunning ?? false)")
////            } else {
////                print(" OnDuty timer not started - remaining time: \(formatTime(adjustedDuty))")
////            }
////            if shouldStartTimer(cycleTimer, adjustedTime: adjustedCycle) {
////                print(" Starting Cycle timer - before start: \(formatTime(cycleTimer?.remainingTime ?? 0))")
////                cycleTimer?.start()
////                print(" Started Cycle timer with remaining time: \(formatTime(adjustedCycle))")
////                print(" Cycle timer after start - remaining: \(formatTime(cycleTimer?.remainingTime ?? 0)), running: \(cycleTimer?.isRunning ?? false)")
////            } else {
////                print(" Cycle timer not started - remaining time: \(formatTime(adjustedCycle))")
////            }
//
//        case .onDrive:
//            guard let onDriveTimer, let onDutyTimer, let cycleTimer else { return }
//            if onDutyTimer.remainingTime > 0 {
//                startTimers(for: [.onDuty])
//            }
//            
//            if cycleTimer.remainingTime > 0 {
//                startTimers(for: [.cycleTimer])
//            }
//            
//            if onDriveTimer.remainingTime > 0 {
//                startTimers(for: [.onDrive])
//            }
//            
//            
////            if shouldStartTimer(onDriveTimer, adjustedTime: adjustedDrive) {
////                onDriveTimer?.start()
////                print(" Started OnDrive timer with remaining time: \(formatTime(adjustedDrive))")
////            } else {
////                print(" OnDrive timer not started - remaining time: \(formatTime(adjustedDrive))")
////            }
////            if shouldStartTimer(onDutyTimer, adjustedTime: adjustedDuty) {
////                onDutyTimer?.start()
////                print(" Started OnDuty timer with remaining time: \(formatTime(adjustedDuty))")
////            } else {
////                print(" OnDuty timer not started - remaining time: \(formatTime(adjustedDuty))")
////            }
////            if shouldStartTimer(cycleTimer, adjustedTime: adjustedCycle) {
////                cycleTimer?.start()
////                print(" Started Cycle timer with remaining time: \(formatTime(adjustedCycle))")
////            } else {
////                print(" Cycle timer not started - remaining time: \(formatTime(adjustedCycle))")
////            }
//
//        case .sleep:
//            guard let sleepTimer else { return }
//            if sleepTimer.remainingTime > 0 {
//                startTimers(for: [.sleepTimer])
//            }
////            if shouldStartTimer(sleepTimer, adjustedTime: adjustedSleep) {
////                sleepTimer?.start()
////                print(" Started Sleep timer with remaining time: \(formatTime(adjustedSleep))")
////            } else {
////                print(" Sleep timer not started - remaining time: \(formatTime(adjustedSleep))")
////            }
//
//        case .offDuty, .personalUse:
//            guard let breakTimer else { return }
//            if breakTimer.remainingTime > 0 {
//                startTimers(for: [.breakTimer])
//            }
////            if shouldStartTimer(breakTimer, adjustedTime: adjustedBreak) {
////                breakTimer?.start()
////                print(" Started Break timer with remaining time: \(formatTime(adjustedBreak))")
////            } else {
////                print(" Break timer not started - remaining time: \(formatTime(adjustedBreak))")
////            }
//        case .yardMode:
//            break
//        case .none:
//            break
//        }

//        print("""
//         Timers restored successfully:
//           Status: \(latestLog.status)
//           Current Driver Status: \(currentDriverStatus.getName())
//           Confirmed Status: \(confirmedStatus ?? "nil")
//           Selected Status: \(selectedStatus ?? "nil")
//            Duty: \(formatTime(onDutyTimer?.remainingTime ?? 0)) (Running: \(onDutyTimer?.isRunning ?? false))
//            Drive: \(formatTime(onDriveTimer?.remainingTime ?? 0)) (Running: \(onDriveTimer?.isRunning ?? false))
//            Cycle: \(formatTime(cycleTimer?.remainingTime ?? 0)) (Running: \(cycleTimer?.isRunning ?? false))
//           Sleep: \(formatTime(sleepTimer?.remainingTime ?? 0)) (Running: \(sleepTimer?.isRunning ?? false))
//           Break: \(formatTime(breakTimer?.remainingTime ?? 0)) (Running: \(breakTimer?.isRunning ?? false))
//        """)

      //  isRestoringTimers = false
    }
    
    // MARK: - Helper function to parse saved date with timezone awareness
    private func parseSavedDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: DriverInfo.timezone)
        return formatter.date(from: dateString)
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

    func saveCurrentTimerStatesBeforeSwitch() {
        // Save current timer states to our state variables
        savedOnDutyRemaining = onDutyTimer?.remainingTime ?? 0
        savedDriveRemaining = onDriveTimer?.remainingTime ?? 0
        savedCycleRemaining = cycleTimer?.remainingTime ?? 0
        savedSleepingRemaning = sleepTimer?.remainingTime ?? 0
        savedBreakRemaining = breakTime?.remainingTime ?? 0
        
        print(" Saving timer states before switch:")
        print(" OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
        print(" Sleep: \(savedSleepingRemaning/60) min, Break: \(savedBreakRemaining/60) min")
    }
    
    
    // MARK: - Save timer state for specific status
    func saveTimerStateForStatus(status: String, note: String) {
        print("Saving timer state for status: \(status)")

        // Safely unwrap all timer strings (use internal strings for consistency)
        let dutyTimeString = onDutyTimer?.remainingTime
        let driveTimeString = onDriveTimer?.remainingTime
        let cycleTimeString = cycleTimer?.remainingTime
        let sleepTimeString = sleepTimer?.remainingTime
        let breakTimeString = breakTimer?.remainingTime

        // Save to database using your existing method
        DatabaseManager.shared.saveTimerLog(
            status: status,
            startTime: DateTimeHelper.getCurrentDateTimeString(),
            dutyType: status,
            remainingWeeklyTime: Int(cycleTimeString  ?? 0),
            remainingDriveTime: Int(driveTimeString  ?? 0) ,
            remainingDutyTime: Int(dutyTimeString  ?? 0),
            remainingSleepTime: Int(sleepTimeString  ?? 0),
            lastSleepTime: Int(breakTimeString  ?? 0),
            RemaningRestBreak: "true",
            isruning: true,
            isVoilations: false
        )

        print(" Timer state saved successfully for \(status)")
    }

    
}

    





































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

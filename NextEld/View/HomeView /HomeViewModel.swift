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

    @Published  var showSyncconfirmation  =  false
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


    
    
    func setDriverStatus(status: DriverStutusType, restoreBreakTimerRunning: Bool = false) {
        let previousStatus = currentDriverStatus
        currentDriverStatus = status

        var timerTypes: [TimerType] = []

        switch status {

        case .onDuty:
            
            timerTypes = [.onDuty, .cycleTimer]
            if restoreBreakTimerRunning {
                timerTypes.append(.breakTimer) // include break timer to start
            }
            if previousStatus == .onDrive{
                timerTypes.append(.continueDrive)
                saveContinueDriveDB(status: AppConstants.onDuty)
                timerTypes = [.breakTimer , .onDuty, .cycleTimer]
            }

        case .onDrive:
            
            if let breakTimer = breakTimer, isTimerRunning(.breakTimer) {
               // breakTimer.reset(startTime: breakTimer.startDuration)
                breakTimer.reset(startTime: Double(DriverInfo.breakTime ?? 0))
                breakTimer.stop()
                updateContinueDriveDBEndTime()
            }
            timerTypes = [.cycleTimer, .onDuty, .continueDrive, .onDrive, ]

        case .sleep:
            timerTypes = [.sleepTimer]
            if restoreBreakTimerRunning {
                timerTypes.append(.breakTimer)
            }
            timerTypes = [.breakTimer, .sleepTimer]
            saveContinueDriveDB(status: AppConstants.sleep)

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

        // Explicitly start break timer if restoring after app relaunch
        if restoreBreakTimerRunning, let breakTimer = breakTimer, !breakTimer.isRunning {
            breakTimer.start()
            print("Break timer auto-started on app launch")
        }
    }

    

    
    // # changes by priyanshi - compact + safe version
    
    func restoreAllTimersFromLastStatus() {
        print("Restoring timers from last saved log...")

        guard let latestLog = DatabaseManager.shared.fetchLogs().last else {
            currentDriverStatus = .offDuty
            resetToInitialState()
            return
        }

        guard let savedDate = DateTimeHelper.getDateFromString(latestLog.startTime) else { return }
        let elapsed = DateTimeHelper.currentDateTime().timeIntervalSince(savedDate)
        let status = DriverStutusType(fromName: latestLog.status) ?? .none

        func adjusted(_ value: Int?, active: Bool) -> TimeInterval {
            let time = TimeInterval(value ?? 0)
            return active ? max(0, time - elapsed) : time
        }

        // Active flags
        let isOnDuty  = (status == .onDuty)
        let isDrive   = (status == .onDrive)
        let isSleep   = (status == .sleep)
        let isCycle   = !(status == .offDuty || status == .sleep)
        let isContDrv = (status == .onDrive)

        // Timers
        onDutyTimer        = CountdownTimer(startTime: adjusted(latestLog.remainingDutyTime, active: isOnDuty))
        onDriveTimer       = CountdownTimer(startTime: adjusted(latestLog.remainingDriveTime, active: isDrive))
        cycleTimer         = CountdownTimer(startTime: adjusted(latestLog.remainingWeeklyTime, active: isCycle))
        sleepTimer         = CountdownTimer(startTime: adjusted(latestLog.remainingSleepTime, active: isSleep))
        continueDriveTimer = CountdownTimer(startTime: adjusted(Int(DriverInfo.continueDriveTime ?? 0), active: isContDrv))

        // Break timer
        let breakSaved = TimeInterval(latestLog.breaktimerRemaning ?? 0)
        let breakRunning = breakSaved > 0 && status != .onDrive
        let breakRemain = breakRunning ? max(0, breakSaved - elapsed) : breakSaved
        breakTimer = CountdownTimer(startTime: breakRemain)

        // Resume
        setDriverStatus(status: status, restoreBreakTimerRunning: breakRunning)
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

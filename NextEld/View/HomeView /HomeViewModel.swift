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

enum ViolationType: Hashable {
    case onDutyViolation
    case onContinueDriveViolation
    case onDriveViolation
    case cycleTimerViolation
    case none
    
    func getFifteenMinWarningText() -> String {
        switch self {
        case .onDutyViolation:
            return AppConstants.onDuty
        case .onContinueDriveViolation:
            return AppConstants.continueDrive
        case .onDriveViolation:
            return AppConstants.onDrive
        case .cycleTimerViolation:
            return AppConstants.cycle
        case .none:
            return ""
        }
    }
    
    func getThirtyMinWarningText() -> String {
        switch self {
        case .onDutyViolation:
            return AppConstants.onDuty
        case .onContinueDriveViolation:
            return AppConstants.continueDrive
        case .onDriveViolation:
            return AppConstants.onDrive
        case .cycleTimerViolation:
            return AppConstants.cycle
        case .none:
            return ""
        }
    }
    
    func getViolationText() -> String {
        switch self {
        case .onDutyViolation:
            return AppConstants.onDuty
        case .onContinueDriveViolation:
            return AppConstants.continueDrive
        case .onDriveViolation:
            return AppConstants.onDrive
        case .cycleTimerViolation:
            return AppConstants.cycle
        case .none:
            return ""
        }
    }
    
    
}

struct ViolationData: Equatable {
    var violationType: ViolationType = .none
    var thirtyMinWarning: Bool = false
    var fifteenMinWarning: Bool = false
    var violation: Bool = false
    
    func getWarningText() -> String {
        var warningText: String = ""
        if self.thirtyMinWarning {
            warningText = violationType.getThirtyMinWarningText()
        }
        if self.fifteenMinWarning {
            warningText  = violationType.getFifteenMinWarningText()
        }
        if violation {
            warningText  = violationType.getViolationText()
        }
        return warningText
    }
    
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
    @Published var violationDataArray: [ViolationData] = []

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
    var cancellable: Set<AnyCancellable> = []
    
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
            if isTimerRunning(.breakTimer) {
                breakTimer?.stop()
                breakTimer?.reset(startTime: breakTimer?.startDuration ?? 0)
                updateContinueDriveDBEndTime()
            }
            timerTypes = [.cycleTimer, .onDuty, .continueDrive, .onDrive]
            
//            if let breakTimer = breakTimer, isTimerRunning(.breakTimer) {
//               // breakTimer.reset(startTime: breakTimer.startDuration)
//                breakTimer.reset(startTime: Double(DriverInfo.breakTime ?? 0))
//                breakTimer.stop()
//                updateContinueDriveDBEndTime()
//            }
//            timerTypes = [.cycleTimer, .onDuty, .continueDrive, .onDrive, ]

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
        guard let latestLog = DatabaseManager.shared.fetchLogs().last else {
            currentDriverStatus = .offDuty
            resetToInitialState()
            return
        }
        let elapsed = getElapsedTime(lastLog: latestLog)
        let status = DriverStutusType(fromName: latestLog.status) ?? .none

        // Active flags
        let isOnDuty  = (status == .onDuty)
        let isDrive   = (status == .onDrive)
        let isSleep   = (status == .sleep)
        let isCycle   = !(status == .offDuty || status == .sleep)
        let isContDrv = (status == .onDrive)
        let isBreak   = TimeInterval(latestLog.breaktimerRemaning ?? 0) > 0 && status != .onDrive

        let onDutyRemainingTime = adjusted(latestLog.remainingDutyTime, elapsed: elapsed, active: isOnDuty)
        let onDriveRemainingTime = adjusted(latestLog.remainingDriveTime, elapsed: elapsed, active: isDrive)
        let cycleRemainingTime = adjusted(latestLog.remainingWeeklyTime, elapsed: elapsed, active: isCycle)
        let sleepRemainingTime = adjusted(latestLog.remainingSleepTime, elapsed: elapsed, active: isSleep)
        let continueDriveRemainingTime = adjusted(Int(DriverInfo.continueDriveTime ?? 0), elapsed: elapsed, active: isContDrv)
        let breakRemainingTime = adjusted(Int(DriverInfo.breakTime ?? 0), elapsed: elapsed, active: isBreak)
        
        
        // Timers
        onDutyTimer        = CountdownTimer(startTime: onDutyRemainingTime)
        onDriveTimer       = CountdownTimer(startTime: onDriveRemainingTime)
        cycleTimer         = CountdownTimer(startTime: cycleRemainingTime)
        sleepTimer         = CountdownTimer(startTime: sleepRemainingTime)
        continueDriveTimer = CountdownTimer(startTime: continueDriveRemainingTime)
        breakTimer         = CountdownTimer(startTime: breakRemainingTime)

        // Resume
        setDriverStatus(status: status, restoreBreakTimerRunning: isBreak)
        refreshView = UUID()
    }

    func adjusted(_ value: Int?, elapsed: TimeInterval, active: Bool) -> TimeInterval {
        let time = TimeInterval(value ?? 0)
        return active ? max(0, time - elapsed) : time
    }
    
    
    private func getElapsedTime(lastLog: DriverLogModel) -> TimeInterval {
        
        guard let savedDate = DateTimeHelper.getDateFromString(lastLog.startTime) else {
            return 0
        }

        // Get current time in the same timezone as saved time
        let currentTime = DateTimeHelper.currentDateTime()
        
        // Time elapsed since last save (both in same timezone)
        let elapsed = currentTime.timeIntervalSince(savedDate)
        
        print("Difference in current time and last saved time : \(elapsed)")
        
        return elapsed
    }
    
    
    func onChangeRemaingTime(type: TimerType, remainigTime: TimeInterval) {
        switch type {
        case .onDuty:
            let warning1 = TimeInterval(Int(DriverInfo.onDutyTime ?? 0) - Int(DriverInfo.setWarningOnDutyTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.onDutyTime ?? 0) - Int(DriverInfo.setWarningOnDutyTime2 ?? 0))
            checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onDutyViolation)
        case .onDrive:
            let warning1 = TimeInterval(Int(DriverInfo.onDriveTime ?? 0) - Int(DriverInfo.setWarningOnDriveTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.onDriveTime ?? 0) - Int(DriverInfo.setWarningOnDriveTime2 ?? 0))
            checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onDriveViolation)
        case .breakTimer:
            break
        case .sleepTimer:
            break
        case .continueDrive:
            break
        case .cycleTimer:
            break
        case .none:
            break
        }
    }
    
    func checkViolation(for warning1: TimeInterval, for warning2: TimeInterval, remainingTime: TimeInterval, type: ViolationType) {
        var violationData = ViolationData()
        if remainingTime <= 0 {
            // Violation
            violationData.violation = true
        } else if remainingTime <= warning1 && remainingTime > 0 {
            violationData.fifteenMinWarning = true
        } else if remainingTime <= warning2 && remainingTime > warning1 {
            violationData.thirtyMinWarning = true
        }
        if violationData.violationType != .none {
            violationData.violationType = .onDutyViolation
            violationDataArray.append(violationData)
        }
    }

}

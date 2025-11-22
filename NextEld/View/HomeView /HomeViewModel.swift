import Foundation
import SwiftUI
import Combine


enum AlertType {
    case nextDay
    case refresh
    case deleteLogs
    case sucessConfimration
    case shiftChange
    case thirtyFourHours
    case splitShiftEnds
    
    
    func getTitle() -> String {
        
        var title = ""
        switch self {
            
        case .nextDay:
            title = AppConstants.NextDay
        case .refresh:
            title = AppConstants.RefreshLog
        case .deleteLogs:
            title = AppConstants.DeleteLog
        case .sucessConfimration:
            title = AppConstants.Successalert
        case .shiftChange:
            title = AppConstants.shiftChangeAlertTitle
        case .thirtyFourHours:
            title = ""
        case .splitShiftEnds:
            title = ""
        }
        return title
    }
    
    func getMessage() -> String {
        
        var message = ""
        
        switch self {
            
        case .nextDay:
            message = AppConstants.NextDaymessage
        case .refresh:
            message =  AppConstants.Refreshmessage
        case .deleteLogs:
            message =  AppConstants.Deletemessage
        case .sucessConfimration:
            message =  AppConstants.Successalert
        case .shiftChange:
            message = AppConstants.shiftChangeMessage
        case .thirtyFourHours:
            message = AppConstants.thirtyFourHourAlertMsg
        case .splitShiftEnds:
            message = AppConstants.splitShiftEndsMsg
        }
        return message
    }
    
    func showCancelButton() -> Bool {
        return false
    }
    
    func okButtonTitle() -> Bool {
        return false
    }
}

enum DriverStatusType: Hashable, CaseIterable {
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
        let normalized = name
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
        
        switch normalized {
        case "on_duty", "onduty":
            self = .onDuty
        case "off_duty", "offduty":
            self = .offDuty
        case "on_drive", "ondrive", "drive", "driving":
            self = .onDrive
        case "sleep", "sleeper", "on_sleep", "onsleep":
            self = .sleep
        case "personal_use", "personaluse", "personal_conveyance":
            self = .personalUse
        case "yard_mode", "yardmode", "yard_move", "yardmove":
            self = .yardMode
        default:
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
}

enum TimerType: Hashable, CaseIterable {
    case onDuty
    case onDrive
    case breakTimer
    case sleepTimer
    case continueDrive
    case cycleTimer
    case none
    
    func getName() -> LocalizedStringKey {
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
        return title.localised()
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
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.onDutyTime ?? 0) - Int(AppStorageHandler.shared.warningOnDutyTime2 ?? 0))
            return "\(warning2.getMin()) min left for completing your on duty cycle"
        case .onContinueDriveViolation:
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.continueDriveTime ?? 0) - Int(AppStorageHandler.shared.warningBreakTime2 ?? 0))
            return "\(warning2.getMin()) min left for completing your continue drive cycle"
        case .onDriveViolation:
            let warning2 = TimeInterval(Int( AppStorageHandler.shared.onDriveTime  ?? 0) - Int(AppStorageHandler.shared.warningOnDriveTime2  ?? 0))
            return "\(warning2.getMin()) min left for completing your drive cycle"
        case .cycleTimerViolation:
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.cycleTime ?? 0) - (Int(AppConstants.cycleTime15MinTime) ?? 0))
            return "\(warning2.getMin()) min left for completing your day cycle"
        case .none:
            return ""
        }
    }
    
    func getThirtyMinWarningText() -> String {
        switch self {
        case .onDutyViolation:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.onDutyTime ?? 0) - Int(AppStorageHandler.shared.warningOnDutyTime1 ?? 0))
            return "\(warning1.getMin()) min left for completing your on duty cycle"
        case .onContinueDriveViolation:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.continueDriveTime ?? 0) - Int(AppStorageHandler.shared.warningBreakTime1 ?? 0))
            return "\(warning1.getMin()) min left for completing your continue drive cycle"
        case .onDriveViolation:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.onDriveTime ?? 0) - Int(AppStorageHandler.shared.warningOnDriveTime1 ?? 0))
            return "\(warning1.getMin()) min left for completing your drive cycle"
        case .cycleTimerViolation:
             let warning1 = TimeInterval(Int(AppStorageHandler.shared.cycleTime ?? 0) - (Int(AppConstants.cycleTime30MinTime) ?? 0))
            return "\(warning1.getMin()) min left for completing your day cycle"
        case .none:
            return ""
        }
    }
    
    func getViolationText() -> String {
        switch self {
        case .onDutyViolation:
            return "Your duty time has been exceeded to \(Double(AppStorageHandler.shared.onDutyTime?.getHours() ?? 0)) hours"
        case .onContinueDriveViolation:
            return "Your continue drive time has been exceeded to \(Double(AppStorageHandler.shared.continueDriveTime?.getHours() ?? 0)) hours"
        case .onDriveViolation:
            return "Your drive time has been exceeded to \(Double(AppStorageHandler.shared.onDriveTime?.getHours() ?? 0)) hours"
        case .cycleTimerViolation:
            return "Your cycle time has been exceeded to \(Double(AppStorageHandler.shared.cycleTime ?? 0).getHours()) hours"
        case .none:
            return ""
        }
    }
}




struct ViolationData: Equatable {
    var id = UUID()
    var violationType: ViolationType = .none
    var thirtyMinWarning: Bool = false
    var fifteenMinWarning: Bool = false
    var violation: Bool = false
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
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
    
    func getTitle() -> String {
        var warningTitle: String = AppConstants.warning
        if violation {
            warningTitle  = AppConstants.violation
        }
        return warningTitle
    }
    
    func getBackground() -> Color {
        var warningColor: Color = .orange
        if self.thirtyMinWarning {
            warningColor = .orange
        }
        if self.fifteenMinWarning {
            warningColor  = .yellow
        }
        if violation {
            warningColor  = .red
        }
        return warningColor
    }
    
}

struct ViolationBoxData: Identifiable {
    let id = UUID()
    let text: String
    let date: String
    let time: String
    let timestamp: Date
    let type: ViolationBoxType
}


class HomeViewModel: ObservableObject {
    
    // Driver Status to show selected status on view
    @Published var currentDriverStatus: DriverStatusType = .offDuty
    
    // Violation publiser to show alerts on view
    @Published var violationDataArray: [ViolationData] = []

    // Showing the alert on Home when change the driver Status
    @Published var showDriverStatusAlert: (showAlert: Bool, status: DriverStatusType) = (false, .offDuty)
    @Published var showAlertOnHomeScreen: Bool = false
    // Events
    @Published var graphEvents: [HOSEvent] = []
    @Published  var showAddDvirPopup = false

    @Published var showSyncconfirmation: Bool = false
 
    // Timer Publisher to show timer on view
    @Published var onDutyTimer: CountdownTimer? = nil
    @Published var cycleTimer: CountdownTimer? = nil
    @Published var breakTimer: CountdownTimer? = nil
    @Published var sleepTimer: CountdownTimer? = nil
    @Published var onDriveTimer: CountdownTimer? = nil
    @Published var continueDriveTimer: CountdownTimer? = nil
    @Published var breakTime: CountdownTimer? = nil
    @Published var refreshView: UUID = UUID()
    
    var alertType: AlertType = .sucessConfimration
    
    // SyncViewModel for syncOfflineData API
    let syncViewModel: SyncViewModel = SyncViewModel()
    
    //Create #P
    var cancellable: Set<AnyCancellable> = []
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    let syncTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    init() {
        restoreAllTimersFromLastStatus()
        validateScenarioInEveryMinute()
        timer
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.validateScenarioInEveryMinute()
                self?.addIntermediateLogs()
            }
            .store(in: &cancellable)
        
        // Timer to call syncOfflineData every 10 seconds
        syncTimer
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.syncViewModel.syncOfflineData()
                }
            }
            .store(in: &cancellable)
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
    
    func validateScenarioInEveryMinute() {
        self.loadEventsFromDatabase()
        showNextShiftAlert()
        checkForViolation()
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
    
    func resetToInitialState(isResetCycleTimer: Bool = false, cycleTime: Int = 0)  {
        onDutyTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.onDutyTime ?? 0))
        breakTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.breakTime ?? 0))
        sleepTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.onSleepTime ?? 0))
        onDriveTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.onDriveTime ?? 0))
        continueDriveTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.continueDriveTime ?? 0))
        if isResetCycleTimer {
            cycleTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.cycleTime ?? 0))
        } else if cycleTime != 0 {
            cycleTimer = CountdownTimer(startTime: TimeInterval(cycleTime))
        }
        currentDriverStatus = .offDuty
        self.loadEventsFromDatabase()
       // setupTimerCallbacks()
    }
    
    // MARK: - Delete All App Data
    func deleteAllAppData() {
        
        stopTimers(for: TimerType.allCases)
        UserDefaults.standard.removePersistentDomain(forName: "Inurum.Technology.EldTruckTrace")
        //  Clear SessionManager token
        SessionManagerClass.shared.clearToken()
        DatabaseManager.shared.deleteAllLogs()
        currentDriverStatus = .offDuty
        print(" All app data deleted successfully")
    }
    
    func setDriverStatus(status: DriverStatusType, restoreBreakTimerRunning: Bool = false, note: String? = nil, saveLogsToDatabase: Bool = false) {
        let previousStatus = currentDriverStatus
        currentDriverStatus = status

        var timerTypes: [TimerType] = []

        switch status {

        case .onDuty:
            checkedOffDutyTimeIsLessThan2Hour()
            checkForSplitShift()
            timerTypes = [.onDuty, .cycleTimer]
            if previousStatus == .onDrive {
                timerTypes = [.breakTimer , .onDuty, .cycleTimer, .continueDrive]
                saveContinueDriveDB(status: AppConstants.onDuty)
            }

        case .onDrive:
            checkedOffDutyTimeIsLessThan2Hour()
            checkForSplitShift()
            if isTimerRunning(.breakTimer) {
                breakTimer?.reset(startTime: breakTimer?.startDuration ?? 0)
                breakTimer?.stop()
                updateContinueDriveDBEndTime()
            }
            timerTypes = [.cycleTimer, .onDuty, .continueDrive, .onDrive]
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
       
        if saveLogsToDatabase {
            saveTimerStateForStatus(status: status.getName(), note: note)
        }
        startTimers(for: timerTypes)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            self?.loadEventsFromDatabase()
        }
        

        // Explicitly start break timer if restoring after app relaunch
//        if restoreBreakTimerRunning, let breakTimer = breakTimer, !breakTimer.isRunning {
//            breakTimer.start()
//            print("Break timer auto-started on app launch")
//        }
//        
    }

    func checkedOffDutyTimeIsLessThan2Hour()  {
        // off duty time is less than two hours and next status != sleep then time should dedut from OnDuty
        guard let lastRecord = DatabaseManager.shared.getLastRecordOfDriverLogs(),
        let status = DriverStatusType(fromName: lastRecord.status) else {
            return
        }
        let elapsed = getElapsedTime(lastLog: lastRecord)
        let twoHrs = TimeInterval(60*60*2)
        
        if status == .offDuty && elapsed < twoHrs  {
            let onDutyRemainingTime = adjusted(lastRecord.remainingDutyTime, elapsed: elapsed, active: true)
            onDutyTimer = CountdownTimer(startTime: onDutyRemainingTime)
            onDutyTimer?.start()
        }
    }

    
    // # changes by priyanshi - compact + safe version
    
    func restoreAllTimersFromLastStatus() {
        
        var lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.day])
        guard let latestLog = lastLog else {
            if let lastRecordFromDB = DatabaseManager.shared.getLastRecordOfDriverLogs() {
                lastLog = lastRecordFromDB
                resetToInitialState(cycleTime: lastLog?.remainingWeeklyTime ?? 0)
            } else {
                resetToInitialState(isResetCycleTimer: true)
            }
            return
        }
        
        let elapsed = getElapsedTime(lastLog: latestLog)
        let status = DriverStatusType(fromName: latestLog.status) ?? .none

        // Active flags
        let isYardMove = (status == .yardMode)
        let isDrive   = (status == .onDrive)
        let isOnDuty  = (status == .onDuty) || isDrive || isYardMove
        let isSleep   = (status == .sleep)
        let isCycle   = !(status == .offDuty || status == .sleep)
        let isContDrv = (status == .onDrive)
        let isBreak   = TimeInterval(latestLog.breaktimerRemaning ?? 0) > 0 && status != .onDrive

        let onDutyRemainingTime = adjusted(latestLog.remainingDutyTime, elapsed: elapsed, active: isOnDuty)
        let onDriveRemainingTime = adjusted(latestLog.remainingDriveTime, elapsed: elapsed, active: isDrive)
        let cycleRemainingTime = adjusted(latestLog.remainingWeeklyTime, elapsed: elapsed, active: isCycle)
        let sleepRemainingTime = adjusted(latestLog.remainingSleepTime, elapsed: elapsed, active: isSleep)
        let continueDriveRemainingTime = adjusted(Int(AppStorageHandler.shared.continueDriveTime ?? 0), elapsed: elapsed, active: isContDrv)
        let breakRemainingTime = adjusted(Int(AppStorageHandler.shared.breakTime ?? 0), elapsed: elapsed, active: isBreak)
        
        
        // Timers
        onDutyTimer        = CountdownTimer(startTime: onDutyRemainingTime)
        onDriveTimer       = CountdownTimer(startTime: onDriveRemainingTime)
        cycleTimer         = CountdownTimer(startTime: cycleRemainingTime)
        sleepTimer         = CountdownTimer(startTime: sleepRemainingTime)
        continueDriveTimer = CountdownTimer(startTime: continueDriveRemainingTime)
        breakTimer         = CountdownTimer(startTime: breakRemainingTime)

        // Setup callbacks for restored timers
      //  setupTimerCallbacks()

        // Resume
        setDriverStatus(status: status, restoreBreakTimerRunning: isBreak)
    }

    func adjusted(_ value: Int?, elapsed: TimeInterval, active: Bool) -> TimeInterval {
        let time = TimeInterval(value ?? 0)
        return active ? (time - elapsed) : time//active ? max(0, time - elapsed) : time
    }
    
    
    private func getElapsedTime(lastLog: DriverLogModel) -> TimeInterval {
        
        // Get current time in the same timezone as saved time
        let currentTime = DateTimeHelper.currentDateTime()
        
        // Time elapsed since last save (both in same timezone)
        let elapsed = currentTime.timeIntervalSince(lastLog.startTime)
        
        print("Difference in current time and last saved time : \(elapsed)")
        
        return elapsed
    }
    
    
    func onChangeRemaingTime(type: TimerType, remainigTime: TimeInterval) {
        
        switch type {
        case .onDuty:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.onDutyTime ?? 0) - Int(AppStorageHandler.shared.warningOnDutyTime1 ?? 0))
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.onDutyTime ?? 0) - Int(AppStorageHandler.shared.warningOnDutyTime2 ?? 0))
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onDutyViolation, violationKey: AppConstants.onDutyViolationKey)
            }
        case .onDrive:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.onDriveTime ?? 0) - Int(AppStorageHandler.shared.warningOnDriveTime1 ?? 0))
            let warning2 = TimeInterval(Int( AppStorageHandler.shared.onDriveTime  ?? 0) - Int(AppStorageHandler.shared.warningOnDriveTime2  ?? 0))
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onDriveViolation, violationKey: AppConstants.onDriveViolationKey)
            }
            
        case .continueDrive:
            // For continue drive, we can use the same warning times as onDrive or create separate ones
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.continueDriveTime ?? 0) - Int(AppStorageHandler.shared.warningBreakTime1 ?? 0))
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.continueDriveTime ?? 0) - Int(AppStorageHandler.shared.warningBreakTime2 ?? 0)) - 900
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onContinueDriveViolation, violationKey: AppConstants.continueDriveViolationKey)
            }
        case .cycleTimer:
            // For cycle timer, we can use similar warning logic
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.cycleTime ?? 0) - (Int(AppConstants.cycleTime30MinTime) ?? 0)) // 30 min
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.cycleTime ?? 0) - (Int(AppConstants.cycleTime15MinTime) ?? 0)) // 15 min
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .cycleTimerViolation, violationKey: AppConstants.cycleTimeViolationKey)
            }
        case .breakTimer:
            break
        case .sleepTimer:
            
            break
        case .none:
            break
        }
    }
    
    func checkViolation(for warning1: TimeInterval, for warning2: TimeInterval, remainingTime: TimeInterval, type: ViolationType, violationKey: String) {

        // Check if we've already shown this warning/violation today
        let lastViolationDate = UserDefaults.standard.string(forKey: violationKey)
        let lastViolationDate15min = UserDefaults.standard.string(forKey: violationKey + "_15min")
        let lastViolationDate30Min = UserDefaults.standard.string(forKey: violationKey + "_30min")
        let uniqueValueForViolation = "\(violationKey)_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
        let uniqueValueForViolation30Min = "\(violationKey)_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)_30min"
        let uniqueValueForViolation15min = "\(violationKey)_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)_15min"
        
        debugPrint("remainingTime-----------------------\(remainingTime)")
        debugPrint("Current Value--------->\(uniqueValueForViolation)")
        debugPrint("\(violationKey)-------->\(lastViolationDate ?? "nil")")
        debugPrint("\(violationKey + "_15min")-------->\(lastViolationDate15min ?? "nil")")
        debugPrint("\(violationKey + "_30min")-------->\(lastViolationDate30Min ?? "nil")")
        debugPrint("-----------------------")
        
        guard let violationDate = remainingTime < 0 ? DateTimeHelper.calendar.date(byAdding: .second, value: Int(remainingTime), to: DateTimeHelper.currentDateTime()) : DateTimeHelper.currentDateTime() else {
            return
        }

        if remainingTime < warning1 && remainingTime > warning2 && lastViolationDate30Min != uniqueValueForViolation30Min {
            var violationData = ViolationData()
            violationData.violationType = type
            violationData.thirtyMinWarning = true // 30 min warning
            self.violationDataArray.append(violationData)
            UserDefaults.standard.setValue(uniqueValueForViolation30Min, forKey: violationKey + "_30min")
            saveViolation(for: violationData, date: violationDate)
        } else if remainingTime <= warning2 && remainingTime > 0 && lastViolationDate15min != uniqueValueForViolation15min {
            if lastViolationDate30Min != uniqueValueForViolation30Min {
                var violationData = ViolationData()
                violationData.violationType = type
                violationData.thirtyMinWarning = true
                self.violationDataArray.append(violationData)
                saveViolation(for: violationData, date: DateTimeHelper.get15MinBeforeDate(date: violationDate))
                UserDefaults.standard.setValue(uniqueValueForViolation30Min, forKey: violationKey + "_30min")
            }
            
            var violationData = ViolationData()
            violationData.violationType = type
            violationData.fifteenMinWarning = true // 15 min warning
            self.violationDataArray.append(violationData)
            saveViolation(for: violationData, date: violationDate)
            UserDefaults.standard.setValue(uniqueValueForViolation15min, forKey: violationKey + "_15min")
        } else if remainingTime <= 0, uniqueValueForViolation != lastViolationDate {
            // This two condition will work when remaining time directly goes to <= 0
            if lastViolationDate30Min != uniqueValueForViolation30Min {
                var violationData = ViolationData()
                violationData.violationType = type
                violationData.thirtyMinWarning = true
                self.violationDataArray.append(violationData)
                saveViolation(for: violationData, date: DateTimeHelper.get30MinBeforeDate(date: violationDate))
                UserDefaults.standard.setValue(uniqueValueForViolation30Min, forKey: violationKey + "_30min")
            }
            
            if lastViolationDate15min != uniqueValueForViolation15min {
                var violationData = ViolationData()
                violationData.violationType = type
                violationData.fifteenMinWarning = true
                self.violationDataArray.append(violationData)
                saveViolation(for: violationData, date: DateTimeHelper.get15MinBeforeDate(date: violationDate))
                UserDefaults.standard.setValue(uniqueValueForViolation15min, forKey: violationKey + "_15min")
            }
            
            // Violation
            var violationData = ViolationData()
            violationData.violationType = type
            violationData.violation = true
            UserDefaults.standard.setValue(uniqueValueForViolation, forKey: violationKey)
            self.violationDataArray.append(violationData)
            saveViolation(for: violationData, date: violationDate)
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Check Sleep Timer Completion
    
    // calucate sleep time to 10 hours to change day to next
    func calculateOffDutyAndSleepTime() -> TimeInterval {
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.day])
        
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
                break // for other status will break the loop
            }
          }
        debugPrint("Total sleep: \(totalSleep.getHours()) hours")
        return totalSleep
    }
    
    // Show the next day dialog once sleep exceed to 10 hours
    func showNextShiftAlert() {
        // check whether 34 hours completed or not
        let uniqueValueForShiftChange = "shift_changed_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
        let shiftChangeAlertValue = UserDefaults.standard.string(forKey: AppConstants.shiftChanged)
        if check34HoursSleepOrOffDutyCompleted() && shiftChangeAlertValue != uniqueValueForShiftChange {
            // Shift change
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.changeShiftAfter34HoursComplete(uniqueValue: uniqueValueForShiftChange)
            }
            debugPrint("34 hour completed...")
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
    
    // Reset Break Time if Break time is less than 30 min
    func checkWheterBreakTimeIsOver(previousStatus: DriverStatusType) {
        let remainingBreakTime = self.breakTimer?.remainingTime ?? 0
        if previousStatus == .onDrive, currentDriverStatus != .offDuty, remainingBreakTime >= 0 {
            breakTimer?.stop()
            breakTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.breakTime ?? 0))
        }
    }
    
    func checkForViolation() {
        if let continueDriveTimer {
            onChangeRemaingTime(type: .continueDrive, remainigTime: continueDriveTimer.remainingTime)
        }
        if let onDriveTimer {
            onChangeRemaingTime(type: .onDrive, remainigTime: onDriveTimer.remainingTime)
        }
        if let onDutyTimer {
            onChangeRemaingTime(type: .onDuty, remainigTime: onDutyTimer.remainingTime)
        }
        if let cycleTimer {
            onChangeRemaingTime(type: .cycleTimer, remainigTime: cycleTimer.remainingTime)
        }
    }
    
    func changeDayAfter10HoursCompleted(uniqueValue: String) {
        self.alertType = .nextDay
        self.showAlertOnHomeScreen = true
        self.resetToInitialState()
        self.saveTimerStateForStatus(status: AppConstants.nextDayAlertTitle, note: "Next Day Started")
        AppStorageHandler.shared.days += 1
        UserDefaults.standard.setValue(uniqueValue, forKey: AppConstants.nextDayAlert)
        calculateTimeWhenDaysIsGreaterThan8days() // When days greater than 8 days cycle
        
    }
    
    func changeShiftAfter34HoursComplete(uniqueValue: String) {
        self.alertType = .shiftChange
        self.showAlertOnHomeScreen = true
        resetToInitialState(isResetCycleTimer: true)
        self.saveTimerStateForStatus(status: AppConstants.shiftChangeAlertTitle, note: "New Shift Started")
        AppStorageHandler.shared.shift += 1
        AppStorageHandler.shared.days = 1
        UserDefaults.standard.setValue(uniqueValue, forKey: AppConstants.shiftChanged)
        
    }
    
    func check34HoursSleepOrOffDutyCompleted() -> Bool {
        let shiftChangeSleepTotalSeconds = AppStorageHandler.shared.cycleRestartTime ?? 0 // 34 hours
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        print("Total sleep taken: \(shiftChangeSleepTotalSeconds) - \(calculatedSleepTaken)")
        return calculatedSleepTaken >= TimeInterval(shiftChangeSleepTotalSeconds)// return true if calculatedSleepTaken > shiftChangeSleepTotalSeconds
    }
    
    func check10HoursSleepOrOffDutyCompleted() -> Bool {
        let totalSleepAllowed = AppStorageHandler.shared.onSleepTime ?? 0
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        return calculatedSleepTaken >= TimeInterval(totalSleepAllowed)
    }
    
    func addIntermediateLogs() {
        guard let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.day]), lastLog.status == AppConstants.on_Drive else {
            return
        }
        AppStorageHandler.shared.origin = OriginType.intermediate.description
        let startTime = lastLog.startTime
        let afterOneHourTime = DateTimeHelper.calendar.date(byAdding: .hour, value: 1, to: startTime) ?? DateTimeHelper.currentDateTime()
        let currentTime = DateTimeHelper.currentDateTime()
        if afterOneHourTime <= currentTime && lastLog.odometer != .zero {
            saveTimerStateForStatus(status: lastLog.status, date: afterOneHourTime)
        }
    }
    
    func calculateTimeWhenDaysIsGreaterThan8days() {
        guard let lastRecord = DatabaseManager.shared.getLastRecordOfDriverLogs(),
        AppStorageHandler.shared.days > 8 else {
            return
        }
        
        let onDutyTime = AppStorageHandler.shared.onDutyTime ?? 0
        let onDriveTime = AppStorageHandler.shared.onDriveTime ?? 0
        var remainingCycleTime: TimeInterval = DatabaseManager.shared.getRemainingCycleTime()
        var remainingOnDutyTime: TimeInterval = onDutyTime
        var remainingOnDriveTime: TimeInterval = onDriveTime
        if let workEntry = DatabaseManager.shared.getRecapeAfterSevenDays() {
            let totalTime = workEntry.hoursWorked + remainingCycleTime
            if totalTime > onDutyTime {
                remainingCycleTime =  onDutyTime
                DatabaseManager.shared.updateValues(id: lastRecord.id ?? 0, remainingCycleTime: remainingCycleTime)
            } else if totalTime > onDriveTime && totalTime <= onDutyTime {
                remainingCycleTime = totalTime
                remainingOnDutyTime = totalTime
                DatabaseManager.shared.updateValues(id: lastRecord.id ?? 0, remainingCycleTime: remainingCycleTime, remainingOnDutyTime: remainingOnDutyTime)
            } else if totalTime < onDriveTime {
                remainingCycleTime = totalTime
                remainingOnDutyTime = totalTime
                remainingOnDriveTime = totalTime
                DatabaseManager.shared.updateValues(id: lastRecord.id ?? 0, remainingCycleTime: remainingCycleTime, remainingOnDutyTime: remainingOnDutyTime, remainingOnDriveTime: remainingOnDriveTime)
            }
            
            onDutyTimer = CountdownTimer(startTime: remainingOnDutyTime)
            cycleTimer = CountdownTimer(startTime: remainingCycleTime)
            onDriveTimer = CountdownTimer(startTime: remainingOnDriveTime)
            
        }
    }
}

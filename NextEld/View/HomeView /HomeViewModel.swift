import Foundation
import SwiftUI
import Combine

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
    case breakTimerViolation
    case none
    
    func getFifteenMinWarningText() -> String {
        switch self {
        case .onDutyViolation:
            return "\(Double(DriverInfo.setWarningOnDutyTime2 ?? 0).getMin()) min left for completing your on duty cycle"
        case .onContinueDriveViolation:
            return "\(Double(DriverInfo.setWarningOnDriveTime2 ?? 0).getMin()) min left for completing your continue drive cycle"
        case .onDriveViolation:
            return "\(Double(DriverInfo.setWarningOnDriveTime2 ?? 0).getMin()) min left for completing your drive cycle"
        case .cycleTimerViolation:
            return "\(Double(DriverInfo.setWarningOnDutyTime2 ?? 0).getMin()) min left for completing your day cycle"
        case .none:
            return ""
        case .breakTimerViolation:
            return "\(Double(DriverInfo.warningBreakTime2 ?? 0).getMin()) min left for completing your day cycle"
        }
    }
    
    func getThirtyMinWarningText() -> String {
        switch self {
        case .onDutyViolation:
            return "\(Double(DriverInfo.setWarningOnDutyTime1 ?? 0).getMin()) min left for completing your on duty cycle"
        case .onContinueDriveViolation:
            return "\(Double(DriverInfo.setWarningOnDriveTime1 ?? 0).getMin()) min left for completing your continue drive cycle"
        case .onDriveViolation:
            return "\(Double(DriverInfo.setWarningOnDriveTime1 ?? 0).getMin()) min left for completing your drive cycle"
        case .cycleTimerViolation:
            return "\(Double(DriverInfo.setWarningOnDutyTime1 ?? 0).getMin()) min left for completing your day cycle"
        case .none:
            return ""
        case .breakTimerViolation:
            return "\(Double(DriverInfo.warningBreakTime1 ?? 0).getMin()) min left for completing your day cycle"
        }
    }
    
    func getViolationText() -> String {
        switch self {
        case .onDutyViolation:
            return "Your duty time has been exceeded to \(Int(DriverInfo.onDutyTime?.getHours() ?? 0)) hours"
        case .onContinueDriveViolation:
            return "Your continue drive time has been exceeded to \(Int(DriverInfo.continueDriveTime?.getHours() ?? 0)) hours"
        case .onDriveViolation:
            return "Your drive time has been exceeded to \(Int(DriverInfo.onDriveTime?.getHours() ?? 0)) hours"
        case .cycleTimerViolation:
            return "Your cycle time has been exceeded to \(Double(DriverInfo.cycleTime ?? 0).getHours()) hours"
        case .none:
            return ""
        case .breakTimerViolation:
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
    
    // Events
    @Published var graphEvents: [HOSEvent] = []
    
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
    @Published var showNextDayShiftAlert: Bool = false
    
    //Create #P
    var cancellable: Set<AnyCancellable> = []
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init() {
        restoreAllTimersFromLastStatus()
        self.loadEventsFromDatabase()
        showNextShiftAlert()
        timer
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.loadEventsFromDatabase()
                self?.showNextShiftAlert()
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
        currentDriverStatus = .offDuty
        self.loadEventsFromDatabase()
        setupTimerCallbacks()
    }
    
    // MARK: - Setup Timer Callbacks
    func setupTimerCallbacks() {
        // On Duty Timer Callback
        onDutyTimer?.onTimeChanged = { [weak self] remainingTime in
            self?.onChangeRemaingTime(type: .onDuty, remainigTime: remainingTime)
        }
        
        // On Drive Timer Callback
        onDriveTimer?.onTimeChanged = { [weak self] remainingTime in
            self?.onChangeRemaingTime(type: .onDrive, remainigTime: remainingTime)
        }
        
        // Cycle Timer Callback
        cycleTimer?.onTimeChanged = { [weak self] remainingTime in
            self?.onChangeRemaingTime(type: .cycleTimer, remainigTime: remainingTime)
        }
        
        // Continue Drive Timer Callback
        continueDriveTimer?.onTimeChanged = { [weak self] remainingTime in
            self?.onChangeRemaingTime(type: .continueDrive, remainigTime: remainingTime)
        }
        
        breakTimer?.onTimeChanged = { [weak self] remainingTime in
            self?.onChangeRemaingTime(type: .breakTimer, remainigTime: remainingTime)
        }
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
    
    func setDriverStatus(status: DriverStatusType, restoreBreakTimerRunning: Bool = false) {
        let previousStatus = currentDriverStatus
        currentDriverStatus = status

        var timerTypes: [TimerType] = []

        switch status {

        case .onDuty:
            checkedOffDutyTimeIsLessThan2Hour()
            timerTypes = [.onDuty, .cycleTimer]
            if previousStatus == .onDrive {
                timerTypes = [.breakTimer , .onDuty, .cycleTimer]
                saveContinueDriveDB(status: AppConstants.onDuty)
            }
        case .onDrive:
            checkedOffDutyTimeIsLessThan2Hour()
            if isTimerRunning(.breakTimer) {
                breakTimer?.reset(startTime: breakTimer?.startDuration ?? 0)
                breakTimer?.stop()
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
        

//        // Explicitly start break timer if restoring after app relaunch
//        if restoreBreakTimerRunning, let breakTimer = breakTimer, !breakTimer.isRunning {
//            breakTimer.start()
//            print("Break timer auto-started on app launch")
//        }
        
        loadEventsFromDatabase()
        
    }

    func checkedOffDutyTimeIsLessThan2Hour()  {
        // off duty time is less than two hours and next status != sleep then time should dedut from OnDuty
        guard let lastRecord = DatabaseManager.shared.getLastRecordOfDriverLogs(),
        let status = DriverStatusType(fromName: lastRecord.status) else {
            return
        }
        let elapsed = getElapsedTime(lastLog: lastRecord)
        let twoHrs = TimeInterval(60*60*2)
        
        if status == .offDuty && (currentDriverStatus == .onDuty || currentDriverStatus == .onDrive) && elapsed < twoHrs  {
            self.onDutyTimer?.remainingTime -= elapsed
        }
    }

    
    // # changes by priyanshi - compact + safe version
    
    func restoreAllTimersFromLastStatus() {
        guard let latestLog = DatabaseManager.shared.getLastRecordOfDriverLogs() else {
            resetToInitialState()
            return
        }
        let elapsed = getElapsedTime(lastLog: latestLog)
        let status = DriverStatusType(fromName: latestLog.status) ?? .none

        // Active flags
        let isDrive   = (status == .onDrive)
        let isOnDuty  = (status == .onDuty) || isDrive
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

        // Setup callbacks for restored timers
        setupTimerCallbacks()

        // Resume
        setDriverStatus(status: status, restoreBreakTimerRunning: isBreak)
    }

    func adjusted(_ value: Int?, elapsed: TimeInterval, active: Bool) -> TimeInterval {
        let time = TimeInterval(value ?? 0)
        return active ? max(0, time - elapsed) : time
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
        //for print value
        let seconds:Double =  3600
     //   print(" Timer Changed - Type: \(type), Remaining: \(remainigTime/seconds) hours")
        
        switch type {
        case .onDuty:
            let warning1 = TimeInterval(Int(DriverInfo.onDutyTime ?? 0) - Int(DriverInfo.setWarningOnDutyTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.onDutyTime ?? 0) - Int(DriverInfo.setWarningOnDutyTime2 ?? 0))
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onDutyViolation, violationKey: AppConstants.onDutyViolationKey)
            }
        case .onDrive:
            let warning1 = TimeInterval(Int(DriverInfo.onDriveTime ?? 0) - Int(DriverInfo.setWarningOnDriveTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.onDriveTime ?? 0) - Int(DriverInfo.setWarningOnDriveTime2 ?? 0))
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onDriveViolation, violationKey: AppConstants.onDriveViolationKey)
            }
            
        case .continueDrive:
            // For continue drive, we can use the same warning times as onDrive or create separate ones
            let warning1 = TimeInterval(Int(DriverInfo.onDriveTime ?? 0) - Int(DriverInfo.setWarningOnDriveTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.onDriveTime ?? 0) - Int(DriverInfo.setWarningOnDriveTime2 ?? 0))
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .onContinueDriveViolation, violationKey: AppConstants.continueDriveViolationKey)
            }
        case .cycleTimer:
            // For cycle timer, we can use similar warning logic
            let warning1 = TimeInterval(Int(DriverInfo.cycleTime ?? 0) - Int(DriverInfo.setWarningOnDutyTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.cycleTime ?? 0) - Int(DriverInfo.setWarningOnDutyTime2 ?? 0))
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .cycleTimerViolation, violationKey: AppConstants.cycleTimeViolationKey)
            }
        case .breakTimer:
            let warning1 = TimeInterval(Int(DriverInfo.breakTime ?? 0) - Int(DriverInfo.warningBreakTime1 ?? 0))
            let warning2 = TimeInterval(Int(DriverInfo.breakTime ?? 0) - Int(DriverInfo.warningBreakTime2 ?? 0))
            
            if remainigTime <= warning1 {
                checkViolation(for: warning1, for: warning2, remainingTime: remainigTime, type: .cycleTimerViolation, violationKey: AppConstants.breakTimeViolationKey)
            }
            break
        case .sleepTimer:
            
            break
        case .none:
            break
        }
    }
    
    func checkViolation(for warning1: TimeInterval, for warning2: TimeInterval, remainingTime: TimeInterval, type: ViolationType, violationKey: String) {
        
        var violationData = ViolationData()
        violationData.violationType = type
        
        // Check if we've already shown this warning/violation today
        let lastViolationDate = UserDefaults.standard.string(forKey: violationKey)
        let lastViolationDate15min = UserDefaults.standard.string(forKey: violationKey + "_15min")
        let lastViolationDate30Min = UserDefaults.standard.string(forKey: violationKey + "_30min")
        let todayString = DateTimeHelper.currentDate()
        
        if remainingTime <= 0, todayString != lastViolationDate, type != .breakTimerViolation {
            // Violation
            violationData.violation = true
            UserDefaults.standard.setValue(todayString, forKey: violationKey)
            
            // This two condition will work when remaining time directly goes to <= 0
            if lastViolationDate15min != todayString {
                UserDefaults.standard.setValue(todayString, forKey: violationKey + "_15min")
            }
            if lastViolationDate30Min != todayString {
                UserDefaults.standard.setValue(todayString, forKey: violationKey + "_30min")
            }
        }
        if remainingTime <= warning2 && remainingTime > 0 && lastViolationDate15min != todayString {
            violationData.fifteenMinWarning = true // 15 min warning
            UserDefaults.standard.setValue(todayString, forKey: violationKey + "_15min")
        }
        if remainingTime <= warning1 && remainingTime > warning2 && lastViolationDate30Min != todayString {
            violationData.thirtyMinWarning = true // 30 min warning
            UserDefaults.standard.setValue(todayString, forKey: violationKey + "_30min")
        }
        
        // Only add if there's actually a warning or violation
        if violationData.violation || violationData.fifteenMinWarning || violationData.thirtyMinWarning {
            violationDataArray.append(violationData)
            saveViolation(for: violationData) // save violation to Local DB
        }
    }
    
    // calucate sleep time to 10 hours to change day to next
    func calculateOffDutyAndSleepTime() -> TimeInterval {
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.getTodayRecord, .day])
        
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
        let currentTime = DateTimeHelper.currentDateTime()
        for (index, log) in sortedLogs.enumerated() {
            let startTime = log.startTime
            let endTime: Date
            
            // If this is the last log, use current time
            if index == sortedLogs.count - 1 {
                endTime = currentTime
            } else {
                // Use the start time of the next log as end time
                endTime = sortedLogs[index + 1].startTime
            }
            
            let duration = endTime.timeIntervalSince(startTime)
            let status = DriverStatusType(fromName: log.status) ?? .none
            
            if status == .sleep || status == .offDuty {
                totalSleep += duration
            } else {
                break // for other status will break the loop
            }
          }
        debugPrint("Total sleep: \(totalSleep.getHours())")
        return totalSleep
    }
    
    // Show the next day dialog once sleep exceed to 10 hours
    func showNextShiftAlert() {
        let totalSleepAllowed = DriverInfo.onSleepTime ?? 0
        let calculatedSleepTaken = self.calculateOffDutyAndSleepTime()
        
        if calculatedSleepTaken >= totalSleepAllowed {
            // next day popup show
            self.showNextDayShiftAlert = true
            UserDefaults.standard.set(DriverInfo.Days+1, forKey: AppStorageKeys.Days)
            resetToInitialState()
            debugPrint("Next Day Shift Stared")
        }
    
    }
    
    // Reset Break Time if Break time is less than 30 min
    func checkWheterBreakTimeIsOver(previousStatus: DriverStatusType) {
        let remainingBreakTime = self.breakTimer?.remainingTime ?? 0
        if previousStatus == .onDrive, currentDriverStatus != .offDuty, remainingBreakTime >= 0 {
            breakTimer?.stop()
            breakTimer = CountdownTimer(startTime: TimeInterval(DriverInfo.breakTime ?? 0))
        }
    }
}

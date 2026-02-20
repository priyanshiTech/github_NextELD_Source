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
    case idleState
    case logoutOFFSleepDuty
    case cycleComplete
    //MARK: DVIR Alert
    
    
    
    
    
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
        case .idleState:
            title = ""
        case .logoutOFFSleepDuty:
            title = AppConstants.logoutOffDutyAlert
        case .cycleComplete:
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
        case .idleState:
            return "you are idle from 10 minutes, Do you want to switch to on duty"
        case .logoutOFFSleepDuty:
            message = "Please change your duty status to Off Duty before logging out."
        case .cycleComplete:
            message = "Your cycle is completed, You need to rest for 34 hours to start a new shift"
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
    case onsleep
    case personalUse
    case yardMode
    case none
    
    //MARK: - ui shows
    
    
   
    func getName() -> String {
        
        var title = ""
        
        switch self {
            
        case .onDuty:
            title = AppConstants.onDuty
        case .offDuty:
            title = AppConstants.offDuty
        case .onDrive:
            title = AppConstants.onDrive
        case .personalUse: 
            title = AppConstants.personalUse
        case .yardMode:
            title = AppConstants.yardMove
        case .onsleep:
            title = AppConstants.onSleep
        case .none:
            return ""
        }
        return title
    }
    
    func displayNameForCircle() -> String {
        switch self {
        case .onDrive:
            return "Drive"
        case .onsleep:
            return "Sleep"
        default:
            return getName()   // baaki same
        }
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
            self = .onsleep
        case "personal_use", "personaluse", "personal_conveyance":
            self = .personalUse
        case "yard_mode", "yardmode", "yard_move", "yardmove":
            self = .yardMode
            
        default:
            switch name {
            case AppConstants.onDuty:
                self = .onDuty
            case AppConstants.offDuty:
                self = .offDuty
            case AppConstants.onDrive:
                self = .onDrive
            case AppConstants.personalUse:
                self = .personalUse
            case AppConstants.yardMove:
                self = .yardMode
            case AppConstants.onSleep:
                self = .onsleep
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
            return "you have \(warning2.getMin()) minutes left to  complete your on duty cycle for today"
            
        case .onContinueDriveViolation:
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.continueDriveTime ?? 0) - Int(AppStorageHandler.shared.warningBreakTime2 ?? 0))
            return "you have \(warning2.getMin()) minutes left to  complete your on drive cycle for today"
            
        case .onDriveViolation:
            let warning2 = TimeInterval(Int( AppStorageHandler.shared.onDriveTime  ?? 0) - Int(AppStorageHandler.shared.warningOnDriveTime2  ?? 0))
            return "you have \(warning2.getMin()) minutes left to complete your Drive cycle for today"
            
        case .cycleTimerViolation:
            let warning2 = TimeInterval(Int(AppStorageHandler.shared.cycleTime ?? 0) - (Int(AppConstants.cycleTime15MinTime) ?? 0))
            return "you have \(warning2.getMin()) minutes left to complete your  cycle for today"
            
        case .none:
            return ""
        }
    }
    
    func getThirtyMinWarningText() -> String {
        switch self {
            
        case .onDutyViolation:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.onDutyTime ?? 0) - Int(AppStorageHandler.shared.warningOnDutyTime1 ?? 0))
            return " You have \(warning1.getMin()) minutes left to complete your on-duty cycle for today"
            
        case .onContinueDriveViolation:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.continueDriveTime ?? 0) - Int(AppStorageHandler.shared.warningBreakTime1 ?? 0))
            return "You have \(warning1.getMin()) minutes left to complete your Continue Drive cycle for today"
            
        case .onDriveViolation:
            let warning1 = TimeInterval(Int(AppStorageHandler.shared.onDriveTime ?? 0) - Int(AppStorageHandler.shared.warningOnDriveTime1 ?? 0))
            return "You have \(warning1.getMin()) minutes left to complete your  on-Drive cycle for today"
            
        case .cycleTimerViolation:
             let warning1 = TimeInterval(Int(AppStorageHandler.shared.cycleTime ?? 0) - (Int(AppConstants.cycleTime30MinTime) ?? 0))
            return "You have \(warning1.getMin()) minutes left to complete your  cycle for today"
        case .none:
            return ""
        }
    }
    
    func getViolationText() -> String {
        switch self {
        case .onDutyViolation:
            return "Your Onduty time has exceeded \(AppStorageHandler.shared.onDutyTime?.getHours() ?? 0) hours"
        case .onContinueDriveViolation:
            return "Your continue drive time has exceeded \(AppStorageHandler.shared.continueDriveTime?.getHours() ?? 0) hours"
        case .onDriveViolation:
            return "Your drive time has exceeded \(AppStorageHandler.shared.onDriveTime?.getHours() ?? 0) hours"
        case .cycleTimerViolation:
            return "Your cycle time has exceeded \(Double(AppStorageHandler.shared.cycleTime ?? 0).getHours())/\(AppStorageHandler.shared.cycleDays ?? 0) hours"
        case .none:
            return ""
        }
    }
}




struct ViolationData: Equatable, Hashable {
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

//Notification when the Engine start
extension Notification.Name {
    static let engineStartStopNotification = Notification.Name("engineStartStop")
}


class HomeViewModel: ObservableObject, Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(currentDriverStatus)
    }
    
    static func == (lhs: HomeViewModel, rhs: HomeViewModel) -> Bool {
        return lhs.currentDriverStatus == rhs.currentDriverStatus
    }
    
    // Driver Status to show selected status on view
    @Published var currentDriverStatus: DriverStatusType = .offDuty
    
    // Violation publiser to show alerts on view
    @Published var violationDataArray: [ViolationData] = []

    // Showing the alert on Home when change the driver Status
    @Published var showDriverStatusAlert: (showAlert: Bool, status: DriverStatusType) = (false, .offDuty)
    @Published var showAlertOnHomeScreen: Bool = false
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
    @Published var refreshView: UUID = UUID()
    
    // Flag used in Home screen
    @Published var showLogoutPopup: Bool = false
    @Published var presentSideMenu: Bool = false
    @Published var displayLoader: Bool = false
    @Published var cycleMessage: String = ""
    
    // Block screen management
    @Published var showBlockScreen: Bool = false
    
    // Speed tracking for block/unblock logic (internal access for extension)
    var highSpeedList: [TimeInterval] = []  // Timestamps for speed > 5
    var lowSpeedList: [TimeInterval] = []   // Timestamps for speed <= 5
    let SPEED_WINDOW: TimeInterval = 60.0   // 60 seconds window
    
    // Cooldown period after manual dismissal (in seconds)
    var blockScreenCooldownUntil: TimeInterval? = nil
    let BLOCK_SCREEN_COOLDOWN: TimeInterval = 5.0  // 5 seconds cooldown
    
    var alertType: AlertType = .sucessConfimration
    // SyncViewModel for syncOfflineData API
    let syncViewModel: SyncViewModel = SyncViewModel()
    let certifySyncViewModel = CertifiedOfflineViewModel()
    let DVIRDataViewModel = DVIROfflineViewModel()
    
    
    //Create #P
    var cancellable: Set<AnyCancellable> = []
    let apiCallTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    let serviceTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    init() {
        checkWhetherTheViolationAlreadyExists()
        restoreAllTimersFromLastStatus()
        validateScenarioInEveryMinute()
        checkForSplitShift()
        serviceTimer
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.validateScenarioInEveryMinute()
                self?.addIntermediateLogs()
            }
            .store(in: &cancellable)
        
        apiCallTimer
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                Task { @MainActor in
                    // Sync offline data
                    await self?.syncViewModel.syncOfflineData()
                  
                    let certifySuccess = await self?.certifySyncViewModel.syncCertifiedOfflineLogs()
                    if certifySuccess == false {
                        print(" Certified offline logs sync failed: \(self?.certifySyncViewModel.syncMessage ?? "Unknown error")")
                    }
                    // Sync DVIR offline logs with error handling
                    let dvirSuccess = await self?.DVIRDataViewModel.syncDVIROfflineLogs()
                    if dvirSuccess == false {
                        print(" DVIR offline logs sync failed: \(self?.DVIRDataViewModel.syncMessage ?? "Unknown error")")
                    }
                }
                
            }
            .store(in: &cancellable)
        
        // Device Values receive here...
        NotificationCenter.default.publisher(for: .engineStartStopNotification)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] notification in
                self?.hadleDeviceValues(notification: notification)
            })
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
        
        AppStorageHandler.shared.remainingContinueDriveTime = Int(AppStorageHandler.shared.continueDriveTime ?? 0)
        print("continueDriveTime===1", AppStorageHandler.shared.continueDriveTime ?? 0)
        print("remainingContinueDriveTime===1", AppStorageHandler.shared.remainingContinueDriveTime)
        
        AppStorageHandler.shared.remainingBreakTime = AppStorageHandler.shared.breakTime ?? 0
        currentDriverStatus = .offDuty
        self.loadEventsFromDatabase()
       // setupTimerCallbacks()
    }
    
    // MARK: - Delete All App Data
    func deleteAllAppData(){
        
        SharedInfoManager.shared.centralManager?.stopScan()
        stopTimers(for: TimerType.allCases)
        AppStorageHandler.shared.shift = 1
        AppStorageHandler.shared.days = 1
        //  Clear SessionManager token
        
        currentDriverStatus = .offDuty
        resetToInitialState()
        AppStorageHandler.shared.deleteAll()
        DatabaseManager.shared.deleteAllLogs()                          //Clears driverLogs and splitShiftTable
        ContinueDriveDBManager.shared.deleteAllContinueDriveData()
        DvirDatabaseManager.shared.deleteAllRecordsForDvirDataBase()
        CertifyDatabaseManager.shared.deleteAllCertifyRecords()
        UserDefaults.standard.synchronize()
        // print(" All app data deleted successfully")
        
    }
    
    func setDriverStatus(status: DriverStatusType, note: String? = nil, saveLogsToDatabase: Bool = false) {
        let previousStatus = currentDriverStatus
        currentDriverStatus = status
   //     AppStorageHandler.shared.isContinueDriveTimeRunning = false
        var timerTypes: [TimerType] = []

        switch status {

        case .onDuty:
            checkedOffDutyTimeIsLessThan2Hour()
            checkForSplitShift()
            timerTypes = [.onDuty, .cycleTimer]
            if previousStatus == .onDrive {
                timerTypes = [.breakTimer , .onDuty, .cycleTimer]
            }
        case .onDrive:
            checkedOffDutyTimeIsLessThan2Hour()
            checkForSplitShift()
            
            timerTypes = [.cycleTimer, .onDuty, .continueDrive, .onDrive]
            
        case .onsleep:
            timerTypes = [.breakTimer, .sleepTimer]

        case .offDuty:
            timerTypes = [.breakTimer]

        case .personalUse:
            timerTypes = [.breakTimer]

        case .yardMode:
            timerTypes = [.cycleTimer, .onDuty]
        case .none:
            timerTypes = []
        }
        if AppStorageHandler.shared.remainingBreakTime < Int(AppStorageHandler.shared.breakTime ?? 0) && !timerTypes.contains(.breakTimer) {
            timerTypes.append(.breakTimer)
        }

        if saveLogsToDatabase {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                AppStorageHandler.shared.remainingContinueDriveTime = Int(self.continueDriveTimer?.remainingTime ?? 0)
                
                print("ContinueDriveTime===2", AppStorageHandler.shared.continueDriveTime ?? 0)
                print("remainingContinueDriveTime===2", AppStorageHandler.shared.remainingContinueDriveTime)
                if status == .onDrive {
                    self.breakTimer?.stop()
                    AppStorageHandler.shared.remainingBreakTime = Int(AppStorageHandler.shared.breakTime ?? 0)
                } else {
                    AppStorageHandler.shared.remainingBreakTime = Int(self.breakTimer?.remainingTime ?? 0)

                    if timerTypes.contains(.breakTimer) {
                        self.breakTimer?.start()
                    }
                }
            }
            
            check30MinBreakCompleted(status: status)
            saveTimerStateForStatus(status: status.getName(), originType: .driver, note: note)
        }
        
        startTimers(for: timerTypes)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            self?.loadEventsFromDatabase()
        }
        showCycleMessage()
    }

    func checkedOffDutyTimeIsLessThan2Hour()  {
        // off duty time is less than two hours and next status != sleep then time should dedut from OnDuty
        guard let lastRecord = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.day, .shift]),
        let status = DriverStatusType(fromName: lastRecord.status) else {
            return
        }
        let elapsed = getElapsedTime(lastLog: lastRecord)
        let twoHrs = TimeInterval(60*60*2)
        
        // off duty or sleep less than 2 hours will be adjusted from cycle and onDuty time
        if (status == .offDuty || status == .onsleep) && elapsed < twoHrs  {
            
            let onDutyRemainingTime = adjusted(lastRecord.remainingDutyTime, elapsed: elapsed, active: true)
            onDutyTimer = CountdownTimer(startTime: onDutyRemainingTime)
            onDutyTimer?.start()
            
            let cycleTime = adjusted(lastRecord.remainingWeeklyTime, elapsed: elapsed, active: true)
            cycleTimer = CountdownTimer(startTime: cycleTime)
            cycleTimer?.start()
            
            if let _ = getLastRecordFromSplitShiftLog() {
                // split sleep case, reset to remaining sleep time
                let shiftType = getSplitShiftType()
                let remainingSleepTime = (AppStorageHandler.shared.onSleepTime ?? 0) - shiftType.getSeconds()
                sleepTimer = CountdownTimer(startTime: remainingSleepTime)
            } else {
                // default sleep case, reset to 10 hours
                sleepTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.onSleepTime ?? 0))
            }
        }
    }

    
    // # changes by priyanshi - compact + safe version
    
    func resetContinueDriveTimeWhenMoveFromOnDrvieToOnDuty() {
        AppStorageHandler.shared.remainingContinueDriveTime = Int(AppStorageHandler.shared.continueDriveTime ?? 0)
        continueDriveTimer = CountdownTimer(startTime: TimeInterval(AppStorageHandler.shared.continueDriveTime ?? 0))
        print("continueDriveTime===3", AppStorageHandler.shared.continueDriveTime ?? 0)
        print("remainingContinueDriveTime===3", AppStorageHandler.shared.remainingContinueDriveTime)
    }
    
    func resetBreakTime(from timeInterval: TimeInterval = TimeInterval(AppStorageHandler.shared.breakTime ?? 0)) {
        breakTimer?.stop()
        breakTimer = CountdownTimer(startTime: timeInterval)
        AppStorageHandler.shared.remainingBreakTime = Int(timeInterval)
        if currentDriverStatus == .offDuty || currentDriverStatus == .onsleep {
            breakTimer?.start()
        }
    }


    func restoreAllTimersFromLastStatus() {
        
        let logs = DatabaseManager.shared.fetchLogs(filterTypes: [.day, .shift], order: [DatabaseManager.shared.startTime.desc], limit: 1)
        var latestLog = logs.first
        
            
        if latestLog == nil {
            if let lastRecordFromDB = DatabaseManager.shared.getLastRecordOfDriverLogs(), lastRecordFromDB.shift == AppStorageHandler.shared.shift {
                latestLog = lastRecordFromDB
                resetToInitialState(cycleTime: latestLog?.remainingWeeklyTime ?? 0)
            } else {
                resetToInitialState(isResetCycleTimer: true)
            }
            return
        }
        
        guard let latestLog else { return }
            
        let elapsed = getElapsedTime(lastLog: latestLog)
       
        
        let status = DriverStatusType(fromName: latestLog.status) ?? .none

        // Active flags
        let isYardMove = (status == .yardMode)
        let isDrive   = (status == .onDrive)
        let isOnDuty  = (status == .onDuty) || isDrive || isYardMove
        let isSleep   = (status == .onsleep)
        let isCycle   = !(status == .offDuty || status == .onsleep || status == .personalUse)
        

        let onDutyRemainingTime = adjusted(latestLog.remainingDutyTime, elapsed: elapsed, active: isOnDuty)
        let onDriveRemainingTime = adjusted(latestLog.remainingDriveTime, elapsed: elapsed, active: isDrive)
        let cycleRemainingTime = adjusted(latestLog.remainingWeeklyTime, elapsed: elapsed, active: isCycle)
        
        let sleepRemainingTime = adjusted(latestLog.remainingSleepTime, elapsed: elapsed, active: isSleep)
        
        // continue drive logic
        var remainingContinueDrive: Int
        
        
        if AppStorageHandler.shared.remainingContinueDriveTime < Int(AppStorageHandler.shared.continueDriveTime ?? 0) {
            remainingContinueDrive = Int(AppStorageHandler.shared.remainingContinueDriveTime)
            print("remainingContinueDrive===5", AppStorageHandler.shared.remainingContinueDriveTime)
        } else {
            remainingContinueDrive = Int(AppStorageHandler.shared.continueDriveTime ?? 0)
            print("continueDriveTime===5", AppStorageHandler.shared.continueDriveTime ?? 0)
        }
        
        var remainingBreakTime: Int
        var isBreak = false
        if AppStorageHandler.shared.remainingBreakTime < Int(AppStorageHandler.shared.breakTime ?? 0) {
            remainingBreakTime = Int(AppStorageHandler.shared.remainingBreakTime)
            isBreak = true
        } else {
            remainingBreakTime = Int(AppStorageHandler.shared.breakTime ?? 0)
        }
         
        let continueDriveRemainingTime = adjusted(remainingContinueDrive, elapsed: elapsed, active: isDrive)
        let breakRemainingTime = adjusted(Int(remainingBreakTime), elapsed: elapsed, active: isBreak)
        
        if AppStorageHandler.shared.is34HourStarted {
            let total34Hour = (34 * 60 * 60)
            let remainingTimeFrom34Hour = adjusted(Int(total34Hour), elapsed: elapsed, active: isBreak)
            let dateAfter34Hour = DateTimeHelper.currentDateTime().addingTimeInterval(remainingTimeFrom34Hour)
            self.cycleMessage = "Your next cycle will be starting at \(dateAfter34Hour.toLocalString(format: .dayMonthTime))"
        } else {
            self.cycleMessage = ""
        }
        
        // Timers
        onDutyTimer               = CountdownTimer(startTime: onDutyRemainingTime)
        onDriveTimer              = CountdownTimer(startTime: onDriveRemainingTime)
        cycleTimer                = CountdownTimer(startTime: cycleRemainingTime)
        sleepTimer                = CountdownTimer(startTime: sleepRemainingTime)
        continueDriveTimer        = CountdownTimer(startTime: continueDriveRemainingTime)
        breakTimer                = CountdownTimer(startTime: breakRemainingTime)
        

      //  setupTimerCallbacks()

        // Resume
        setDriverStatus(status: status)
    }

    func adjusted(_ value: Int?, elapsed: TimeInterval, active: Bool) -> TimeInterval {
        let time = TimeInterval(value ?? 0)
        return active ? (time - elapsed) : time//active ? max(0, time - elapsed) : time
    }
    
    
    func getElapsedTime(lastLog: DriverLogModel) -> TimeInterval {
        
        // Get current time in the same timezone as saved time
        let currentTime = DateTimeHelper.currentDateTime()
        
        // Time elapsed since last save (both in same timezone)
        let elapsed = currentTime.timeIntervalSince(lastLog.startTime)
        
        // print("Difference in current time and last saved time : \(elapsed)")
        
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
    

    func checkViolation(
        for warning1: TimeInterval,
        for warning2: TimeInterval,
        remainingTime: TimeInterval,
        type: ViolationType,
        violationKey: String
    ) {

        let lastViolationDateValue = UserDefaults.standard.string(forKey: violationKey)
        let lastViolationDate15minValue = UserDefaults.standard.string(forKey: violationKey + "_15min")
        let lastViolationDate30MinValue = UserDefaults.standard.string(forKey: violationKey + "_30min")

        let uniqueValueForViolation = "\(violationKey)_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)"
        let uniqueValueForViolation30Min = "\(violationKey)_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)_30min"
        let uniqueValueForViolation15min = "\(violationKey)_shift_\(AppStorageHandler.shared.shift)_day_\(AppStorageHandler.shared.days)_15min"

        guard lastViolationDate30MinValue != uniqueValueForViolation30Min ||
              lastViolationDate15minValue != uniqueValueForViolation15min ||
              uniqueValueForViolation != lastViolationDateValue else {
            return
        }

        guard let violationDate = remainingTime < 0
                ? DateTimeHelper.calendar.date(byAdding: .second,
                    value: Int(remainingTime+1),
                                               to: DateTimeHelper.currentDateTime())
                : DateTimeHelper.currentDateTime()
        else { return }

        //  30 MIN WARNING
        if remainingTime < warning1 &&
            remainingTime > warning2 &&
            lastViolationDate30MinValue != uniqueValueForViolation30Min {

            var violationData = ViolationData()
            violationData.violationType = type
            violationData.thirtyMinWarning = true
            self.violationDataArray.append(violationData)

            //  AUDIO
            playAudio(for: type, kind: .warning30)

            UserDefaults.standard.setValue(uniqueValueForViolation30Min,
                                           forKey: violationKey + "_30min")
            saveViolation(for: violationData, date: violationDate)
        }

        //  15 MIN WARNING
        else if remainingTime <= warning2 &&
                remainingTime > 0 &&
                lastViolationDate15minValue != uniqueValueForViolation15min {

            if lastViolationDate30MinValue != uniqueValueForViolation30Min {
                var violationData = ViolationData()
                violationData.violationType = type
                violationData.thirtyMinWarning = true
                self.violationDataArray.append(violationData)

                playAudio(for: type, kind: .warning30)

                saveViolation(for: violationData,
                              date: DateTimeHelper.get15MinBeforeDate(date: violationDate))
                UserDefaults.standard.setValue(uniqueValueForViolation30Min,
                                               forKey: violationKey + "_30min")
            }

            var violationData = ViolationData()
            violationData.violationType = type
            violationData.fifteenMinWarning = true
            self.violationDataArray.append(violationData)

            playAudio(for: type, kind: .warning15)

            saveViolation(for: violationData, date: violationDate)
            UserDefaults.standard.setValue(uniqueValueForViolation15min,
                                           forKey: violationKey + "_15min")
        }

        //  FINAL VIOLATION
        else if remainingTime < 0 &&
                uniqueValueForViolation != lastViolationDateValue {

            if lastViolationDate30MinValue != uniqueValueForViolation30Min {
                var violationData = ViolationData()
                violationData.violationType = type
                violationData.thirtyMinWarning = true
                self.violationDataArray.append(violationData)

                playAudio(for: type, kind: .warning30)  //MARK:-  voice play

                saveViolation(for: violationData,
                              date: DateTimeHelper.get30MinBeforeDate(date: violationDate))
                UserDefaults.standard.setValue(uniqueValueForViolation30Min,
                                               forKey: violationKey + "_30min")
            }

            if lastViolationDate15minValue != uniqueValueForViolation15min {
                var violationData = ViolationData()
                violationData.violationType = type
                violationData.fifteenMinWarning = true
                self.violationDataArray.append(violationData)

                playAudio(for: type, kind: .warning15) //MARK:-  voice play

                saveViolation(for: violationData,
                              date: DateTimeHelper.get15MinBeforeDate(date: violationDate))
                UserDefaults.standard.setValue(uniqueValueForViolation15min,
                                               forKey: violationKey + "_15min")
            }

            var violationData = ViolationData()
            violationData.violationType = type
            violationData.violation = true
            self.violationDataArray.append(violationData)

            playAudio(for: type, kind: .violation) //MARK:-  voice play

            UserDefaults.standard.setValue(uniqueValueForViolation,
                                           forKey: violationKey)
            saveViolation(for: violationData, date: violationDate)
        }

        UserDefaults.standard.synchronize()
    }

    enum AudioKind {
        case warning30
        case warning15
        case violation
    }
    //MARK: -  Audio Function

    func playAudio(for type: ViolationType, kind: AudioKind) {
        switch (type, kind) {
            
            
            
        case (.onDriveViolation, .warning15):
            AudioWarningManager.shared.playWarningAudio(fileName: "ondrive_warning_punjabi")
            
        case (.onDriveViolation, .violation):
            AudioWarningManager.shared.playWarningAudio(fileName: "ondrive_violation_punjabi")
            
        case (.onContinueDriveViolation, .warning15):
            AudioWarningManager.shared.playWarningAudio(fileName: "continue_drive_warning_punjabi")
            
        case (.onContinueDriveViolation, .violation):
            AudioWarningManager.shared.playWarningAudio(fileName: "continue_driving_violation_punjabi")
            
        case (.onDutyViolation, .warning15):
            AudioWarningManager.shared.playWarningAudio(fileName: "onduty_warning_punjabi")
            
        case (.onDutyViolation, .violation):
            AudioWarningManager.shared.playWarningAudio(fileName: "onduty_violation_punjabi")
            
        case (.cycleTimerViolation, .warning15):
            AudioWarningManager.shared.playWarningAudio(fileName: "weekly_warning_15min")
            
        case (.cycleTimerViolation, .violation):
            AudioWarningManager.shared.playWarningAudio(fileName: "weekly_violation_punjabi")

        default:
            break
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
    
    
    func addIntermediateLogs() {
        guard let lastLog = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.day]), lastLog.status == AppConstants.onDrive else {
            return
        }
        let startTime = lastLog.startTime
        let afterOneHourTime = DateTimeHelper.calendar.date(byAdding: .hour, value: 1, to: startTime) ?? DateTimeHelper.currentDateTime()
        let currentTime = DateTimeHelper.currentDateTime()
        
        // Check if intermediate log already exists for this time (within 5 minutes tolerance)
        let allLogs = DatabaseManager.shared.fetchLogs(filterTypes: [.day])
        let tolerance: TimeInterval = 5 * 60 // 5 minutes
        let intermediateOrigin = OriginType.intermediate.description
        let hasExistingIntermediateLog = allLogs.contains { log in
            log.status == lastLog.status &&
            log.origin == intermediateOrigin &&
            abs(log.startTime.timeIntervalSince(afterOneHourTime)) <= tolerance
        }
        
        if afterOneHourTime <= currentTime && lastLog.odometer != .zero && !hasExistingIntermediateLog {
            saveTimerStateForStatus(status: lastLog.status, originType: .intermediate, date: afterOneHourTime)
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
    
    func isLogVerify(dateTime: Date) -> Bool {
        let startOfDay = DateTimeHelper.calendar.startOfDay(for: dateTime)
        let endOfDay = DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
//        let currentDay = AppStorageHandler.shared.days
//        
//        if currentDay == 1 {
//            return true
//        } else {
            
            // check whether the certify table have data or not
            let record = CertifyDatabaseManager.shared.getLastRecordOfCertifyLogs(
                filterTypes: [.userId, .specificDate(date: dateTime)]
            )
            let recordExist = record != nil && record?.isCertify == "Yes"
            if !recordExist {
                // check whether the driver table have data or not
                if let _ = DatabaseManager.shared.getLastRecordOfDriverLogs(
                    filterTypes: [.user, .betweenDates(startDate: startOfDay, endDate: endOfDay)]
                ) {
                    
                    // Nothing happened
                } else {
                    return true
                }
            }
            return recordExist
     //   }
    }

    
    
    func checkWhetherTheLogCertifyOrNot(status: DriverStatusType) -> Bool {
        let todayDate = DateTimeHelper.currentDateTime()
        guard let yesterDayDateString = DateTimeHelper.calendar.date(byAdding: .day, value: -1, to: todayDate)?.toLocalString(format: .dateOnlyFormat),
                let yesterDayDate = yesterDayDateString.asDate(format: .dateOnlyFormat) else {
            return true
        }
        let isCertified = isLogVerify(dateTime: yesterDayDate)
        return isCertified
    }
  
    func checkWhetherTheDVIRAddedOrNot(status: DriverStatusType) -> Bool {
        if let _ = DvirDatabaseManager.shared.fetchAllRecords(filterTypes: [.day, .shift]).first {
            return true
        }
        return false
    }
    
    func checkWetherLastRecordExistInDVIRTable(status: DriverStatusType) -> Bool {
        if let _ = DvirDatabaseManager.shared.fetchAllRecords(filterTypes: [.user]).first {
            return true
        }
        return false
    }
}


extension HomeViewModel {
    
    func hasPendingUnsyncedLogs() -> Bool {
        !DatabaseManager.shared.fetchLogs(filterTypes: [.notSync]).isEmpty
    }
    
    func handleLogoutButtonTapped(completesWith: @escaping (Bool) -> Void) {
        showLogoutPopup = false
        presentSideMenu = false
        displayLoader = true
        defer { displayLoader = false }
        if hasPendingUnsyncedLogs() {
            Task { @MainActor in
                let syncSuccess = await syncViewModel.syncOfflineData()
                if syncSuccess {
                    let isLogoutSuccess = await callLogoutAPI()
                    completesWith(isLogoutSuccess)
                }
            }
        } else {
            Task { @MainActor in
                let isLogoutSuccess = await callLogoutAPI()
                completesWith(isLogoutSuccess)
            }
        }
    }
    
    @MainActor
    func callLogoutAPI() async -> Bool {
        let success = await APILogoutViewModel().callLogoutAPI()
        if success {
//            UserDefaults.standard.set(false, forKey: "isLoggedIn")
//            ["userEmail","authToken","driverName","\(AppStorageHandler.shared.timeZone)","timezoneOffSet"].forEach(UserDefaults.standard.removeObject)
            
        }
        return success
    }
    
    func handleLogoutRequest() {
        presentSideMenu = false
        // Allow logout from Off Duty or Sleep status
        if currentDriverStatus == .offDuty || currentDriverStatus == .onsleep {
            showLogoutPopup = true
        } else {
            // Show alert popup for other statuses (On Duty, On Drive, etc.)
            showAlert(alertType: .logoutOFFSleepDuty)
        }
    }
    
    private func scheduleRefreshAlert() {
        showAlert(alertType: .refresh)
        self.showSyncconfirmation = false
    }
    
    func handleSyncPopupConfirmation() {
        
        if hasPendingUnsyncedLogs() {
            Task {
                displayLoader = true
                let syncSuccess = await syncViewModel.syncOfflineData()
                displayLoader = false
                if syncSuccess {
                    scheduleRefreshAlert()
                }
            }
        } else {
            scheduleRefreshAlert()
        }
    }
    
    func checkWhetherTheViolationAlreadyExists() {
        let records = DatabaseManager.shared.fetchLogs(filterTypes: [.day, .shift], addWarningAndViolation: true).filter({ $0.status == AppConstants.violation } )
        for record in records {
            var violationKey = ""
            if record.dutyType.contains("duty time") {
                violationKey = AppConstants.onDutyViolationKey
            } else if record.dutyType.contains("continue drive") {
                violationKey = AppConstants.continueDriveViolationKey
            } else if record.dutyType.contains("drive time") {
                violationKey = AppConstants.onDriveViolationKey
            } else if record.dutyType.contains("cycle time") {
                violationKey = AppConstants.cycleTimeViolationKey
            }
            
            let uniqueValueForViolation = "\(violationKey)_shift_\(record.shift)_day_\(record.day)"
            let uniqueValueForViolation30Min = "\(violationKey)_shift_\(record.shift)_day_\(record.day)_30min"
            let uniqueValueForViolation15min = "\(violationKey)_shift_\(record.shift)_day_\(record.day)_15min"
            UserDefaults.standard.set(uniqueValueForViolation, forKey: violationKey)
            UserDefaults.standard.set(uniqueValueForViolation15min, forKey: violationKey + "_15min")
            UserDefaults.standard.set(uniqueValueForViolation30Min, forKey: violationKey + "_30min")
        }
    }
    
    func showAlert(alertType: AlertType) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.alertType = alertType
            self.showAlertOnHomeScreen = true
        }
    }
    
    func showCycleMessage() {
        guard isCycleTimeCompleted(), (currentDriverStatus == .offDuty || currentDriverStatus == .onsleep), !AppStorageHandler.shared.is34HourStarted else {
            cycleMessage = ""
            return
        }
        
        let time34Hour = TimeInterval(34 * 60 * 60)
        resetBreakTime()
        let currentDateTime = DateTimeHelper.currentDateTime()
        let dateAfter34Hour = currentDateTime.addingTimeInterval(time34Hour)
        self.cycleMessage = "Your next cycle will be starting at \(dateAfter34Hour.toLocalString(format: .dayMonthTime))"
        AppStorageHandler.shared.is34HourStarted = true
    }
    
}



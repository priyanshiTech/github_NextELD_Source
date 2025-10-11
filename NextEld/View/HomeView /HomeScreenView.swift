//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 07/05/25.
//
//
import SwiftUI


// MARK: - Main View
struct HomeScreenView: View {
    
    @State private var labelValue = ""
    @State private var OnDutyvalue: Int = 0
    @State private var selectedStatus: String? = nil
    @State private var confirmedStatus: String? = nil
    @State private var showAlert: Bool = false
    @State private var showStatusalert: Bool = false
    @State private var showLogoutPopup: Bool = false
    @State private var ShowrefreshPopup: Bool = false
    @State private var isCycleCompleted: Bool = false
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    @State private var showDeviceSelector: Bool = false
    @State private var selectedDevice: String? = nil
    @State private var hasShownSleepResetPopup = false  //For reset SLEpp Timer
    @State private var hoseEvents: [HOSEvent] = []
    @StateObject private var hoseChartViewModel = HOSEventsChartViewModel()
    
    
    @State private var didShowContinusDrivingVoilation =  false
    @AppStorage("didSyncOnLaunch") private var didSyncOnLaunch: Bool = false
    @State var isOnAppearCalled = false
    @State var isVoilation = false
    @State private var isRestoringTimers = false  // Flag to prevent auto-save during restoration
    
    //MARK: - Daily violation tracking
    @AppStorage("lastViolationDate") private var lastViolationDate: String = ""
    @AppStorage("didShowOnDuty30MinToday") private var didShowOnDuty30MinToday: Bool = false
    @AppStorage("didShowOnDuty15MinToday") private var didShowOnDuty15MinToday: Bool = false
    @AppStorage("didShowOnDutyViolationToday") private var didShowOnDutyViolationToday: Bool = false
    @AppStorage("didShowDrive30MinToday") private var didShowDrive30MinToday: Bool = false
    @AppStorage("didShowDrive15MinToday") private var didShowDrive15MinToday: Bool = false
    @AppStorage("didShowDriveViolationToday") private var didShowDriveViolationToday: Bool = false
    @AppStorage("didShowCycleViolationToday") private var didShowCycleViolationToday: Bool = false
    @AppStorage("didShowContinueDriveViolationToday") private var didShowContinueDriveViolationToday: Bool = false

    @EnvironmentObject var dutyManager: DutyStatusManager

    
    @State private var onDutyTimer = CountdownTimer(startTime: 0)
    @StateObject private var ONDuty: CountdownTimer
    
    @State private var driveTimerState = CountdownTimer(startTime: 0)
    @StateObject private var driveTimer: CountdownTimer
    
    @State private var cycleTimerState = CountdownTimer(startTime: 0)
    @StateObject private var cycleTimerOn: CountdownTimer
    
    @State private var sleepTimerState = CountdownTimer(startTime: 0)
    @StateObject private var sleepTimer: CountdownTimer
    
    @State private var continueDutyTime =  CountdownTimer(startTime: 0)
    @StateObject private var continueDriveTime: CountdownTimer
    
    @StateObject var restBreakTimer = CountdownTimer(startTime: 0)
    @StateObject var breakTime: CountdownTimer
    
    @State private var isBreakTimerCompleted: Bool = false  // Track if break timer completed
    
    @State private var  TimeZone : String = ""
    @State private var  TimeZoneOffSet : String = ""
    @State private var hasAppearedBefore = false
    @State private var savedOnDutyRemaining: TimeInterval = 0
    @State private var savedDriveRemaining: TimeInterval = 0
    @State private var savedCycleRemaining: TimeInterval = 0
    @State private var savedSleepingRemaning: TimeInterval = 0
    @State private var savedBreakRemaining: TimeInterval = 0
    
    
    
    //MARK: - For systematic Voilation
    
//    @State private var didShow30MinWarning = false
//    @State private var didShow15MinWarning = false
//    @State private var didShowViolation = false
//
//    //MARK: -  To show a Voilation
//    @State private var didShowOnDutyViolation = false
//    @State private var didShowDriveViolation = false
//    @State private var didShowCycleViolation = false
    @State private var didShow30MinWarning = false
    @State private var didShow15MinWarning = false
    @State private var didShowViolation = false

    // Add separate flags for each timer type
    @State private var didShowOnDutyViolation = false
    @State private var didShowOnDuty30MinWarning = false
    @State private var didShowOnDuty15MinWarning = false

    @State private var didShowOnDriveViolation = false
    @State private var didShowOnDrive30MinWarning = false
    @State private var didShowOnDrive15MinWarning = false

    @State private var didShowCycleViolation = false
    @State private var didShowCycle30MinWarning = false
    @State private var didShowCycle15MinWarning = false
    
    
    // Add this method in your HomeScreenView struct
    func initializeViolationFlags() {
        let todayFlags = DatabaseManager.shared.hasAnyViolationOrWarningForToday()
        
        // Set flags based on what already exists in database for today
        didShowViolation = todayFlags.hasViolation
        didShow30MinWarning = todayFlags.has30MinWarning
        didShow15MinWarning = todayFlags.has15MinWarning
        
        // Set specific timer flags
        didShowOnDutyViolation = todayFlags.hasViolation
        didShowOnDuty30MinWarning = todayFlags.has30MinWarning
        didShowOnDuty15MinWarning = todayFlags.has15MinWarning
        
        print("Initialized violation flags - Violation: \(didShowViolation), 30Min: \(didShow30MinWarning), 15Min: \(didShow15MinWarning)")
    }
    
    //MARK: -  for Voilation box
    @State private var violationBoxes: [ViolationBoxData] = []
    @State private var showViolationBoxes = false
    
    struct ViolationBoxData: Identifiable {
        let id = UUID()
        let text: String
        let date: String
        let time: String
        let timestamp: Date
    }
    
    init(presentSideMenu: Binding<Bool>, selectedSideMenuTab: Binding<Int>, session: SessionManager) {
        self._presentSideMenu = presentSideMenu
        self._selectedSideMenuTab = selectedSideMenuTab
        self.session = session
        
        let onDutySeconds = CountdownTimer.timeStringToSeconds("14:00:00")
        let driveSeconds = CountdownTimer.timeStringToSeconds("11:00:00")
        let cycleSeconds = CountdownTimer.timeStringToSeconds("70:00:00")
        let sleepSeconds = CountdownTimer.timeStringToSeconds("10:00:00")
        let ContinueDriveTime = CountdownTimer.timeStringToSeconds("08:00:00")
        let breakTimer =  CountdownTimer.timeStringToSeconds("00:30:00")
        
//          let onDutySeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.onDutyTime ?? 140000)")
//         let driveSeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.onDriveTime ?? 110000)")
//         let cycleSeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.cycleTime ?? 700000)")
//         let sleepSeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.onSleepTime ?? 100000)")
//         let ContinueDriveTime = CountdownTimer.timeStringToSeconds(" \( DriverInfo.continueDriveTime ??  080000)")
//         let breakTimer =  CountdownTimer.timeStringToSeconds("00:30:00")
        
        _ONDuty = StateObject(wrappedValue: CountdownTimer(startTime: onDutySeconds))
        _driveTimer = StateObject(wrappedValue: CountdownTimer(startTime: driveSeconds))
        _cycleTimerOn = StateObject(wrappedValue: CountdownTimer(startTime: cycleSeconds))
        _sleepTimer = StateObject(wrappedValue: CountdownTimer(startTime: sleepSeconds))
        _continueDriveTime = StateObject(wrappedValue: CountdownTimer(startTime: ContinueDriveTime))
        _breakTime = StateObject(wrappedValue: CountdownTimer(startTime: breakTimer))
        
    }

    
    let session: SessionManager
    
    @State private var activeTimerAlert: TimerAlert?
    @EnvironmentObject var navmanager: NavigationManager
    //MARK: -  Show Alert Drive Before 30 min / 15 MIn
    @StateObject private var viewModel = RefreshViewModel()
    @StateObject private var syncVM = SyncViewModel()
    //MARK: -  to show a Cycle state
    @State private var isOnDutyActive = false
    @State private var isDriveActive = false
    @State private var isCycleTimerActive = false
    @State private var  isSleepTimerActive =  false
    @State private var cycleTimeElapsed = 0
    @State private var cycleTimer: Timer?
    
    //MARK: -  to manage a cycle timer
    // ELD Additions
    @AppStorage("cycleType") var cycleType: String = "8/70" // or "7/60"
    @State private var cumulativeDriveTime: TimeInterval = 0
    @State private var isOnBreak: Bool = false
    @State private var pastDutyLog: [Date: TimeInterval] = [:] // key = date, value = seconds
    @State private var offDutyStartTime: Date? = nil
    @State private var driveStopStartTime: Date? = nil
    @State private var showDriveStopPrompt: Bool = false
    @State private var driveStopPromptTimer: Timer? = nil
//MARK: -  SHOw Slep Timer Popup
    @State private var showSleepResetPopup = false
    @State private var showNextDayPopup = false
    @AppStorage("hasShownNextDayPopup") private var hasShownNextDayPopup = false
    @State private var daysCount =  DriverInfo.CurrentDay
    @State private var ShiftCurrentDay  =  DriverInfo.shift
    
    //MARK: -  Network
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showBanner: Bool = false
    @State private var bannerMessage: String = ""
    @State private var bannerColor: Color = .green
    
    //MARK: -  Last Status Track
    @State private var offDutySleepAccumulated: TimeInterval = 0
    @State private var lastStatusChangeTime: Date? = nil
    @State private var timer: Timer? = nil

//MARK: -  For Delete API's
    @State private var showDeleteConfirm = false
    @StateObject private var deleteViewModel = DeleteViewModel()
    @State private var showSuccessAlert = false
    @State private var showViolation = true
    @State private var showSyncconfirmation  =  false
    @StateObject private var logoutVM = APILogoutViewModel()   //logout
    @State private var showsyncRefreshalert = RefreshViewModel()  // Refresh
    @EnvironmentObject var locationManager: LocationManager

    @State private var hasRestoredTimers = false
    let times = DateTimeHelperVoilation.getLocalAndGMT()
    

    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack {
                //MARK: -  Top colored bar
                ZStack(alignment: .topLeading) {
                    Color(uiColor: .wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 0)
                    
                    TopBarView(
                        presentSideMenu: $presentSideMenu,
                        labelValue: labelValue,
                        showDeviceSelector: $showDeviceSelector
                    )
                }
                
                    
                UniversalScrollView {
                    VStack {
                        Text("Disconnected")
                            .font(.title2)
                            .foregroundColor(.red)
                        
                        VehicleInfoView(GadiNo: UserDefaults.standard.string(forKey: "truckNo") ?? "Not Found",
                                        trailer: UserDefaults.standard.string(forKey: "trailer") ?? "Upcoming")
                        
                        StatusView(
                            confirmedStatus: $confirmedStatus,
                            selectedStatus: $selectedStatus,
                            showAlert: $showAlert,
                            ContiueDrive: continueDriveTime,
                            RestBreak: breakTime,
                            onStopAllTimers: stopAllTimers,
                            onStartYardMoveTimers: startYardMoveTimers
                        )
                        
                        AvailableHoursView(
                            driveTimer: driveTimer,
                            ONDuty: ONDuty,
                            cycleTimer: cycleTimerOn,
                            sleepTimer: sleepTimer
                        )
                        
                        HOSEventsChartScreen(currentStatus: confirmedStatus)
                            .environmentObject(hoseChartViewModel)
                        
                        //MARK: - Violation Boxes (Part of Main Scroll)
                        if showViolationBoxes && !violationBoxes.isEmpty {
                            
                            
                            VStack(spacing: 12) {
                                ForEach(violationBoxes) { violation in
                                       ViolationBox(
                                        text: violation.text,
                                        date: violation.date,
                                        time: violation.time
                                       )
                                       .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            .animation(.spring(), value: violationBoxes.count)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Version - OS/02/May")
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    loadViolationsFromDatabase()
                    initializeViolationFlags()
                }
                .scrollIndicators(.hidden)
            }
            .disabled(presentSideMenu || showLogoutPopup || ShowrefreshPopup )
            
            if presentSideMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            presentSideMenu = false
                        }
                    }
                    .zIndex(1)
                
                SideMenuView(
                    selectedSideMenuTab: $selectedSideMenuTab,
                    presentSideMenu: $presentSideMenu,
                    showLogoutPopup: $showLogoutPopup,
                    showDeleteConfirm: $showDeleteConfirm, showSyncConfirmation: $showSyncconfirmation ,
                    
                )
                .frame(width: 250)
                .background(Color.white)
                .transition(.move(edge: .leading))
                .zIndex(1)
            }

            // Status Alert / Drive Prompt
            if showAlert, let selected = selectedStatus {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .zIndex(2)
                    
                    if /*dutyManager.dutyStatus*/ selected == DriverStatusConstants.onSleep || selected == DriverStatusConstants.offDuty || selected == DriverStatusConstants.personalUse || selected == DriverStatusConstants.yardMove || selected == DriverStatusConstants.onDuty {
                        StatusDetailsPopup(
                            statusTitle: selected,
                            onClose: { showAlert = false },
                            onSubmit: { note in
                                // Save current timer states before any status change
                                saveCurrentTimerStatesBeforeSwitch()
                                
                                // Store previous status before updating
                                let previousStatus = confirmedStatus
                                
                                confirmedStatus = selected
                                dutyManager.dutyStatus = selected
                                print("Note for \(selected): \(note)")
                                print("Previous status: \(previousStatus ?? "nil"), New status: \(selected)")
                                
                                // Reset NEXTDAY popup flag when starting new work day
                                if selected == DriverStatusConstants.onDuty || selected == DriverStatusConstants.onDrive {
                                    hasShownNextDayPopup = false
                                    print(" Reset NEXTDAY popup flag - new work day started")
                                }
                                
                                if selected == DriverStatusConstants.onDuty {
                                    sleepTimer.stop()
                                    let totalWorked = totalDutyLast7or8Days()
                                    let weeklyLimit = (cycleType == "7/60") ? 60 * 3600 : 70 * 3600
                                    if Int(totalWorked) >= weeklyLimit{
                                        activeTimerAlert = TimerAlert(
                                            title: "Cycle Violation",
                                            message: "You've exceeded your \(cycleType) duty hour limit.",
                                            backgroundColor: .red.opacity(0.9),
                                            isViolation: isVoilation
                                        )
                                        showAlert = false
                                        return
                                    }
                                    
                                    // Check if coming from On-Drive status to start break timer
                                    if previousStatus == DriverStatusConstants.onDrive {
                                        // Start break timer (don't reset - keep current time)
                                        breakTime.start()
                                        print(" Break timer started when switching from On-Drive to On-Duty (not reset)")
                                        
                                        // Save or update continue drive data to database
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                        let now = formatter.string(from: Date())
                                        
                                        // Check if there's already a Continue Drive entry for today
                                        let latestEntry = ContinueDriveDBManager.shared.fetchLatestContinueDriveData()
                                        let today = Calendar.current.startOfDay(for: Date())
                                        
                                        if let latest = latestEntry {
                                            // Parse the latest entry's start time
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                            let latestDate = dateFormatter.date(from: latest.startTime) ?? Date()
                                            let latestDay = Calendar.current.startOfDay(for: latestDate)
                                            
                                            // If latest entry is from today, update it
                                            if latestDay == today {
                                                ContinueDriveDBManager.shared.updateLatestContinueDriveData(
                                                    status: "Continue Drive",
                                                    startTime: now,
                                                    endTime: continueDriveTime.timeString,
                                                    breakTime: breakTime.timeString
                                                )
                                                print("📊 Continue Drive data updated in database")
                                            } else {
                                                // If latest entry is from different day, create new entry
                                                ContinueDriveDBManager.shared.saveContinueDriveData(
                                                    userId: UserDefaults.standard.integer(forKey: "userId"),
                                                    status: "Continue Drive",
                                                    startTime: now,
                                                    endTime: continueDriveTime.timeString,
                                                    breakTime: breakTime.timeString
                                                )
                                                print("📊 New Continue Drive data saved to database")
                                            }
                                        } else {
                                            // No existing entry, create new one
                                            ContinueDriveDBManager.shared.saveContinueDriveData(
                                                userId: UserDefaults.standard.integer(forKey: "userId"),
                                                status: "Continue Drive",
                                                startTime: now,
                                                endTime: continueDriveTime.timeString,
                                                breakTime: breakTime.timeString
                                            )
                                            print("📊 First Continue Drive data saved to database")
                                        }
                                    }
                                    
                                    // Restore OnDuty timer with saved remaining time if available
                                    if savedOnDutyRemaining > 0 {
                                        print(" Restoring OnDuty with saved time: \(savedOnDutyRemaining/60) minutes")
                                        ONDuty.reset(startTime: savedOnDutyRemaining)
                                        savedOnDutyRemaining = 0 // Reset saved time
                                    }
                                    
                                    // Restore Drive timer with saved remaining time if available
                                    if savedDriveRemaining > 0 {
                                        print(" Restoring Drive with saved time: \(savedDriveRemaining/60) minutes")
                                        driveTimer.reset(startTime: savedDriveRemaining)
                                        savedDriveRemaining = 0 // Reset saved time
                                    }
                                    
                                    // Restore Cycle timer with saved remaining time if available
                                    if savedCycleRemaining > 0 {
                                        print(" Restoring Cycle with saved time: \(savedCycleRemaining/60) minutes")
                                        cycleTimerOn.reset(startTime: savedCycleRemaining)
                                        savedCycleRemaining = 0 // Reset saved time
                                    }
                                    
                                    //Restore Sleep Timer
                                    if savedSleepingRemaning > 0 {
                                        print(" Sleeping with saved time: \(savedSleepingRemaning/60) minutes")
                                        sleepTimer.reset(startTime: savedSleepingRemaning)
                                        savedSleepingRemaning = 0
                                    }
                                    
                                    //Restore Break Timer (only if not coming from On-Drive)
                                    if savedBreakRemaining > 0 && previousStatus != DriverStatusConstants.onDrive {
                                        print(" Restoring Break timer with saved time: \(savedBreakRemaining/60) minutes")
                                        breakTime.reset(startTime: savedBreakRemaining)
                                        savedBreakRemaining = 0
                                    }
                                    
                                    continueDriveTime.stop()
                                    ONDuty.start()
                                    cycleTimerOn.start()
                                    isOnDutyActive = true
                                    checkAndStartCycleTimer()
                                    offDutySleepAccumulated = 0
                                    
                                }
                                
                                if selected == DriverStatusConstants.onSleep {
                                    // Keep break timer running when switching to Sleep (don't reset)
                                    breakTime.start()
                                    print(" Break timer continues running when switching to Sleep (not reset)")
                                    
                                    sleepTimer.start()
                                    let totalWorked = totalDutyLast7or8Days()
                                    let weeklyLimit = (cycleType == "7/60") ? 60 * 3600 : 70 * 3600
                                    if Int(totalWorked) >= weeklyLimit{
                                        activeTimerAlert = TimerAlert(
                                            title: "Sleep Violation",
                                            message: "You've exceeded your \(cycleType) duty hour limit.",
                                            backgroundColor: .red.opacity(0.9),
                                            isViolation: false
                                        )
                                        showAlert = false
                                        return
                                    }
                                    
                                    // Restore OnDuty timer with saved remaining time if available
                                    if savedOnDutyRemaining > 0 {
                                        print(" Restoring OnDuty with saved time: \(savedOnDutyRemaining/60) minutes")
                                        ONDuty.reset(startTime: savedOnDutyRemaining)
                                        savedOnDutyRemaining = 0 // Reset saved time
                                    }
                                    
                                    // Restore Drive timer with saved remaining time if available
                                    if savedDriveRemaining > 0 {
                                        print(" Restoring Drive with saved time: \(savedDriveRemaining/60) minutes")
                                        driveTimer.reset(startTime: savedDriveRemaining)
                                        savedDriveRemaining = 0 // Reset saved time
                                    }
                                    
                                    // Restore Cycle timer with saved remaining time if available
                                    if savedCycleRemaining > 0 {
                                        print(" Restoring Cycle with saved time: \(savedCycleRemaining/60) minutes")
                                        cycleTimerOn.reset(startTime: savedCycleRemaining)
                                        savedCycleRemaining = 0 // Reset saved time
                                    }
                                    
                                    //Restore Sleep Timer
                                    if savedSleepingRemaning > 0 {
                                        print(" Sleeping with saved time: \(savedSleepingRemaning/60) minutes")
                                        sleepTimer.reset(startTime: savedSleepingRemaning)
                                        savedSleepingRemaning = 0
                                    }
                                    
                                    
                                    sleepTimer.start()
                                    continueDriveTime.stop()
                                    ONDuty.stop()
                                    driveTimer.stop()
                                    cycleTimerOn.stop()
                                    isSleepTimerActive = true
                                   // checkAndStartCycleTimer()
                                    offDutySleepAccumulated = 0
                                    
                                }


                                else if selected == DriverStatusConstants.offDuty {
                                    print(" Switching to OffDuty - Timers already saved")
                                    
                                    // Keep break timer running when switching to Off-Duty (don't reset)
                                    breakTime.start()
                                    print(" Break timer continues running when switching to Off-Duty (not reset)")
                                    
                                    // Update saved states with current values before stopping
                                    savedOnDutyRemaining = ONDuty.remainingTime
                                    savedDriveRemaining = driveTimer.remainingTime
                                    savedCycleRemaining = cycleTimerOn.remainingTime
                                    print(" Updated saved states - OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
                                    
                                    let dutyTime = ONDuty.elapsed
                                    saveDailyDutyLog(duration: dutyTime)
                                    driveTimer.stop()
                                    ONDuty.stop() // Stop but don't reset
                                    continueDriveTime.stop()
                                    sleepTimer.stop()
                                    breakTime.start()
                                    cycleTimerOn.stop()
                                    continueDriveTime.stop()
                                    isDriveActive = false
                                    isOnDutyActive = false
                                    checkAndStartCycleTimer()
                                    checkFor10HourReset()
                                }
                                
                                showAlert = false
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let now = formatter.string(from: Date())
                                DatabaseManager.shared.saveTimerLog(
                                    status: selected,
                                    startTime: now, dutyType: selected,
                                    remainingWeeklyTime: cycleTimerOn.internalTimeString,
                                    remainingDriveTime: driveTimer.internalTimeString,
                                    remainingDutyTime: ONDuty.internalTimeString,
                                    remainingSleepTime: sleepTimer.internalTimeString,
                                    lastSleepTime: breakTime.internalTimeString,
                                    RemaningRestBreak: "true",
                                    isruning: selected == DriverStatusConstants.onSleep,
                                    isVoilations: self.isVoilation
                                    //isVoilations: selected == DriverStatusConstants.onDrive || selected == DriverStatusConstants.onDuty || selected == DriverStatusConstants.onSleep
                                )
                                let logs = DatabaseManager.shared.fetchLogs()
                                print(" Total Logs in DB: \(logs.count)")
                                // Force immediate chart refresh with new status
                                hoseChartViewModel.updateStatus(selected)
                                print("Saved \(selected) timer to DB at \(now)")
                            }
                        )
                        .zIndex(3)
                    } else if selected == DriverStatusConstants.onDrive {
                        CustomPopupAlert(
                            title: "Certify Log",
                            message: "please add DVIR before going to On-Drive",
                            onOK: {
                                // Save current timer states before switching to Drive
                                saveCurrentTimerStatesBeforeSwitch()
                                // Store previous status before updating
                                let previousStatus = confirmedStatus
                                
                                confirmedStatus = selected
                                dutyManager.dutyStatus = selected
                                print("Previous status: \(previousStatus ?? "nil"), New status: \(selected)")
                                
                                //MARK: -  Check if break timer was completed and delete database entry
                                if isBreakTimerCompleted {
                                    print(" Break timer was completed - deleting Continue Drive database entry")
                                    ContinueDriveDBManager.shared.deleteAllContinueDriveData()
                                    print(" Continue Drive database entry deleted - break was completed")
                                    isBreakTimerCompleted = false  // Reset flag
                                } else {
                                    //MARK: -  Clear break time in Continue Drive database entry
                                    let latestEntry = ContinueDriveDBManager.shared.fetchLatestContinueDriveData()
                                    if let latest = latestEntry {
                                        ContinueDriveDBManager.shared.updateLatestContinueDriveData(
                                            breakTime: "" // Clear break time
                                        )
                                        print(" Break time cleared in Continue Drive database entry")
                                    }
                                }
                                
                                // Reset break timer to 30 minutes and stop when switching to On-Drive
                                breakTime.reset(startTime: 30 * 60)
                                breakTime.stop()
                                print(" Break timer reset to 30 minutes and stopped when switching to On-Drive")
                                
                                // Reset NEXTDAY popup flag when starting new work day
                                if selected == DriverStatusConstants.onDuty || selected == DriverStatusConstants.onDrive {
                                    hasShownNextDayPopup = false
                                    print(" Reset NEXTDAY popup flag - new work day started")
                                }
                                
                                // Restore timers with saved states
                                if savedOnDutyRemaining > 0 {
                                    print(" Restoring OnDuty with saved time: \(savedOnDutyRemaining/60) minutes")
                                    ONDuty.reset(startTime: savedOnDutyRemaining)
                                    savedOnDutyRemaining = 0
                                }
                                
                                if savedDriveRemaining > 0 {
                                    print(" Restoring Drive with saved time: \(savedDriveRemaining/60) minutes")
                                    driveTimer.reset(startTime: savedDriveRemaining)
                                    savedDriveRemaining = 0
                                }
                                
                                if savedCycleRemaining > 0 {
                                    print(" Restoring Cycle with saved time: \(savedCycleRemaining/60) minutes")
                                    cycleTimerOn.reset(startTime: savedCycleRemaining)
                                    savedCycleRemaining = 0
                                }
                                //Restore Sleep Timer
                                if savedSleepingRemaning > 0 {
                                    print(" Sleep with saved time: \(savedSleepingRemaning/60) minutes")
                                    sleepTimer.reset(startTime: savedSleepingRemaning)
                                    savedSleepingRemaning = 0
                                }
                                
                                // Don't restore Break Timer when switching to Drive - it should always reset to 30 minutes
                                
                                isDriveActive = true
                                driveTimer.start()
                                ONDuty.start()
                                continueDriveTime.start()
                                cycleTimerOn.start()
                                sleepTimer.stop()
                                breakTime.stop()
                                offDutySleepAccumulated = 0
                                showAlert = false
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let now = formatter.string(from: Date())
                                
                                DatabaseManager.shared.saveTimerLog(
                                    status: DriverStatusConstants.onDrive,
                                    startTime: now, dutyType: DriverStatusConstants.onDrive,
                                    remainingWeeklyTime: cycleTimerOn.internalTimeString,
                                    remainingDriveTime: driveTimer.internalTimeString,
                                    remainingDutyTime: ONDuty.internalTimeString,
                                    remainingSleepTime: sleepTimer.internalTimeString,
                                    lastSleepTime: "", RemaningRestBreak: restBreakTimer.internalTimeString, isruning: false,
                                )
                                print(" Saved Continue Drive timer to DB at \(now)")
                                //MARK: -  RELOAD THE CHART DATA INSTANTLY
                                hoseChartViewModel.updateStatus(DriverStatusConstants.onDrive)
                                print("Saved Drive timer to DB at \(now)")
                            },
   
                            onCancel: {
                                showAlert = false
                            }

                        )
                        .zIndex(3)
                    }
    
                }
            }
            
            if showLogoutPopup {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(2)
                
                PopupContainer(isPresented: $showLogoutPopup) {
                    LogOutPopup(
                        isCycleCompleted: $isCycleCompleted,
                        currentStatus: DriverStatusConstants.offDuty,
                        onLogout: {
                            Task {
                                await logoutVM.callLogoutAPI()
                            }
                            showLogoutPopup = false
                            presentSideMenu = false
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            UserDefaults.standard.removeObject(forKey: "userEmail")
                            UserDefaults.standard.removeObject(forKey: "authToken")
                            UserDefaults.standard.removeObject(forKey: "driverName")
                            UserDefaults.standard.removeObject(forKey: "timezone")
                            UserDefaults.standard.removeObject(forKey: "timezoneOffSet")
                            
                            session.logOut()
                            SessionManagerClass.shared.clearToken()
                            navmanager.navigate(to: .SplashScreen)
                        },
                        onCancel: {
                            showLogoutPopup = false
                        }
                    )
                }
                .zIndex(3)
            }
            
            if showDeviceSelector {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showDeviceSelector = false
                        }
                    
                    DeviceSelectorPopup(
                        selectedDevice: $selectedDevice,
                        isPresented: $showDeviceSelector,
                        onConnect: {
                            showDeviceSelector = false
                            if selectedDevice == "NT-11" {
                                navmanager.navigate(to: .NT11Connection)
                            } else if selectedDevice == "PT30" {
                                navmanager.navigate(to: .PT30Connection)
                            }
                        }
                    )
                    .transition(.scale)
                    .zIndex(10)
                }
            }
            
            if let alert = activeTimerAlert {
                CommonTimerAlertView(alert: alert) {
                    activeTimerAlert = nil
                }
            }
            // MARK: -  Internet Status Banner
            if showBanner {
                VStack {
                    HStack {
                        Text(bannerMessage)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(bannerColor)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .shadow(radius: 4)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: showBanner)
            }
        }
        .onChange(of: networkMonitor.isConnected) { newValue in
            if newValue {
                showToast(message: " Internet Connected Successfully", color: .green)
            } else {
                showToast(message: " No Internet Connection", color: .red)
            }
        }

        .onAppear {
            loadTodayHOSEvents()
        }
        //(_)(+)_(_+(_+(_+)()_(+)_
        ZStack {
            
            if !syncVM.syncMessage.isEmpty {
                Text(syncVM.syncMessage)
                    .padding()
                    .background(syncVM.syncMessage.contains("Failed") ? Color.red : Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            syncVM.syncMessage = ""
                        }
                    }
            }
        }
        //MARK: -  call sync API In every 10 sec
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                Task {
                    await syncVM.syncOfflineData()
                }
            }
            Task {
                await syncVM.syncOfflineData()
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        //        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
        //            // Save timer states when app goes to background
        //            saveCurrentTimerStatesBeforeSwitch()
        //            saveCurrentTimerStates()
        //        }
        //        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
        //            // Restore timer states when app becomes active
        //            restoreAllTimers()
        //        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            // Save timer states when app is about to terminate
            saveCurrentTimerStatesBeforeSwitch()
            saveCurrentTimerStates()
            restoreAllTimers()
        }

        
        .onAppear {
            
            if isOnAppearCalled { return }
            isOnAppearCalled = true
            print(" HomeScreenView onAppear called")
            print(" Current status - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
            
            if let driverName = UserDefaults.standard.string(forKey: "driverName"),
               !driverName.isEmpty {
                labelValue = driverName
            } else {
                DispatchQueue.main.async {
                    navmanager.navigate(to: AppRoute.Login)
                }
                return
            }
            
            // Check if we have any saved timer data
            let hasSavedData = !DatabaseManager.shared.fetchLogs().isEmpty
                        print(" Has saved data: \(hasSavedData)")
            
            if hasSavedData {
                            print(" Found saved data - restoring timers")
                // Delay restoration to ensure UI is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.restoreAllTimers()
                    hasRestoredTimers = true
                    print(" Timer restoration completed - confirmedStatus: \(self.confirmedStatus ?? "nil"), selectedStatus: \(self.selectedStatus ?? "nil")")
                }
            } else {
                      
                print(" No saved data - initializing fresh")
                if !hasAppearedBefore {
                    hasAppearedBefore = true
                            }
                            // Always ensure status is set to Off-Duty if no saved data
            if confirmedStatus == nil {
                selectedStatus = DriverStatusConstants.offDuty
                confirmedStatus = DriverStatusConstants.offDuty
                                print(" Set status to OffDuty (no saved data)")
                            }
                        }
            
                        // Always ensure status is properly set when view appears
                        if confirmedStatus == nil {
                            selectedStatus = DriverStatusConstants.offDuty
                            confirmedStatus = DriverStatusConstants.offDuty
                            print("🔧 Set status to OffDuty (fallback)")
                        }
            
                        print(" Final status after onAppear - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
                        
                        // Check and reset daily violations
                        checkAndResetDailyViolations()
            
            checkFor34HourReset()
        }

            
            
            //***************************+++++++++++++++++++++++++++******************************************************************************************************
    // MARK: - OnDuty Timer Violation Logic with Working Time


        .onReceive(ONDuty.$remainingTime) { remainingTime in
            let totalDriveTime = DriverInfo.onDutyTime ?? 0
            let workingTime = Double(totalDriveTime) - remainingTime
            let violationThreshold = Double(totalDriveTime)
            print("Working: \(workingTime/3600) h, Remaining: \(remainingTime/3600) h")

            // Violation check - use daily tracking
            if workingTime >= violationThreshold && !didShowOnDutyViolationToday {
                activeTimerAlert = TimerAlert(
                    title: "On-Duty Violation",
                    message: "Your Onduty time has been exceeded to 14 hours",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowOnDutyViolationToday = true
                didShowOnDutyViolation = true
                didShowViolation = true  // Keep global flag for compatibility
                addViolationBox(text: "Your On Duty time has been exceeded to 14 hours")
                print("OnDuty Violation fired once")
                
                saveViolationToDatabase(status: "Violation", DutyType: "Your On-Duty time has been exceeded to 14 hours \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)
            } else {
            // 30-min warning
                if let warning1 = DriverInfo.setWarningOnDutyTime1,
                   Int(workingTime) >= Int(warning1),
                   !didShowOnDuty30MinToday {
                    
                activeTimerAlert = TimerAlert(
                    title: "On-Duty Reminder",
                        message: """
                30 min left for completing your On-Duty cycle for a day
                Local: \(times.local)
                GMT:   \(times.gmt)
                """,
                    backgroundColor: .yellow
                )
                    didShowOnDuty30MinToday = true
                    didShowOnDuty30MinWarning = true
                    didShow30MinWarning = true  // Keep global flag for compatibility
                    
                    print("OnDuty 30min warning fired once")
                    saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before On-Duty time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                }
            // 15-min warning
                else if let warning2 = DriverInfo.setWarningOnDutyTime2,
                        Int(workingTime) >= Int(warning2),
                        !didShowOnDuty15MinToday {
                    
                activeTimerAlert = TimerAlert(
                        title: "On-Duty Reminder",
                        message: """
                15 min left for completing your On Duty cycle for a day
                Local: \(times.local)
                  GMT:   \(times.gmt)
                """,
                    backgroundColor: .orange
                )
                    didShowOnDuty15MinToday = true
                    didShowOnDuty15MinWarning = true
                    didShow15MinWarning = true  // Keep global flag for compatibility
                    print("OnDuty 15min warning fired once")
                    saveViolationToDatabase(status: "Warning", DutyType: "15 minutes left before On Duty time exceedsLocal: \(times.local) ,GMT:\(times.gmt)", isVoilation: false)
                }
            }
        }
        
            // MARK: - OnDrive Timer Violation with Working Time **************************************************************************************************
        
        .onReceive(driveTimer.$remainingTime) { remainingTime in
            let totalDriveTime = DriverInfo.onDriveTime ?? 0
            let workingTime = Double(totalDriveTime) - remainingTime
            let violationThreshold = Double(totalDriveTime)

            print("Working: \(workingTime/3600) h, Remaining: \(remainingTime/3600) h")
                    // Violation check - use daily tracking
                    if workingTime >= violationThreshold && !didShowDriveViolationToday {
                        activeTimerAlert = TimerAlert(
                            title: "On-Drive Violation",
                            message: "Your Ondrive time has been exceeded to 11 hours",
                            backgroundColor: .red.opacity(0.9),
                            isViolation: true
                        )
                        didShowDriveViolationToday = true
                        didShowViolation = true
                        addViolationBox(text: "Your On Drive time has been exceeded to 11 hours")
                        print("Drive Violation fired once")
                        saveViolationToDatabase(status: "Violation", DutyType: "Your On Drive time has been exceeded to 11 hours \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)
                        
                    } else {
                        // 30-min warning - NO violation box
                        if let warning1 =  DriverInfo.setWarningOnDriveTime1,
                           Int(workingTime) >= Int(warning1),
                           !didShowDrive30MinToday {
                            
                activeTimerAlert = TimerAlert(
                    title: "On-Drive Reminder",
                                message: """
                        30 min left for completing your On Drive cycle for a day
                        Local: \(times.local)
                        GMT:   \(times.gmt)
                        """,
                    backgroundColor: .yellow
                )
                            didShowDrive30MinToday = true
                didShow30MinWarning = true
                            
                            print("Drive 30min warning fired once")
                            // Save as warning, not violation - NO violation box
                            saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before On Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                        }
                        
                        // 15-min warning - NO violation box
                        else if let warning2 =   DriverInfo.setWarningOnDriveTime2,
                                Int(workingTime) >= Int(warning2),
                                !didShowDrive15MinToday {
                            
                activeTimerAlert = TimerAlert(
                                title: "On-Drive Reminder",
                                message: """
                        15 min left for completing your On Drive cycle for a day
                        Local: \(times.local)
                        GMT:   \(times.gmt)
                        """,
                    backgroundColor: .orange
                )
                            didShowDrive15MinToday = true
                didShow15MinWarning = true
                            print("Drive 15min warning fired once")
                            // Save as warning, not violation - NO violation box
                            saveViolationToDatabase(status: "Warning", DutyType: "15 minutes left before On Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                        }
                        
                        
                    }
                    
                }
        
        // MARK: - Continue Drive Timer Violation Logic with Working Time*****************************************************************************************
        
            .onReceive(continueDriveTime.$remainingTime) { remainingTime in
                let totalDriveTime = DriverInfo.continueDriveTime ?? 0
                let workingTime = Double(totalDriveTime) - remainingTime
                let violationThreshold = Double(totalDriveTime)
                
                print("Working: \(workingTime/3600) h, Remaining: \(remainingTime/3600) h")
                
                //  Violation check at 8:00 - use daily tracking
                if workingTime >= violationThreshold && !didShowContinueDriveViolationToday {
                activeTimerAlert = TimerAlert(
                        title: "Continue Violation",
                        message: "Your drive time has been exceeded to 8 hours \(times.local) GMT \(times.gmt)",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                    didShowContinueDriveViolationToday = true
                didShowViolation = true
                    print("Continue Drive Violation fired once")
                    
                    saveViolationToDatabase(status: "voilation", DutyType: " Your drive time has been exceeded to 8 hours : \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)
                    
                    
                } else {
                    //  30-min warning at 7:30 (27000s) - use daily tracking
                    let warning30Min = DriverInfo.warningBreakTime1
                    if Int(workingTime) >= warning30Min ?? 0 && !didShowDrive30MinToday {
                        activeTimerAlert = TimerAlert(
                            title: "Continue Drive Reminder",
                            message: "30 minutes left before reaching 8 hours  \(times.local) GMT \(times.gmt)",
                            backgroundColor: .yellow
                        )
                        
                        didShowDrive30MinToday = true
                        didShow30MinWarning = true
                        
                        print("Continue Drive 30min warning fired once")
                        saveViolationToDatabase(status: "voilation", DutyType: "30 minutes left before Continue Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                        
                    }
                    
                    //  15-min warning at 7:45 (27900s) - use daily tracking
                    let warning15Min = DriverInfo.warningBreakTime1
                    if Int(workingTime) >= warning15Min ?? 0 && !didShowDrive15MinToday {
                activeTimerAlert = TimerAlert(
                            title: "Continue Drive Alert",
                            message: "15 minutes left before reaching 8 hours  \(times.local) GMT \(times.gmt)",
                    backgroundColor: .orange
                )
                   
                            didShowDrive15MinToday = true
                            didShow15MinWarning = true
                        print("Continue Drive 15min warning fired once")
                        saveViolationToDatabase(status: "warning", DutyType: "15 minutes left before Continue Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                        
                    }
                }
            }
        
        
            //** MARK: - Cycle Timer Violation Logic with Working Time**********************************************************************************************
                .onReceive(cycleTimerOn.$remainingTime) { remainingTime in
                    
                    //   let totalCycleTime = CountdownTimer.timeStringToSeconds("70:00:00") // 70 hours in seconds
                    let totalCycleTime = DriverInfo.cycleTime ?? 252000
                    let workingTime = Double(totalCycleTime) - remainingTime
                    let violationThreshold = totalCycleTime
                    
                    print(" Cycle 30min warning: Worked \(workingTime/3600) hours, \(remainingTime/3600) hours remaining")
                    
                    if Int(workingTime) >= violationThreshold && !didShowCycleViolationToday {
                activeTimerAlert = TimerAlert(
                            title: "cycle Violation",
                            message:  "Your Cycle time has been exceeded to 70 hours \(times.local) GMT \(times.gmt)",
                            backgroundColor: .red.opacity(0.9),
                            isViolation: true
                        )
                        
                        didShowCycleViolationToday = true
                        didShowViolation = true
                        print("Cycle Violation fired once")
                        saveViolationToDatabase(status: "Voilation", DutyType: "70 Hours cycle time exceed: \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)
                        
                    }
                    else {
                        // 30-min warning (safe unwrap) - use daily tracking
                        if let warning1 = DriverInfo.cycleRestartTime,
                           //DriverInfo.setWarningOnDriveTime1,
                           Int(workingTime) >= warning1,
                           !didShowDrive30MinToday {
                activeTimerAlert = TimerAlert(
                                title: "Cycle Time Reminder",
                                message: "30 minutes left for completing your  cycle of the Week \(times.local) GMT \(times.gmt)",
                                backgroundColor: .yellow
                            )
                            didShowDrive30MinToday = true
                            didShow30MinWarning = true
                            print("Cycle 30min warning fired once")
                            
                            saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before cycle time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                            
                            //
                        }
                        
                        // 15-min warning (safe unwrap) - use daily tracking
                        else if let warning2 = DriverInfo.cycleRestartTime                                                                                                                                                           ,
                                
                                    Int(workingTime) >= warning2,
                                !didShowDrive15MinToday {
                activeTimerAlert = TimerAlert(
                                title: "cycle Alert",
                                message: "15 minutes left for completing your  cycle of the week \(times.local) GMT \(times.gmt)",
                                backgroundColor: .orange
                            )
                            didShowDrive15MinToday = true
                            didShow15MinWarning = true
                            print("Cycle 15min warning fired once")
                            
                            saveViolationToDatabase(status: "Warning", DutyType: "15 minutes left before cycle time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                            
                        }
                    }
  
                }
            
            //MARK: -  Break Timer Completion Logic
            .onReceive(breakTime.$remainingTime) { remaining in
                print("Remaining Break Time: \(remaining)")
                
                // Check if break timer has completed (30 minutes = 0)
                if remaining <= 0 {
                    print(" Break timer completed - 30 minutes break finished")
                    isBreakTimerCompleted = true  // Set flag that break is completed
                    print(" Break timer completion flag set to true")
                }
            }
            
            //MARK: -  SleepTimer Logic
            
            .onReceive(sleepTimer.$remainingTime) { remaining in
            print("Remaining Sleep Time: \(remaining)")
            
            if remaining <= 0 && !showSleepResetPopup {
                showSleepResetPopup = true
                hasShownSleepResetPopup =  true
            }
                    
                    // Calculate off-duty and sleep time from database
                    let calculatedTimes = calculateOffDutyAndSleepTime()
                    let totalOffDuty = calculatedTimes.offDuty
                    let totalSleep = calculatedTimes.sleep
                    let totalRestTime = totalOffDuty + totalSleep
                    
                    print(" Calculated Times - OffDuty: \(totalOffDuty/3600)h, Sleep: \(totalSleep/3600)h, Total Rest: \(totalRestTime/3600)h")
                    
                    let tenHours: TimeInterval = 10 * 60 * 60
                    // Show NEXTDAY popup when 10 hours of rest time is reached
                    if totalRestTime >= tenHours && !showNextDayPopup && !hasShownNextDayPopup {
                        print(" 10-hour reset condition met! Total rest time: \(totalRestTime/3600) hours - Showing NEXTDAY popup")
                        // Reset timers immediately when popup appears
                        resetTimersForNextDay()
                        showNextDayPopup = true
                        hasShownNextDayPopup = true
                        // Auto dismiss after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            showNextDayPopup = false
                            print(" NEXTDAY popup auto-dismissed after 3 seconds")
                        }
                    }
                    // Also show sleep reset popup for sleep timer completion
                    if remaining <= 0 && !showSleepResetPopup {
                        showSleepResetPopup = true
                        hasShownSleepResetPopup = true
                    }
                }
            
            

        .alert(isPresented: $showSleepResetPopup) {
                    
            let safeDay = daysCount ?? 1
            let safeShift = ShiftCurrentDay ?? 1
            
            return Alert(
                title: Text("Next Day Start"),
                message: Text("Day \(safeDay)\nShift \(safeShift)"),
                dismissButton: .default(Text("OK")) {
                    daysCount = safeDay + 1
                    ShiftCurrentDay = safeShift
                    
                    
                  //  Save updated values in UserDefaults
                                UserDefaults.standard.set(daysCount, forKey: "days")
                                UserDefaults.standard.set(ShiftCurrentDay, forKey: "shift")
                                print("Updated Day: \(daysCount ?? 0), Shift: \(ShiftCurrentDay ?? 0)")
                    
                    
                    DatabaseManager.shared.updateDayShiftInDB(
                               day: daysCount ?? 1,
                               shift: ShiftCurrentDay ?? 1,
                               userId: UserDefaults.standard.integer(forKey: "userId")
                           )
                           
                    
                    // Reset timers with API values
                    let sleepTime = DriverInfo.onSleepTime ?? 36000.0
                    let onDutyTime = DriverInfo.onDutyTime ?? 50400.0
                    let onDriveTime = DriverInfo.onDriveTime ?? 39600.0
                    
                    sleepTimer.resetsSleep(to: sleepTime)
                    ONDuty.resetsSleep(to: onDutyTime)
                    driveTimer.resetsSleep(to: onDriveTime)
                    showSleepResetPopup = false
                    
                            // Reset status to Off-Duty after timer reset
                            confirmedStatus = DriverStatusConstants.offDuty
                            selectedStatus = DriverStatusConstants.offDuty
                    saveNextDayLog()
                            
                        }
                    )
                }
            
            //MARK: - NEXTDAY Popup Alert (Auto-dismiss after 3 seconds)
                .alert(isPresented: $showNextDayPopup) {
                    let safeDay = daysCount ?? 1
                    let safeShift = ShiftCurrentDay ?? 1
                    
                    return Alert(
                        
                        title: Text("NEXTDAY"),
                        message: Text("10 hours of rest time completed!\nTimers have been reset.\nDay \(safeDay)\nShift \(safeShift)")
                        
                        
                    )
                }
        
        
        //MARK: -  For Deletation Alert
        .alert("Are you sure you want to delete all data?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                Task {
                    if let driverId = DriverInfo.driverId {  //  Get from common storage
                        await deleteViewModel.deleteAllDataOnVersionClick(driverId: driverId)
                        showSuccessAlert = true // Show success after API
                        deleteAllAppData()
                        
                        // Delete all Continue Drive data
                        ContinueDriveDBManager.shared.deleteAllContinueDriveData()
                        print(" Continue Drive data deleted successfully")
        
                    } else {
                        print(" Driver ID not found in UserDefaults")
                    }
                }
         
            }
            
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all logs Record.")
        }
       //MARK: - Showing Refresh Log alert
        .alert("Are you sure you want to refresh all logs?", isPresented: $showSyncconfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("OK", role: .destructive) {
                Task {
                    await viewModel.refresh()   //  Call your refresh API
                   
                }
            }
        } message: {
            Text("This will refresh all your local logs with the server.")
        }


        //MARK: -   Success alert after deletion
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                navmanager.navigate(to: AppRoute.Login)}
            
        } message: {
            Text("Data deleted successfully.")
        }

        .navigationBarBackButtonHidden()
    }
    
          //MARK: Function to Show Banner for 3 seconds
        func showToast(message: String, color: Color) {
        bannerMessage = message
        bannerColor = color
        showBanner = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showBanner = false
            }
        }
    }
    
    // Add this function to save NEXTDAY log
    private func saveNextDayLog() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        // Create a custom log model for NEXTDAY
        let nextDayLog = DriverLogModel(
            id: nil,
            status: "NEXTDAY",
            startTime: now,
            userId: UserDefaults.standard.integer(forKey: "userId"),
            day: UserDefaults.standard.integer(forKey: "day"),
            isVoilations: 0,
            dutyType: "NewShift",
            shift: 1,
            vehicle: UserDefaults.standard.string(forKey: "truckNo") ?? "Null",
            isRunning: false,
            odometer: 0.0,
            engineHours: "0",
            location: UserDefaults.standard.string(forKey: "customLocation") ?? "",
            lat: Double(UserDefaults.standard.string(forKey: "lattitude") ?? "") ?? 0,
            long: Double(UserDefaults.standard.string(forKey: "longitude") ?? "") ?? 0,
            origin: "Unidentified",
            isSynced: false,
            vehicleId: UserDefaults.standard.integer(forKey: "vehicleId"),
            trailers: UserDefaults.standard.string(forKey: "trailer") ?? "",
            notes: "New day",
            serverId: nil,
            timestamp: TimeUtils.currentTimestamp(with: DriverInfo.timeZoneOffset),
            identifier: 0,
            remainingWeeklyTime: cycleTimerOn.internalTimeString,
            remainingDriveTime:  driveTimer.internalTimeString,
            remainingDutyTime: ONDuty.internalTimeString,
            remainingSleepTime: sleepTimer.internalTimeString,
            lastSleepTime: breakTime.internalTimeString,
            isSplit: 0,
            engineStatus: "Off",
            isCertifiedLog: ""
        )
        
        // Insert the log directly using the existing insertLog method
        DatabaseManager.shared.insertLog(from: nextDayLog)
        print(" NEXTDAY log saved to database at \(now)")
    }
    
    
       private func loadTodayHOSEvents() {
        let todayLogs = DatabaseManager.shared.fetchDutyEventsForToday()
        print(" Logs fetched from DB: \(todayLogs.count)")
        for log in todayLogs {
            print("→ \(log.status) from \(log.startTime) to \(log.endTime)")
        }
        let converted = todayLogs.enumerated().compactMap { index, log -> HOSEvent? in
            HOSEvent(
                id: index,
                x: log.startTime,
                event_end_time: log.endTime,
                label: log.status,
                dutyType: log.status
            )
        }
        hoseEvents = converted
    }
    
        //MARK: -  VoilationBox Function
        func addViolationBox(text: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd"
            let dateString = formatter.string(from: Date())
            
            formatter.dateFormat = "HH:mm:ss"
            let timeString = formatter.string(from: Date())
            
            let violationData = ViolationBoxData(
                text: text,
                date: dateString,
                time: timeString,
                timestamp: Date()
            )
            
            violationBoxes.append(violationData)
            showViolationBoxes = true
            
            // Auto-hide after 25 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                violationBoxes.removeAll { $0.timestamp == violationData.timestamp }
                if violationBoxes.isEmpty {
                    showViolationBoxes = false
                }
            }
        }
     func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let parts = timeString.split(separator: ":").map { Int($0) ?? 0 }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0], minutes = parts[1], seconds = parts[2]
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
    
    // MARK: - Check for 10-hour reset (Off-Duty + Sleep)
    
     func checkFor10HourReset() {
        //MARK: -  Total Off-Duty + Sleep time
        let totalRest = offDutySleepAccumulated
            
        if totalRest >= 10 * 3600 {
                print("10-hour reset reached. Resetting all timers except Cycle Timer.")

            // Stop all timers
            driveTimer.stop()
            ONDuty.stop()
                continueDriveTime.stop()
            sleepTimer.stop()
            breakTime.stop()

            //Reset timers to full time (but DO NOT reset cycleTimerOn)
            driveTimer.reset(startTime: CountdownTimer.timeStringToSeconds("(11:00:00"))
            ONDuty.reset(startTime: CountdownTimer.timeStringToSeconds("14:00:00"))
                continueDriveTime.reset(startTime: CountdownTimer.timeStringToSeconds("08:00:00"))
            sleepTimer.reset(startTime: CountdownTimer.timeStringToSeconds("10:00:00"))
            breakTime.reset(startTime: CountdownTimer.timeStringToSeconds("00:30:00"))

            // Clear accumulated rest time
            offDutySleepAccumulated = 0
            // Refresh UI (On-Duty will start again when user selects status)
            confirmedStatus = DriverStatusConstants.offDuty
            selectedStatus = DriverStatusConstants.offDuty

            // Reload Events after reset
            hoseChartViewModel.forceRefresh()

            // Save logs in DB for future restore
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = formatter.string(from: Date())

            DatabaseManager.shared.saveTimerLog(
                status: "Reset After 10 Hour Rest",
                    startTime: now, dutyType: "Reset After 10 Hour Rest",
                remainingWeeklyTime: cycleTimerOn.internalTimeString, // keep same cycle time
                remainingDriveTime: driveTimer.internalTimeString,
                remainingDutyTime: ONDuty.internalTimeString,
                remainingSleepTime: sleepTimer.internalTimeString,
                lastSleepTime: breakTime.internalTimeString,
                RemaningRestBreak: "false",
                isruning: false,
                isVoilations: false
            )
        }
    }

    
    
    //MARK: - #$ HOURS RESET WHEN  SHIFT IS START NEW
    func checkFor34HourReset() {
        
        
        if let lastOffDuty = offDutyStartTime {
            let elapsed = Date().timeIntervalSince(lastOffDuty)
            if elapsed >= 34 * 3600 {
                pastDutyLog.removeAll()
                print(" 34-hour break complete. Cycle reset.")
            }
        }
    }
    //MARK: TO RELOAD DATA
    
    func loadLatestLog(for status: String) -> DriverLogModel? {
        return DatabaseManager.shared.fetchLogs()
            .filter { $0.status == status }
            .sorted { $0.timestamp > $1.timestamp }
            .first
    }
    
    //MARK: -  Restore & save time
    func restoreAllTimers() {
            
            isRestoringTimers = true  // Prevent auto-save during restoration
            print("🔄 Starting timer restoration - preventing auto-saves")
            
        let allLogs = DatabaseManager.shared.fetchLogs()
        print(" Total logs in database: \(allLogs.count)")
        
        guard !allLogs.isEmpty else {
            print(" No logs found, keeping timers as they are")
            return
        }
        // Get the most recent log
        let latestLog = allLogs.last!
        let currentStatus = latestLog.status
            print(" Latest log status: \(currentStatus)")
        print(" Latest log time: \(latestLog.startTime)")
        print(" Latest log remaining times - Duty: \(latestLog.remainingDutyTime ?? "nil"), Drive: \(latestLog.remainingDriveTime ?? "nil"), Cycle: \(latestLog.remainingWeeklyTime ?? "nil")")
        
        // Calculate elapsed time since the log was saved
        let now = Date()
        let logTime = latestLog.startTime.asDate() ?? now
        let elapsedTime = now.timeIntervalSince(logTime)
        
            print(" Current time: \(now)")
        print(" Log time: \(logTime)")
        print(" Elapsed time: \(elapsedTime) seconds (\(elapsedTime/60) minutes)")
        
        // Set the confirmed status from database
            print(" Restoring status from database: \(currentStatus)")
            
            // Handle special case: if database has "NEXTDAY", show "OffDuty" in UI
            if currentStatus == "NEXTDAY" {
                confirmedStatus = DriverStatusConstants.offDuty
                selectedStatus = DriverStatusConstants.offDuty
                print(" Mapped NEXTDAY to OffDuty for UI display")
            } else {
        confirmedStatus = currentStatus
        selectedStatus = currentStatus
            }
            
            print("&&&&&&&&&&&& Status restored - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
        
        // Force stop all timers first
        driveTimer.stop()
        ONDuty.stop()
        cycleTimerOn.stop()
        sleepTimer.stop()
        
        
        // Always restore ALL timer values from database, regardless of current status
            print(" &&&&&&&&&&&&Restoring ALL timer values  &&&&&&&&&&&& from database &&&&&&&&&&&&")

        
        // Restore OnDuty timer
            if let dutyRemaining = latestLog.remainingDutyTime?.asTimeInterval(){
                // Start OnDuty timer for OnDuty, OnDrive, and YardMove statuses
                if currentStatus == "OnDuty" || currentStatus == "OnDrive" || currentStatus == "YardMove" {
                // Running timer - subtract elapsed time (allow negative values)
                let adjustedDutyRemaining = dutyRemaining - elapsedTime
                ONDuty.reset(startTime: adjustedDutyRemaining)
                ONDuty.start()
                isOnDutyActive = true
                print(" OnDuty timer restored: \(ONDuty.timeString) (running - elapsed time subtracted)")
            } else {
                // Stopped timer - use exact saved value
                ONDuty.reset(startTime: dutyRemaining)
                print(" OnDuty timer restored: \(ONDuty.timeString) (stopped - exact saved value)")
            }
        }
            // Restore Drive timer
            if let driveRemaining = latestLog.remainingDriveTime?.asTimeInterval() {
                // Only start if current status is OnDrive (not OnDuty)
                if currentStatus == "OnDrive" {
                    // Running timer - subtract elapsed time (allow negative values)
                    let adjustedDriveRemaining = driveRemaining - elapsedTime
                    driveTimer.reset(startTime: adjustedDriveRemaining)
                    driveTimer.start()
                    //ONDuty.start()
                    isDriveActive = true
                    print("Drive timer restored: \(driveTimer.timeString) (running - elapsed time subtracted)")
                   
                } else {
                    driveTimer.reset(startTime: driveRemaining)
                    print("Drive timer restored: \(driveTimer.timeString) (stopped - exact saved value)")
                }
            }

        // Restore Cycle timer
        if let cycleRemaining = latestLog.remainingWeeklyTime?.asTimeInterval() {
            
                // Start if current status is OnDuty, OnDrive, or YardMove (running timers)
                if currentStatus == "OnDuty" || currentStatus == "OnDrive" || currentStatus == "YardMove" {
                // Running timer - subtract elapsed time (allow negative values)
                let adjustedCycleRemaining = cycleRemaining - elapsedTime
                cycleTimerOn.reset(startTime: adjustedCycleRemaining)
                cycleTimerOn.start()
                isCycleTimerActive = true
                    print("Cycle timer restored: \(cycleTimerOn.timeString) (running - elapsed time subtracted)")
            } else {
                // Stopped timer - use exact saved value
                cycleTimerOn.reset(startTime: cycleRemaining)
                    print("Cycle timer restored: \(cycleTimerOn.timeString) (stopped - exact saved value)")
            }
        }
        
        // Restore Sleep timer
        if let sleepRemaining = latestLog.remainingSleepTime?.asTimeInterval() {
            
            // Only start if current status is OnSleep (running timer)
            if currentStatus == "OnSleep" {
                let adjustedSleepRemaining = sleepRemaining - elapsedTime
                sleepTimer.reset(startTime: adjustedSleepRemaining)
                sleepTimer.start()
                print(" Sleep timer restored: \(sleepTimer.timeString) (running - elapsed time subtracted)")
            } else {
                sleepTimer.reset(startTime: sleepRemaining)
                print(" Sleep timer restored: \(sleepTimer.timeString) (stopped - exact saved value)")
            }
        }
        
        // Restore Break timer
        let breakRemaining = latestLog.lastSleepTime.asTimeInterval()
        if breakRemaining > 0 {
            // Break timer should be running if we're in OnDuty status (after switching from OnDrive)
            // OR if the break timer was running when app was closed (any status)
            let adjustedBreakRemaining = breakRemaining - elapsedTime
            breakTime.reset(startTime: adjustedBreakRemaining)
            breakTime.start()
            print(" Break timer restored: \(breakTime.timeString) (running - elapsed time subtracted)")
        } else {
            // If break time is 0 or negative, reset to 30 minutes
            breakTime.reset(startTime: 30 * 60)
            print(" Break timer reset to 30 minutes (no saved break time)")
        }
        
        print(" Timer restoration completed")
        isRestoringTimers = false  // Re-enable auto-save after restoration
        print(" Timer restoration completed - auto-saves re-enabled")
        }
    
    

    // Add these new functions to track shown violations
    func checkAndShowViolationsForCurrentDayShift(day: Int, shift: Int) {
        let allLogs = DatabaseManager.shared.fetchLogs()
        
        // Filter violations for current day and shift
        let currentDayShiftViolations = allLogs.filter { log in
            log.isVoilations == 1 &&
            log.status == "Violation" &&
            log.day == day &&
            log.shift == shift
        }
        
        // Check if we've already shown violations for this day/shift
        let shownViolationsKey = "shownViolations_\(day)_\(shift)"
        let hasShownViolations = UserDefaults.standard.bool(forKey: shownViolationsKey)
        
        if !currentDayShiftViolations.isEmpty && !hasShownViolations {
            print(" Found \(currentDayShiftViolations.count) violations for day \(day), shift \(shift)")
            
            // Show the most recent violation
            if let latestViolation = currentDayShiftViolations.last {
                showViolationAlert(violation: latestViolation)
                
                // Mark as shown for this day/shift
                UserDefaults.standard.set(true, forKey: shownViolationsKey)
                print(" Marked violations as shown for day \(day), shift \(shift)")
            }
        } else if hasShownViolations {
            print(" Violations already shown for day \(day), shift \(shift) - skipping")
        }
    }

    func showViolationAlert(violation: DriverLogModel) {
        activeTimerAlert = TimerAlert(
            title: "Violation Detected",
            message: violation.dutyType,
            backgroundColor: .red.opacity(0.9),
            isViolation: true
        )
        
        // Add to violation boxes
        addViolationBox(text: violation.dutyType)
        
        print(" Showing violation alert: \(violation.dutyType)")
    }

    // Add this function to reset violation tracking for new day/shift
    func resetViolationTrackingForNewDayShift() {
        let currentDay = UserDefaults.standard.integer(forKey: "days")
        let currentShift = UserDefaults.standard.integer(forKey: "shift")
        
        // Clear all previous day/shift violation tracking
        let defaults = UserDefaults.standard
        let keys = defaults.dictionaryRepresentation().keys
        for key in keys {
            if key.hasPrefix("shownViolations_") {
                defaults.removeObject(forKey: key)
            }
        }
        
        print(" Reset violation tracking for new day \(currentDay), shift \(currentShift)")
    }
    
    //MARK: - Save current timer states before switching
    func saveCurrentTimerStatesBeforeSwitch() {
        // Save current timer states to our state variables
        savedOnDutyRemaining = ONDuty.remainingTime
        savedDriveRemaining = driveTimer.remainingTime
        savedCycleRemaining = cycleTimerOn.remainingTime
        savedSleepingRemaning = sleepTimer.remainingTime
        savedBreakRemaining = breakTime.remainingTime
        
        print(" Saving timer states before switch:")
        print(" OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
        print(" Sleep: \(savedSleepingRemaning/60) min, Break: \(savedBreakRemaining/60) min")
    }
    
    //MARK: - Save current timer states
    func saveCurrentTimerStates() {
        guard let currentStatus = confirmedStatus else {
            print(" No confirmed status, cannot save timer states")
            return
        }
        
        // Prevent auto-save during timer restoration
        if isRestoringTimers {
            print(" Skipping auto-save during timer restoration")
            return
        }
        
        print(" Saving timer states for status: \(currentStatus)")
        print(" Current timer values - Duty: \(ONDuty.timeString), Drive: \(driveTimer.timeString), Cycle: \(cycleTimerOn.timeString)")
        print(" Saved timers - OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        
        // Use saved times if available, otherwise use current times (allow negative values)
        let dutyTimeToSave = savedOnDutyRemaining != 0 ? savedOnDutyRemaining : ONDuty.remainingTime
        let driveTimeToSave = savedDriveRemaining != 0 ? savedDriveRemaining : driveTimer.remainingTime
        let cycleTimeToSave = savedCycleRemaining != 0 ? savedCycleRemaining : cycleTimerOn.remainingTime
        
        // Use internal time strings for database (shows negative value s)
        let dutyTimeString = ONDuty.internalTimeString
        let driveTimeString = driveTimer.internalTimeString
        let cycleTimeString = cycleTimerOn.internalTimeString
        
        
        
        // Save current timer states to database
        DatabaseManager.shared.saveTimerLog(
            status: currentStatus,
            startTime: now, dutyType: currentStatus,
            remainingWeeklyTime: cycleTimeString,
            remainingDriveTime: driveTimeString,
            remainingDutyTime: dutyTimeString,
            remainingSleepTime: sleepTimer.timeString,
            lastSleepTime: breakTime.timeString,
            RemaningRestBreak: "true",
            isruning: true,
            isVoilations: false
            
        )
        print(" Timer states saved successfully at \(now)")
        print(" Times saved - OnDuty: \(dutyTimeString), Drive: \(driveTimeString), Cycle: \(cycleTimeString)")
        
    }

    
    //MARK: - load last timer from DB
    private func loadLatestTimersFromDB() {
        if let lastLog = DatabaseManager.shared.fetchLogs().last {

            //  Convert DB saved strings safely
            let dutyRemaining = lastLog.remainingDutyTime?.asTimeInterval() ?? 0
            let driveRemaining = lastLog.remainingDriveTime?.asTimeInterval() ?? 0
            let cycleRemaining = lastLog.remainingWeeklyTime?.asTimeInterval() ?? 0
            let sleepRemaining = lastLog.remainingSleepTime?.asTimeInterval() ?? 0

            //  Get start time as Date
            let startedAt = lastLog.startTime.asDate()
            // Restore timers (safe unwrapping)
            ONDuty.restore(from: dutyRemaining, startedAt: startedAt, wasRunning: true)
            driveTimer.restore(from: driveRemaining, startedAt: startedAt, wasRunning: true)
            cycleTimerOn.restore(from: cycleRemaining, startedAt: startedAt, wasRunning: true)
            sleepTimer.restore(from: sleepRemaining, startedAt: startedAt, wasRunning: true)

            print("""
             Timers restored:
            Duty \(ONDuty.timeString)
            Drive \(driveTimer.timeString)
            Cycle \(cycleTimerOn.timeString)
            Sleep \(sleepTimer.timeString)
            """)
        } else {
            print(" No timer logs found in DB")
        }
    }

    // MARK: - Delete All App Data
    func deleteAllAppData() {
        print(" Starting to delete all app data...")
        
        // 1. Clear all UserDefaults
        let defaults = UserDefaults.standard
        let allKeys = [
            "driverName", "userId", "authToken", "isLoggedIn",
            "companyId", "vehicleId", "coDriverId", "password",
            "rememberMe", "lastLoginTime", "driverId", "clientId"
        ]
        
        for key in allKeys {
            defaults.removeObject(forKey: key)
        }
        
        // 2. Clear KeyChain and Token
        let keychain = KeychainHelper()
        keychain.deleteToken()
        
        // 3. Clear SessionManager token
        SessionManagerClass.shared.clearToken()
        
        // 4. Clear Database
        DatabaseManager.shared.deleteAllLogs()
        
        // 5. Stop all timers
        driveTimer.stop()
        ONDuty.stop()
        cycleTimerOn.stop()
        sleepTimer.stop()
        breakTime.stop()
        
        // 6. Reset all state variables
        isDriveActive = false
        isOnDutyActive = false
        isCycleTimerActive = false
        isSleepTimerActive = false
        selectedStatus = DriverStatusConstants.offDuty
        confirmedStatus = DriverStatusConstants.offDuty
        labelValue = ""
        
        // 7. Clear saved timer states
        savedDriveRemaining = 0
        savedCycleRemaining = 0
        savedSleepingRemaning = 0
        hasAppearedBefore = false
        // 9. Show success message
        showToast(message: "All data deleted successfully", color: .green)

        print(" All app data deleted successfully")
    }

    
    
    //MARK: -  6 add funct to calculate 70 hour cycle
    func totalDutyLast7or8Days() -> TimeInterval {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let daysToInclude = (cycleType == "7/60") ? 7 : 8
        
        var total: TimeInterval = 0
        
        for i in 0..<daysToInclude {
            if let date = calendar.date(byAdding: .day, value: -i, to: today),
               let time = pastDutyLog[calendar.startOfDay(for: date)] {
                total += time
            }
        }
        return total
    }
    
    func saveDailyDutyLog(duration: TimeInterval) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        pastDutyLog[today, default: 0] += duration
        //  print(" Saved \(duration / 3600, specifier: "%.2f") hrs for \(formattedDate(today))")
    }

    
    func checkAndStartCycleTimer() {
        print(" Checking Cycle Timer: Drive=\(isDriveActive), Duty=\(isOnDutyActive)")
        
        if isOnDutyActive {
            startCycleTimer()
        }else if   isDriveActive {
            startCycleTimer()
        }
        else {
            stopCycleTimer()
        }
    }
    
    func startCycleTimer() {
        guard !isCycleTimerActive else { return }
        print(" Starting Cycle Timer")
        isCycleTimerActive = true
            cycleTimerOn.start()          //MARK: - this is the CountdownTimer you passed to AvailableHoursView
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        DatabaseManager.shared.saveTimerLog(
            status: "Cycle",
            startTime: now, dutyType: "Cycle",
            remainingWeeklyTime: cycleTimerOn.internalTimeString,
            remainingDriveTime: driveTimer.internalTimeString,
            remainingDutyTime: ONDuty.internalTimeString,
            remainingSleepTime: sleepTimer.internalTimeString,
            lastSleepTime: "", RemaningRestBreak: breakTime.internalTimeString, isruning: false,
        )
        
            print(" Saved Cycle timer to DB at \(now)")
    }
    
    func stopCycleTimer() {
        guard isCycleTimerActive else { return }
        isCycleTimerActive = false
        cycleTimerOn.stop() //  stop your cycle countdown
        print(" Cycle Timer Stopped")
    }
    
        //MARK: - Reset Timers for Next Day
        func resetTimersForNextDay() {
            print(" Resetting timers for NEXTDAY...")
            
            // Update day and shift
            let safeDay = daysCount ?? 1
            let safeShift = ShiftCurrentDay ?? 1
            daysCount = safeDay + 1
            ShiftCurrentDay = safeShift
            
            // Save updated values in UserDefaults
            UserDefaults.standard.set(daysCount, forKey: "days")
            UserDefaults.standard.set(ShiftCurrentDay, forKey: "shift")
            print("NEXTDAY - Updated Day: \(daysCount ?? 0), Shift: \(ShiftCurrentDay ?? 0)")
            
            // Update database
            DatabaseManager.shared.updateDayShiftInDB(
                day: daysCount ?? 1,
                shift: ShiftCurrentDay ?? 1,
                userId: UserDefaults.standard.integer(forKey: "userId")
            )
            
            // Reset timers with API values
            let sleepTime = DriverInfo.onSleepTime ?? 36000.0
            let onDutyTime = DriverInfo.onDutyTime ?? 50400.0
            let onDriveTime = DriverInfo.onDriveTime ?? 39600.0
            
            sleepTimer.resetsSleep(to: sleepTime)
            ONDuty.resetsSleep(to: onDutyTime)
            driveTimer.resetsSleep(to: onDriveTime)
            
            // Reset status to Off-Duty after timer reset
            confirmedStatus = DriverStatusConstants.offDuty
            selectedStatus = DriverStatusConstants.offDuty
            
            // Save NEXTDAY log
            saveNextDayLog()
            
            print(" Timers reset completed for NEXTDAY")
        }
        
        //MARK: - Calculate OffDuty and Sleep Time from Database
        func calculateOffDutyAndSleepTime() -> (offDuty: TimeInterval, sleep: TimeInterval) {
            let allLogs = DatabaseManager.shared.fetchLogs()
            
            guard !allLogs.isEmpty else {
                print(" No logs found in database")
                return (0, 0)
            }
            
            // Sort logs by timestamp
            let sortedLogs = allLogs.sorted { $0.timestamp < $1.timestamp }
            
            var totalOffDuty: TimeInterval = 0
            var totalSleep: TimeInterval = 0
            let currentTime = Date()
            
            print(" Processing \(sortedLogs.count) logs for time calculation")
            
            for (index, log) in sortedLogs.enumerated() {
                let startTime = log.startTime.asDate() ?? currentTime
                let endTime: Date
                
                // If this is the last log, use current time
                if index == sortedLogs.count - 1 {
                    endTime = currentTime
                } else {
                    // Use the start time of the next log as end time
                    endTime = sortedLogs[index + 1].startTime.asDate() ?? currentTime
                }
                
                let duration = endTime.timeIntervalSince(startTime)
                
                switch log.status {
                    
                case "OffDuty":
                    totalOffDuty += duration
                    print(" OffDuty: \(log.startTime) for \(duration/3600) hours")
                    
                case "OnSleep":
                    totalSleep += duration
                    print(" OnSleep: \(log.startTime) for \(duration/3600) hours")
                    
                default:
                    break
                }
            }
            
            print("Total calculated - OffDuty: \(totalOffDuty/3600)h, Sleep: \(totalSleep/3600)h")
            return (totalOffDuty, totalSleep)
        }
        
        
        //MARK: - saving voilation in database
        func saveViolationToDatabase(status: String, DutyType: String,isVoilation: Bool) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = formatter.string(from: Date())
            
            print(" Saving violation to database: \(DutyType) for status: \(status)")
            
            DatabaseManager.shared.saveTimerLog(
                status: status,
                startTime: now, dutyType: DutyType,
                remainingWeeklyTime: cycleTimerOn.internalTimeString,
                remainingDriveTime: driveTimer.internalTimeString,
                remainingDutyTime: ONDuty.internalTimeString,
                remainingSleepTime: sleepTimer.internalTimeString,
                lastSleepTime: breakTime.internalTimeString,
                RemaningRestBreak: "true",
                isruning: false,
                isVoilations: true
            )
            print(" Violation saved to database successfully")
        }
        
        
        //MARK: -  Load Voilation from data base
        func loadViolationsFromDatabase() {
            let logs = DatabaseManager.shared.fetchLogs()
            // Get today's date for comparison
            let today = Calendar.current.startOfDay(for: Date())
            // Filter violations: only today's violations AND actual violations (not warnings)
            let violationLogs = logs.filter { log in
                // Check if it's a violation (not warning)
                let isViolation = log.isVoilations == 1 && log.status == "Violation"
                // Check if it's from today
                let logDate = Calendar.current.startOfDay(for: log.startTime.asDate() ?? Date())
                let isToday = Calendar.current.isDate(logDate, inSameDayAs: today)
                return isViolation && isToday
            }
            
            violationBoxes.removeAll()
            
            for log in violationLogs {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd"
                let dateString = formatter.string(from: log.startTime.asDate() ?? Date())
                
                formatter.dateFormat = "HH:mm:ss"
                let timeString = formatter.string(from: log.startTime.asDate() ?? Date())
                
                let violationData = ViolationBoxData(
                    text: log.dutyType,
                    date: dateString,
                    time: timeString,
                    timestamp: log.startTime.asDate() ?? Date()
                )
                
                violationBoxes.append(violationData)
            }
            
            if !violationBoxes.isEmpty {
                showViolationBoxes = true
            }
        }

    // MARK: - Check if new day and reset violation flags
    func checkAndResetDailyViolations() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if lastViolationDate != today {
            print(" New day detected - resetting violation flags")
            lastViolationDate = today
            
            // Reset all daily violation flags
            didShowOnDuty30MinToday = false
            didShowOnDuty15MinToday = false
            didShowOnDutyViolationToday = false
            didShowDrive30MinToday = false
            didShowDrive15MinToday = false
            didShowDriveViolationToday = false
            didShowCycleViolationToday = false
            didShowContinueDriveViolationToday = false
            
            print(" All violation flags reset for new day")
        }
    }
    
    // MARK: - Stop All Timers
    func stopAllTimers() {
        print("🛑 Stopping all timers for Personal Use")
        
        // Stop all active timers
        if isOnDutyActive {
            ONDuty.stop()
            isOnDutyActive = false
        }
        
        if isDriveActive {
            driveTimer.stop()
            isDriveActive = false
        }
        
        if isCycleTimerActive {
            cycleTimerOn.stop()
            isCycleTimerActive = false
        }
        
        if isSleepTimerActive {
            sleepTimer.stop()
            isSleepTimerActive = false
        }
        
        // Stop break timer
        breakTime.stop()
        
        print(" All timers stopped for Personal Use")
    }
    
    // MARK: - Start OnDuty and Cycle Timers for Yard Move
    func startYardMoveTimers() {
        print(" Starting OnDuty and Cycle timers for Yard Move")
        
        // Start OnDuty timer
        if !isOnDutyActive {
            ONDuty.start()
            isOnDutyActive = true
            print(" OnDuty timer started for Yard Move")
        }
        
        // Start Cycle timer
        if !isCycleTimerActive {
            cycleTimerOn.start()
            isCycleTimerActive = true
            print(" Cycle timer started for Yard Move")
        }
        
        // Stop other timers that shouldn't run during Yard Move
        if isDriveActive {
            driveTimer.stop()
            isDriveActive = false
            print(" Drive timer stopped for Yard Move")
        }
        
        if isSleepTimerActive {
            sleepTimer.stop()
            isSleepTimerActive = false
            print(" Sleep timer stopped for Yard Move")
        }
        
        print(" Yard Move timers configured")
    }
    
    // MARK: - Save Violation to Database
    func saveViolationToDatabase(status: String, violationType: String, dutyType:String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        print(" Saving violation to database: \(violationType) for status: \(status)")
        
        DatabaseManager.shared.saveTimerLog(
            status: status,
            startTime: now, dutyType: dutyType,
            remainingWeeklyTime: cycleTimerOn.internalTimeString,
            remainingDriveTime: driveTimer.internalTimeString,
            remainingDutyTime: ONDuty.internalTimeString,
            remainingSleepTime: sleepTimer.internalTimeString,
            lastSleepTime: breakTime.internalTimeString,
            RemaningRestBreak: "true",
            isruning: false,
            isVoilations: true
        )
        
        print(" Violation saved to database successfully")
    }

    }




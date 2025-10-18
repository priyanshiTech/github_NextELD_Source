//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 07/05/25.
//
//
import SwiftUI


// MARK: - Main View
struct HomeScreenView: View {
    
    @EnvironmentObject var appRootManager: AppRootManager
    @StateObject private var homeVM : HomeViewModel = .init()
    
    @State private var labelValue = ""
    @State private var OnDutyvalue: Int = 0
    @State private var selectedStatus: String? = nil
    @State private var confirmedStatus: String? = nil
    @State private var showCertifyLogAlert = false
    @State private var showStatusalert: Bool = false
    @State private var showLogoutPopup: Bool = false
    @State private var ShowrefreshPopup: Bool = false
    @State private var isCycleCompleted: Bool = false
    @State var presentSideMenu: Bool = false
    @State var selectedSideMenuTab: Int = 0
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
    
    var emptyDvirRecord: DvirRecord {
        DvirRecord(
            id: nil,
            UserID: "",
            UserName: "",
            startTime: "\(DateTimeHelper.currentDate()) \(DateTimeHelper.currentTime())",
            DAY: DateTimeHelper.currentDate(),
            Shift: "1",                        // Default shift
            DvirTime: DateTimeHelper.currentTime(),
            odometer: 0.0,
            location: "",
            truckDefect: "",
            trailerDefect: "",
            vehicleCondition: "",
            notes: "",
            vehicleName: "",
            vechicleID: "",
            Sync: 1,
            timestamp: "\(Int(Date().timeIntervalSince1970 * 1000))",
            Server_ID: "",
            Trailer: ""
        )
    }
    
    
    @StateObject var dutyManager: DutyStatusManager = DutyStatusManager()
    @EnvironmentObject var navManager: NavigationManager
    
    
    @StateObject private var ONDuty: CountdownTimer
    
    @StateObject private var driveTimer: CountdownTimer
    
    @StateObject private var cycleTimerOn: CountdownTimer
    
    @StateObject private var sleepTimer: CountdownTimer
    
    @StateObject private var continueDriveTime: CountdownTimer
    
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
    @EnvironmentObject var navmanager: NavigationManager
    
    
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
    
    
    
    init() {
        let breakTimer =  CountdownTimer.timeStringToSeconds("00:30:00")
        _ONDuty = StateObject(wrappedValue: CountdownTimer(startTime: DriverInfo.onDutyTime ?? 140000))
        _driveTimer = StateObject(wrappedValue: CountdownTimer(startTime: DriverInfo.onDriveTime ?? 110000))
        _cycleTimerOn = StateObject(wrappedValue: CountdownTimer(startTime: TimeInterval(DriverInfo.cycleTime ?? 700000)))
        _sleepTimer = StateObject(wrappedValue: CountdownTimer(startTime: DriverInfo.onSleepTime ?? 10000))
        _continueDriveTime = StateObject(wrappedValue: CountdownTimer(startTime: DriverInfo.continueDriveTime ??  080000))
        _breakTime = StateObject(wrappedValue: CountdownTimer(startTime: breakTimer))
    }
    
    
    // let session: SessionManager
    @State private var activeTimerAlert: TimerAlert?
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
    @State private var daysCount =  DriverInfo.Days
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

    @StateObject private var logoutVM = APILogoutViewModel()   //logout
    @State private var showsyncRefreshalert = RefreshViewModel()  // Refresh
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var hasRestoredTimers = false
    let times = DateTimeHelperVoilation.getLocalAndGMT()
    @State private var showDvirPopup = false
    @StateObject var deviceLocationManager = DeviceLocationManager()
    
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
                        
                            StatusView(homeViewModel: homeVM) { status in
                            // passing a new status to assign this new status to current status after the alert submit button clicked
                            homeVM.showDriverStatusAlert = (true, status)
                        }

                        
                        AvailableHoursView(homeViewModel: homeVM)
                        
                        HOSEventsChartScreen(currentStatus: confirmedStatus)
                            .environmentObject(hoseChartViewModel)
                        
                        //MARK: - Violation Boxes (Part of Main Scroll) - Removed, now using alerts
                        
                        VStack(alignment: .leading) {
                            Text("Version - OS/02/May")
                        }
                    }
                }
                .scrollIndicators(.hidden)
        .onAppear {
            //  loadViolationsFromDatabase()
            initializeViolationFlags()
            homeVM.resetDailyViolationFlags() // Reset daily flags on app start
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
                    showDeleteConfirm: $showDeleteConfirm, showSyncConfirmation:  $homeVM.showSyncconfirmation,
                    
                )
                .frame(width: 250)
                .background(Color.white)
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
            
            // Showing Driver Status Alerts
            if homeVM.showDriverStatusAlert.showAlert {
                // Popup content
                StatusDetailsPopup(
                    statusTitle: homeVM.showDriverStatusAlert.status.getName(),
                    onClose: { homeVM.showDriverStatusAlert.showAlert = false },
                    onSubmit: { note in
                        let status = homeVM.showDriverStatusAlert.status
                        
                        // Set new status and start timers
                       homeVM.setDriverStatus(status: status)
                        // Save new timer state after status change
                        homeVM.saveTimerStateForStatus(status: status.getName(), note: note)
                        // Close the popup after submit
                        homeVM.showDriverStatusAlert.showAlert = false
                    },
                    DVClocationManager: deviceLocationManager
                )
            }
            //nitin
            
            //MARK: -  Show Certify popup
            
            if showDvirPopup {
                CustomPopupAlert(
                    title: "Add DVIR Log",
                    message: "Please add DVIR before going to On-Drive",
                    onOK: {
                        
                        //                        navmanager.navigate(to: .vehicleFlow(.AddDvirScreenView(
                        //                                                                   selectedVehicle: "",
                        //                                                                   selectedRecord: emptyDvirRecord,
                        //                                                                   isFromHome: true
                        //                                                               )))
                        //                        navmanager.navigate(to: })
                        
                        
                        showDvirPopup = false
                    },
                    onCancel: { showDvirPopup = false }
                )
                .zIndex(3)
            }
            
            if showCertifyLogAlert {
                ZStack {
                    // Dimmed background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .zIndex(9)
                    
                    // Centered Popup
                    CustomPopupAlert(
                        title: "Certify Log",
                        message: "Please certify your previous day log before going to On-Duty",
                        onOK: {
                            showCertifyLogAlert = false
                            //  navmanager.navigate(to: .logsFlow(.DailyLogs(title: "Today's Logs")))
                        },
                        onCancel: {
                            showCertifyLogAlert = false
                        }
                    )
                    .frame(maxWidth: 350) // optional, to keep consistent width
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .zIndex(10)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showCertifyLogAlert)
                }
                //  Force it to fill the entire screen and center content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .zIndex(10)
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
//                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
//                            UserDefaults.standard.removeObject(forKey: "userEmail")
//                            UserDefaults.standard.removeObject(forKey: "authToken")
//                            UserDefaults.standard.removeObject(forKey: "driverName")
//                            UserDefaults.standard.removeObject(forKey: AppStorageKeys.timezone)
//                            UserDefaults.standard.removeObject(forKey: "timezoneOffSet")
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            ["userEmail","authToken","driverName",AppStorageKeys.timezone,"timezoneOffSet"].forEach(UserDefaults.standard.removeObject)

                            // session.logOut() // Nitin
                            SessionManagerClass.shared.clearToken()
                            appRootManager.currentRoot = .splashScreen
                            
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
                                // navmanager.navigate(to:    AppRoute.vehicleFlow(.NT11Connection))
                            } else if selectedDevice == "PT30" {
                                // navmanager.navigate(to: AppRoute.vehicleFlow(.PT30Connection))
                                
                            }
                        }
                    )
                    .transition(.scale)
                    .zIndex(10)
                }
            }
            
            // Violation dialog
            ForEach(Array(homeVM.violationDataArray.enumerated()), id: \.offset) { index, violationData in
                CommonTimerAlertView(violationData: violationData) {
                    homeVM.violationDataArray.removeLast()
                }
                .zIndex(Double(100+index))
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
        .id(homeVM.refreshView)
        .onChange(of: networkMonitor.isConnected) { newValue in
            if newValue {
                showToast(message: " Internet Connected Successfully", color: .green)
            } else {
                showToast(message: " No Internet Connection", color: .red)
            }
        }
        
        .onAppear {
            // homeVM.startTimer(for: [.onDuty])
          //  loadTodayHOSEvents()
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
            //            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            //                Task {
            //                    await syncVM.syncOfflineData()
            //                }
            //            }
            //            Task {
            //                await syncVM.syncOfflineData()
            //            }
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
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    // Restore timer states when app becomes active
                    homeVM.restoreAllTimersFromLastStatus()
                }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            // Save timer states when app is about to terminate
           // homeVM.saveCurrentTimerStatesBeforeSwitch()
            homeVM.saveTimerStateForStatus(status: homeVM.currentDriverStatus.getName(), note: "")
            
          //  homeVM.restoreAllTimersFromLastStatus()
            //homeVM.addPublishers()
        }
        
        
        .onAppear {
            
            //            if isOnAppearCalled { return }
            //            isOnAppearCalled = true
            //            print(" HomeScreenView onAppear called")
            //            print(" Current status - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
            
            if let driverName = UserDefaults.standard.string(forKey: "driverName"),
               !driverName.isEmpty {
                labelValue = driverName
            }
               //For show restore all timer #priyanshi
                //    if !homeVM.isRestoringTimers {
                        
                //    }
            

        }
        
        
        //            else {
        //                DispatchQueue.main.async {
        //                   // navmanager.navigate(to: AppRoute.loginFlow(.login))
        //                    navmanager.navigate(to: ApplicationRoot.login)
        //                    appRootManager.currentRoot = .login
        //                }
        //                return
        //            }
        //
        //           //  Check if we have any saved timer data
        //            let hasSavedData = !DatabaseManager.shared.fetchLogs().isEmpty
        //                        print(" Has saved data: \(hasSavedData)")
        //
        //            if hasSavedData {
        //                            print(" Found saved data - restoring timers")
        //             //    Delay restoration to ensure UI is ready
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //                    self.restoreAllTimers()
        //                    hasRestoredTimers = true
        //                    print(" Timer restoration completed - confirmedStatus: \(self.confirmedStatus ?? "nil"), selectedStatus: \(self.selectedStatus ?? "nil")")
        //                }
        //            } else {
        //
        //                print(" No saved data - initializing fresh")
        //                if !hasAppearedBefore {
        //                    hasAppearedBefore = true
        //                            }
        //                         //    Always ensure status is set to Off-Duty if no saved data
        //            if confirmedStatus == nil {
        //                selectedStatus = DriverStatusConstants.offDuty
        //                confirmedStatus = DriverStatusConstants.offDuty
        //                                print(" Set status to OffDuty (no saved data)")
        //                            }
        //                        }
        //
        //                       //  Always ensure status is properly set when view appears
        //                        if confirmedStatus == nil {
        //                            selectedStatus = DriverStatusConstants.offDuty
        //                            confirmedStatus = DriverStatusConstants.offDuty
        //                            print("🔧 Set status to OffDuty (fallback)")
        //                        }
        //
        //                        print(" Final status after onAppear - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
        //
        //                      //   Check and reset daily violations
        //                        checkAndResetDailyViolations()
        //
        //            checkFor34HourReset()
        //        }
        
        // nitin
        
        //***************************+++++++++++++++++++++++++++******************************************************************************************************
        // MARK: - OnDuty Timer Violation Logic with Working Time
        
        //        .onChange(of: homeVM.onDutyTimer?.remainingTime) { newValue in
        //
        //        }
        /* // nitin
         
         
         .onReceive(ONDuty.remainingTime) { remainingTime in
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
           */
         */ // nitin
        
        /*
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
         
         
         

         
         
         */
        //MARK: -  #P for refresh All logs popup
      
        .alert("Are you sure you want to refresh all logs?", isPresented: $homeVM.showSyncconfirmation) {
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
                //   navmanager.navigate(to: AppRoute.loginFlow(.login)) }
                appRootManager.currentRoot = .login
            }
            
        } message: {
            Text("Data deleted successfully.")
        }
        //MARK: -  For Deletation Alert
        .alert("Are you sure you want to delete all data?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                Task {
                    if let driverId = DriverInfo.driverId {  //  Get from common storage
                        await deleteViewModel.deleteAllDataOnVersionClick(driverId: driverId)
                        showSuccessAlert = true // Show success after API
                        homeVM.deleteAllAppData()
                        
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
        
        //MARK: - Violation/Warning Alert
        .alert(homeVM.alertTitle, isPresented: $homeVM.showViolationAlert) {
            Button("OK", role: .cancel) {
                homeVM.showViolationAlert = false
            }
        } message: {
            Text(homeVM.alertMessage)
        }
        
        .navigationBarBackButtonHidden()
        .navigationDestination(for: AppRoute.DatabaseFlow.self, destination: { type in
            switch type {
                
            case .ContinueDriveTableView:
                ContinueDriveTableView()
                
            case .DatabaseCertifyView:
                DatabaseCertifyView()
                
            case .DvirDataListView:
                DvirListView()
                
            case  .DriverLogListView:
                DriverLogListView()
                
            }
            
        })
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
        /*
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
         */
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

    
    // MARK: - Check for 10-hour reset (Off-Duty + Sleep)
    
//    func checkFor10HourReset() {
//        //MARK: -  Total Off-Duty + Sleep time
//        let totalRest = offDutySleepAccumulated
//        
//        if totalRest >= 10 * 3600 {
//            print("10-hour reset reached. Resetting all timers except Cycle Timer.")
//            
//            // Stop all timers
//            driveTimer.stop()
//            ONDuty.stop()
//            continueDriveTime.stop()
//            sleepTimer.stop()
//            breakTime.stop()
//            
//            //Reset timers to full time (but DO NOT reset cycleTimerOn)
//            driveTimer.reset(startTime: CountdownTimer.timeStringToSeconds("(11:00:00"))
//            ONDuty.reset(startTime: CountdownTimer.timeStringToSeconds("14:00:00"))
//            continueDriveTime.reset(startTime: CountdownTimer.timeStringToSeconds("08:00:00"))
//            sleepTimer.reset(startTime: CountdownTimer.timeStringToSeconds("10:00:00"))
//            breakTime.reset(startTime: CountdownTimer.timeStringToSeconds("00:30:00"))
//            // Clear accumulated rest time
//            offDutySleepAccumulated = 0
//            // Refresh UI (On-Duty will start again when user selects status)
//            confirmedStatus = DriverStatusConstants.offDuty
//            selectedStatus = DriverStatusConstants.offDuty
//            
//            // Reload Events after reset
//            hoseChartViewModel.forceRefresh()
//            
//            // Save logs in DB for future restore
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let now = formatter.string(from: Date())
//            /*
//             DatabaseManager.shared.saveTimerLog(
//             status: "Reset After 10 Hour Rest",
//             startTime: now, dutyType: "Reset After 10 Hour Rest",
//             remainingWeeklyTime: cycleTimerOn.internalTimeString, // keep same cycle time
//             remainingDriveTime: driveTimer.internalTimeString,
//             remainingDutyTime: ONDuty.internalTimeString,
//             remainingSleepTime: sleepTimer.internalTimeString,
//             lastSleepTime: breakTime.internalTimeString,
//             RemaningRestBreak: "false",
//             isruning: false,
//             isVoilations: false
//             )
//             
//             */
//        }
//        }
        
        
        
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
           //  addViolationBox(text: violation.dutyType)
            
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
        
        
        
        // MARK: - Auto-save timer state (called periodically)
        //  @State private var lastAutoSaveTime: Date = Date()
        
        func autoSaveTimerState() {
            /*
             // Only auto-save every 30 seconds to avoid too frequent database writes
             let now = Date()
             if now.timeIntervalSince(lastAutoSaveTime) >= 30 {
             lastAutoSaveTime = now
             
             guard let currentStatus = confirmedStatus else { return }
             
             print(" Auto-saving timer state for \(currentStatus)")
             
             let formatter = DateFormatter()
             formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
             let nowString = formatter.string(from: now)
             
             
             // Get current timer values
             let dutyTimeString = homeVM.onDutyTimer?.timeString ?? ONDuty.timeString
             let driveTimeString = homeVM.onDriveTimer?.timeString ?? driveTimer.timeString
             let cycleTimeString = homeVM.cycleTimer?.timeString ?? cycleTimerOn.timeString
             let sleepTimeString = homeVM.sleepTimer?.timeString ?? sleepTimer.timeString
             let breakTimeString = homeVM.breakTimer?.timeString ?? breakTime.timeString
             
             // Save to database
             DatabaseManager.shared.saveTimerLog(
             status: currentStatus,
             startTime: nowString,
             dutyType: currentStatus,
             remainingWeeklyTime: cycleTimeString,
             remainingDriveTime: driveTimeString,
             remainingDutyTime: dutyTimeString,
             remainingSleepTime: sleepTimeString,
             lastSleepTime: breakTimeString,
             RemaningRestBreak: "true",
             isruning: true,
             isVoilations: false
             )
             
             print(" Auto-save completed for \(currentStatus)")
             }
             */
        }
        
        //MARK: - Save current timer states
        //    func saveCurrentTimerStates(){
        //    guard let currentStatus = confirmedStatus else {
        //        print(" No confirmed status, cannot save timer states")
        //        return
        //    }
        //
        //    // Prevent auto-save during timer restoration
        //    if isRestoringTimers {
        //        print(" Skipping auto-save during timer restoration")
        //        return
        //    }
        //
        //    print(" Saving timer states for status: \(currentStatus)")
        //    print("Current timer values - Duty: \(onDutyTimer?.timeString ?? ""), Drive: \(onDriveTimer?.timeString ?? ""), Cycle: \(cycleTimer?.timeString ?? "")")
        //    print("Saved timers - OnDuty: \(savedOnDutyRemaining / 60) min, Drive: \(savedDriveRemaining / 60) min, Cycle: \(savedCycleRemaining / 60) min")
        //    // Use saved times if available, otherwise use current times
        //    let dutyTimeToSave = savedOnDutyRemaining != 0 ? savedOnDutyRemaining : (onDutyTimer?.remainingTime ?? 0)
        //    let driveTimeToSave = savedDriveRemaining != 0 ? savedDriveRemaining : (onDriveTimer?.remainingTime ?? 0)
        //    let cycleTimeToSave = savedCycleRemaining != 0 ? savedCycleRemaining : (cycleTimer?.remainingTime ?? 0)
        //
        //    // Use internal strings for storage
        //    let dutyTimeString = onDutyTimer?.internalTimeString ?? "00:00:00"
        //    let driveTimeString = onDriveTimer?.internalTimeString ?? "00:00:00"
        //    let cycleTimeString = cycleTimer?.internalTimeString ?? "00:00:00"
        //    let sleepTimeString = sleepTimer?.timeString ?? "00:00:00"
        //    let breakTimeString = breakTimer?.timeString ?? "00:00:00"
        //
        //    DatabaseManager.shared.saveTimerLog(
        //        status: currentStatus,
        //        startTime: DateTimeHelper.getCurrentDateTimeString(),
        //        dutyType: currentStatus,
        //        remainingWeeklyTime: cycleTimeString,
        //        remainingDriveTime: driveTimeString,
        //        remainingDutyTime: dutyTimeString,
        //        remainingSleepTime: sleepTimeString,
        //        lastSleepTime: breakTimeString,
        //        RemaningRestBreak: "true",
        //        isruning: true,
        //        isVoilations: false
        //    )
        //    print(" Timer states saved successfully at \(DateTimeHelper.getCurrentDateTimeString())")
        //    print("Times saved - OnDuty: \(dutyTimeString), Drive: \(driveTimeString), Cycle: \(cycleTimeString)")
        //}
        
        
        
        
        
        
        // MARK: - Delete All App Data
        //    func deleteAllAppData()
        
        
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
        
        
        //    func checkAndStartCycleTimer() {
        //        print(" Checking Cycle Timer: Drive=\(isDriveActive), Duty=\(isOnDutyActive)")
        //
        //        if isOnDutyActive {
        //            startCycleTimer()
        //        }else if   isDriveActive {
        //            startCycleTimer()
        //        }
        //        else {
        //            stopCycleTimer()
        //        }
        //    }
        
        //    func startCycleTimer() {
        //        guard !isCycleTimerActive else { return }
        //        print(" Starting Cycle Timer")
        //        isCycleTimerActive = true
        //            cycleTimerOn.start()          //MARK: - this is the CountdownTimer you passed to AvailableHoursView
        //
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        let now = formatter.string(from: Date())
        //
        //        DatabaseManager.shared.saveTimerLog(
        //            status: "Cycle",
        //            startTime: now, dutyType: "Cycle",
        //            remainingWeeklyTime: cycleTimerOn.internalTimeString,
        //            remainingDriveTime: driveTimer.internalTimeString,
        //            remainingDutyTime: ONDuty.internalTimeString,
        //            remainingSleepTime: sleepTimer.internalTimeString,
        //            lastSleepTime: "", RemaningRestBreak: breakTime.internalTimeString, isruning: false,
        //        )
        //
        //            print(" Saved Cycle timer to DB at \(now)")
        //    }
        
        //    func stopCycleTimer() {
        //        guard isCycleTimerActive else { return }
        //        isCycleTimerActive = false
        //        cycleTimerOn.stop() //  stop your cycle countdown
        //        print(" Cycle Timer Stopped")
        //    }
        
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
            /*
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
             */
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
            
            homeVM.violationBoxes.removeAll()
            
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
                    timestamp: log.startTime.asDate() ?? Date(),
                    type: .violation // Database violations are always violations, not warnings
                )
                
                homeVM.violationBoxes.append(violationData)
            }
            
            if !homeVM.violationBoxes.isEmpty {
                homeVM.showViolationBoxes = true
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
            print(" Stopping all timers for Personal Use")
            
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
            /*
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
             */
            print(" Violation saved to database successfully")
        }
        
    }




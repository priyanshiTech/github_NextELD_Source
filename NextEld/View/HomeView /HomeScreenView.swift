//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 07/05/25.
//
//
import SwiftUI
import Combine


// MARK: - Main View
struct HomeScreenView: View {
    
    @EnvironmentObject var appRootManager: AppRootManager
    @StateObject private var homeVM : HomeViewModel = .init()
    @StateObject var trailerVM: TrailerViewModel = .init()
    @StateObject private var driverWorkviewModel = DriverWorkingViewModel()

    @State private var labelValue = ""
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
    @State private var timer: Timer? = nil
    @State private var driverWorkingTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var showPendingSyncPopup = false
    @State private var isManualSyncInProgress = false
    @State private var syncPopupContext: SyncPopupContext? = nil
    @State private var showLogoutStatusAlert = false
  
    //MARK: - Daily violation tracking
    @EnvironmentObject var navManager: NavigationManager

    //MARK: -  Show Alert Drive Before 30 min / 15 MIn
    @StateObject private var viewModel = RefreshViewModel()
    @StateObject private var syncVM = SyncViewModel()
    // ELD Additions
    @AppStorage("cycleType") var cycleType: String = "8/70" // or "7/60"
    @State private var pastDutyLog: [Date: TimeInterval] = [:] // key = date, value = seconds
    @State private var offDutyStartTime: Date? = nil
    //MARK: -  SHOw Slep Timer Popup
    
    //MARK: -  Network
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showBanner: Bool = false
    @State private var bannerMessage: String = ""
    @State private var bannerColor: Color = .green
    
    //MARK: -  For Delete API's
    @State private var showDeleteConfirm = false
    @StateObject private var deleteViewModel = DeleteViewModel()

    @StateObject private var logoutVM = APILogoutViewModel()   //logout
    @EnvironmentObject var locationManager: LocationManager
    let times = DateTimeHelperVoilation.getLocalAndGMT()
    
    @State private var showDvirPopup = false
    @State  var showAddDvirPopup = false
    
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
                        Text(SharedInfoManager.shared.isDeviceConnected ? "Connected": "Disconnected")
                            .font(.title2)
                            .foregroundColor(SharedInfoManager.shared.isDeviceConnected ? .green : .red)
                        //UserDefaults.standard.string(forKey: "truckNo"),
                        VehicleInfoView(
                            GadiNo: AppStorageHandler.shared.vehicleNo ?? "Not Found",
                            trailer: trailerVM.getTrailerValue()
                        )
                        StatusView(homeViewModel: homeVM) {  status in
                            guard status != homeVM.currentDriverStatus else { return }
                            if homeVM.check34HoursSleepOrOffDutyCompleted() && status != .offDuty && status != .sleep {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    homeVM.alertType = .thirtyFourHours
                                    homeVM.showAlertOnHomeScreen = true
                                }
                            }
                            
                            else {
                                
                                if (status == .onDuty || status == .onDrive),
                                   homeVM.checkWhetherTheLogCertifyOrNot(status: status).havingCertifyLog {
                                    
                                    // CONDITION 1: Current date uncertified → NO CERTIFY POPUP, show normal status alert
                                    if homeVM.hasUncertifiedLogForToday() {
                                        homeVM.showDriverStatusAlert = (true, status)
                                        return
                                    }
                                    
                                    // CONDITION 2: Previous dates uncertified → SHOW CERTIFY POPUP
                                    if homeVM.hasUncertifiedLogForPreviousDates() {
                                        showCertifyLogAlert = true
                                        return
                                    }
                                    
                                    //  DVIR logic ONLY when status == .onDrive
                                    if status == .onDrive {
                                        if homeVM.checkWhetherTheDVIRAddedOrNot(status: status) {
                                            if homeVM.checkWhetherDVIRLastRecordIsInToday(status: status) {
                                                showAddDvirPopup = true
                                            } else {
                                                homeVM.showDriverStatusAlert = (true, status)
                                            }
                                        } else {
                                            showDvirPopup = true
                                        }
                                    } else {
                                        homeVM.showDriverStatusAlert = (true, status)
                                    }
                                } else {
                                    homeVM.showDriverStatusAlert = (true, status)
                                }

                                }



                           /* else {
                             
                               
                                if (status == .onDuty || status == .onDrive), homeVM.checkWhetherTheLogCertifyOrNot(status: status).havingCertifyLog {
                               
                                    if homeVM.checkWhetherTheLogCertifyOrNot(status: status).isAllLogCerify {
                                        if status == .onDrive || status == .onDuty {
                                             if homeVM.hasUncertifiedLogForToday() {
                                                 homeVM.showDriverStatusAlert = (true, status)
                                                 return
                                             }
                                         }
                                        
                                        if homeVM.checkWhetherTheDVIRAddedOrNot(status: status) {
                                            if homeVM.checkWhetherDVIRLastRecordIsInToday(status: status) {
                                                homeVM.showDriverStatusAlert = (true, status)
                                            } else {
                                                showAddDvirPopup = true
                                            }
                                        } else {
                                            showDvirPopup = true
                                        }
                                    } else {
                                       showCertifyLogAlert = true
                                    }
                                } else {
                                    homeVM.showDriverStatusAlert = (true, status)
                                }
                                
                            }*/
                        }
                        AvailableHoursView(homeViewModel: homeVM)
                        HOSEventsChartScreen(events: homeVM.graphEvents)
                        //MARK: - Violation Boxes (Part of Main Scroll) - Removed, now using alerts
                        
                        VStack(alignment: .leading) {
                            Text("Version - OS/02/May")
                        }
                    }
                }
                .scrollIndicators(.hidden)
              .scrollIndicators(.hidden)
            }
            .disabled(presentSideMenu || showLogoutPopup || ShowrefreshPopup )
            
            if presentSideMenu {
                Color(uiColor:.black).opacity(0.3)
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
                    showDeleteConfirm: $showDeleteConfirm,
                    showSyncConfirmation:  $homeVM.showSyncconfirmation,
                    onLogoutRequested: handleLogoutRequest
                )
                .frame(width: 250)
                .background(Color(uiColor:.white))
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
            
            // Showing Driver Status Alerts
            if homeVM.showDriverStatusAlert.showAlert {
                // Popup content
                StatusDetailsPopup(
                    statusTitle: homeVM.showDriverStatusAlert.status.getName(),
                    onClose: {
                        homeVM.showDriverStatusAlert.showAlert = false
                    },
                    onSubmit: { note in
                        let status = homeVM.showDriverStatusAlert.status
                        // Set new status and start timers
                       homeVM.setDriverStatus(status: status, note: note, saveLogsToDatabase: true)
                        // Close the popup after submit
                        homeVM.showDriverStatusAlert.showAlert = false
                    }
                )
            }
            //nitin
            
            if showAddDvirPopup {
                
                AddDvirPopup(isPresented: $showAddDvirPopup)
                
                    .frame(maxWidth: 350) // optional, to keep consistent width
                        .padding(.horizontal, 20)
                        .cornerRadius(16)
                        .zIndex(10)
                        .animation(.easeInOut, value: showCertifyLogAlert)// ensures it's above everything
                }
            //MARK: -  Show Certify popup
            
            if showDvirPopup {
                CustomPopupAlert(
                    title: "Add DVIR Log",
                    message: "Please add DVIR before going to On-Drive",
                    onOK: {
                        navManager.path.append(AppRoute.DatabaseFlow.AddDvirScreenView)
                        showDvirPopup = false
                    },
                    onCancel: { showDvirPopup = false }
                )
                .zIndex(3)
                .frame(maxWidth: 350) // optional, to keep consistent width
                .padding(.horizontal, 20)
                .cornerRadius(16)
                .shadow(radius: 10)
                .zIndex(10)
                .transition(.opacity)
                .animation(.easeInOut, value: showDvirPopup)
            }
            
            if showCertifyLogAlert {
                ZStack {
                    // Dimmed background
                    Color(uiColor:.black).opacity(0.4)
                        .ignoresSafeArea()
                        .zIndex(9)
                    
                    // Centered Popup
                    CustomPopupAlert(
                        title: "Certify Log",
                        message: "Please certify your previous day log before going to On-Duty",
                        onOK: {
                            showCertifyLogAlert = false
                            navManager.navigate(to: AppRoute.HomeFlow.DailyLogs(tittle: "Daily Logs"))
                        },
                        onCancel: {
                            showCertifyLogAlert = false
                        }
                    )
                    .frame(maxWidth: 350) // optional, to keep consistent width
                    .padding(.horizontal, 20)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .zIndex(10)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showCertifyLogAlert)
                }
            }
            
            if showPendingSyncPopup {
                ZStack {
                    Color(uiColor:.black).opacity(0.4)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                    
                    CustomPopupAlert(
                        
                        title: "Refresh Log",
                        message: "You have some records to update, do you want to update?",
                    onOK: { handleSyncPopupConfirmation() },
                        onCancel: {
                            isManualSyncInProgress = false
                        syncPopupContext = nil
                            showPendingSyncPopup = false
                        },
                        okTitle: isManualSyncInProgress ? "Syncing..." : "OK",
                        cancelTitle: "Cancel",
                        isLoading: isManualSyncInProgress,
                        okButtonDisabled: isManualSyncInProgress
                    
                    )
                    .padding(.horizontal, 24)
                    .frame(maxWidth: 340)
                    .zIndex(1)
                }
                .zIndex(11)
                .transition(.opacity)
                .animation(.easeInOut, value: showPendingSyncPopup)
            }
            
            if showLogoutPopup {
                Color(uiColor:.black).opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(2)
                
                PopupContainer(isPresented: $showLogoutPopup) {
                    LogOutPopup(
                        isCycleCompleted: $isCycleCompleted,
                        currentStatus: DriverStatusConstants.offDuty,
                        onLogout: {
                            Task {
                                let success = await logoutVM.callLogoutAPI()
                                if logoutVM.isSessionExpired {
                                    print(" Session expired detected during logout - staying on SessionExpireUIView")
                                    return
                                }
                                if success {
                                    showLogoutPopup = false
                                    presentSideMenu = false
                                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                    ["userEmail","authToken","driverName","\(AppStorageHandler.shared.timeZone)","timezoneOffSet"].forEach(UserDefaults.standard.removeObject)
                                    SessionManagerClass.shared.clearToken()
                                    appRootManager.currentRoot = .splashScreen
                                } else if !logoutVM.apiMessage.isEmpty {
                                    print(" Logout API message: \(logoutVM.apiMessage)")
                                }
                            }
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
                    Color(uiColor:.black).opacity(0.4)
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
                                navManager.navigate(to: AppRoute.BluetoothDeviceFlow.NT11Connection)
                            } else if selectedDevice == "PT30" {
                                navManager.navigate(to: AppRoute.BluetoothDeviceFlow.PT30Connection)
                                
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
                    if !homeVM.violationDataArray.isEmpty {
                        homeVM.violationDataArray.removeLast()
                    }
                }
//                .onAppear(perform: {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                        homeVM.violationDataArray.removeAll { element in
//                            return element.id == violationData.id
//                        }
//                    }
//                })
                
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
        .onChange(of: homeVM.showBlockScreen) { shouldBlock in
            if shouldBlock {
                // Navigate to BlockView when screen should be blocked
                navManager.navigate(to: AppRoute.HomeFlow.BlockView)
            } else {
                // Pop navigation when screen is unblocked
                if !navManager.path.isEmpty {
                    navManager.path.removeLast()
                }
            }
        }
        
        // Set alert type when sync confirmation is triggered
        .onChange(of: homeVM.showSyncconfirmation) { newValue in
            guard newValue else { return }
            homeVM.showSyncconfirmation = false
            if hasPendingUnsyncedLogs() {
                syncPopupContext = .manualRefresh
                showPendingSyncPopup = true
            } else {
                scheduleRefreshAlert()
            }
        }
        
        // Set alert type when delete confirmation is triggered
        .onChange(of: showDeleteConfirm) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    homeVM.alertType = .deleteLogs
                    homeVM.showAlertOnHomeScreen = true
                    showDeleteConfirm = false
                }
            }
        }
        
       // .onAppear {
            // homeVM.startTimer(for: [.onDuty])
          //  loadTodayHOSEvents()
      //  }
        //(_)(+)_(_+(_+(_+)()_(+)_
        
        ZStack(alignment: .top) {
            
            if !syncVM.syncMessage.isEmpty {
                Text(syncVM.syncMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(uiColor:.black))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color(uiColor:.black).opacity(0.15), radius: 8, x: 0, y: 4)
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                    .transition(.opacity.combined(with: .scale))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            syncVM.syncMessage = ""
                        }
                    }
            }
        }
        //MARK: -  call sync API In every 10 sec
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
//                    // Save timer states when app goes to background
//                    saveCurrentTimerStatesBeforeSwitch()
//                    saveCurrentTimerStates()
//                }
        
                 .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    homeVM.restoreAllTimersFromLastStatus()
                }
        
                 .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                  homeVM.saveTimerStateForStatus(status: homeVM.currentDriverStatus.getName(), originType: .driver, note: "")
                     
                  }
        
        .onReceive(driverWorkingTimer) { _ in
            updateDriverWorkingPayload()
            Task {
                await driverWorkviewModel.driverWorkingTiming()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshStarted)) { _ in
            withAnimation {
                syncVM.syncMessage = "Fetching records..."
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshCompleted)) { notification in
            guard let userInfo = notification.userInfo,
                  let status = userInfo["status"] as? String,
                  let message = userInfo["message"] as? String else { return }
            withAnimation {
                if status == "success" {
                    let finalMessage = message.isEmpty ? "Data refreshed successfully." : message
                    syncVM.syncMessage = finalMessage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            syncVM.syncMessage = ""
                        }
                        DispatchQueue.main.async {
                            appRootManager.currentRoot = .splashScreen
                        }
                    }
                } else {
                    let errorMessage = message.isEmpty ? "Refresh failed." : "Refresh failed: \(message)"
                    syncVM.syncMessage = errorMessage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            syncVM.syncMessage = ""
                        }
                    }
                }
            }
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
            driverWorkviewModel.appRootManager = appRootManager
            updateDriverWorkingPayload()
            Task {
                await driverWorkviewModel.driverWorkingTiming()
            }
               //For show restore all timer #priyanshi
                //    if !homeVM.isRestoringTimers {
                        
                //    }
            

        }
        

        //MARK: -  #P for refresh All logs popup
        .alert(homeVM.alertType.getTitle(), isPresented: $homeVM.showAlertOnHomeScreen) {
        Button("Cancel", role: .cancel) {
            homeVM.showAlertOnHomeScreen = false
            // Reset flag so alert can show again if needed
            
        }
        Button("OK", role: .destructive) {
            homeVM.showAlertOnHomeScreen = false
            switch homeVM.alertType {
            
            case .nextDay:
                print("Resetting all timers for new day...")
               // homeVM.resetToInitialState()
            case .refresh:
                //MARK: -  Call refresh API
                Task {
                    await viewModel.refresh()
                }
            case .deleteLogs:
                
                Task {
                    if let driverId = AppStorageHandler.shared.driverId {
                        let success = await deleteViewModel.deleteAllDataOnVersionClick(driverId: driverId)
                        if deleteViewModel.isSessionExpired {
                            print(" Session expired detected during delete - staying on SessionExpireUIView")
                            return
                        }
                        if success {
                            homeVM.deleteAllAppData()
                            ContinueDriveDBManager.shared.deleteAllContinueDriveData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.homeVM.alertType = .sucessConfimration
                                self.homeVM.showAlertOnHomeScreen = true
                            }
                        } else if !deleteViewModel.apiMessage.isEmpty {
                            print(" Delete API message: \(deleteViewModel.apiMessage)")
                        }
                    } else{
                        print(" Driver ID not found in UserDefaults")
                    }
                }
                break
            case .sucessConfimration:
                appRootManager.currentRoot = .login
                break
            case .shiftChange:
                break
            case .thirtyFourHours:
                break
            case .splitShiftEnds:
                AppStorageHandler.shared.splitShiftIdentifier = 0
                break
            case .idleState:
                break
            }
        }
            
        } message: {

            Text(homeVM.alertType.getMessage())
        }
        .alert("Switch to Off Duty", isPresented: $showLogoutStatusAlert) {
            Button("OK", role: .cancel) {
                showLogoutStatusAlert = false
            }
        } message: {
            Text("Please change your duty status to Off Duty before logging out.")
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
                
            case .AddDvirScreenView:
                AddDvirScreenView( selectedRecord:.constant(nil), trailers: $trailerVM.trailers )
            case .EyeViewData( let tittle, let entry):
                EyeViewData(title:tittle , entry: entry)
            }
            
        })
        .navigationDestination(for: AppRoute.BluetoothDeviceFlow.self) { route in
            switch route {
            case .NT11Connection:
                NT11ConnectionView()
            case .PT30Connection:
                PT30ConnectionView()
                    
            }
        }
        .navigationDestination(for: AppRoute.HomeFlow.self) { route in
            switch route {
            case .BlockView:
                BlockAppView(homeViewModel: homeVM)
            default:
                EmptyView()
            }
        }
    }
    
    private func updateDriverWorkingPayload() {
        driverWorkviewModel.status = homeVM.currentDriverStatus.getName()
        driverWorkviewModel.onDutyTime = formattedTime(from: homeVM.onDutyTimer, fallbackSeconds: AppStorageHandler.shared.onDutyTime)
        driverWorkviewModel.onDriveTime = formattedTime(from: homeVM.onDriveTimer, fallbackSeconds: AppStorageHandler.shared.onDriveTime)
        driverWorkviewModel.onSleepTime = formattedTime(from: homeVM.sleepTimer, fallbackSeconds: AppStorageHandler.shared.onSleepTime)
        let cycleFallback = AppStorageHandler.shared.cycleTime.map { Double($0) }
        driverWorkviewModel.weeklyTime = formattedTime(from: homeVM.cycleTimer, fallbackSeconds: cycleFallback)
        let breakFallback = AppStorageHandler.shared.breakTime.map { Double($0) }
        driverWorkviewModel.onBreak = formattedTime(from: homeVM.breakTimer, fallbackSeconds: breakFallback)
    }
    
    private func formattedTime(from timer: CountdownTimer?, fallbackSeconds: Double? = nil) -> String {
        if let timer {
            return timer.remainingTime.timeString
        }
        if let fallbackSeconds {
            return fallbackSeconds.timeString
        }
        return "00:00:00"
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

    }




extension HomeScreenView {
    private func hasPendingUnsyncedLogs() -> Bool {
        !DatabaseManager.shared.fetchLogs(filterTypes: [.notSync]).isEmpty
    }
    
    private func handleLogoutRequest() {
        presentSideMenu = false
        guard homeVM.currentDriverStatus == .offDuty else {
            showLogoutStatusAlert = true
            return
        }
     //   if hasPendingUnsyncedLogs() {   // temperory off
          //  syncPopupContext = .logout
          //  showPendingSyncPopup = true
        //} else {
            showLogoutPopup = true
        //}
    }
    
    private func scheduleRefreshAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            homeVM.alertType = .refresh
            homeVM.showAlertOnHomeScreen = true
        }
    }
    
    private func handleSyncPopupConfirmation() {
        guard !isManualSyncInProgress else { return }
        guard let context = syncPopupContext else { return }
        isManualSyncInProgress = true
        Task { @MainActor in
            var syncSucceeded = false
            while syncPopupContext == context && !syncSucceeded {
                await homeVM.syncViewModel.getLocation()
                syncSucceeded = await homeVM.syncViewModel.syncOfflineData()
                if !syncSucceeded {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                }
            }
            
            guard syncPopupContext == context, syncSucceeded else {
                isManualSyncInProgress = false
                return
            }
            
            isManualSyncInProgress = false
            showPendingSyncPopup = false
            syncPopupContext = nil
            
            let pendingLogsRemain = hasPendingUnsyncedLogs()
            
            switch context {
            case .manualRefresh:
                scheduleRefreshAlert()
            case .logout:
                if pendingLogsRemain {
                    syncPopupContext = .logout
                    showPendingSyncPopup = true
                } else {
                    if homeVM.currentDriverStatus == .offDuty {
                        showLogoutPopup = true
                    } else {
                        showLogoutStatusAlert = true
                    }
                }
            }
        }
    }
}

private enum SyncPopupContext {
    case manualRefresh
    case logout
}

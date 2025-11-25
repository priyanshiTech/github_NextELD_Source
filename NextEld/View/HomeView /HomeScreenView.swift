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
  
    //MARK: - Daily violation tracking
    /*
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
    */
    
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
                        //UserDefaults.standard.string(forKey: "truckNo"),
                        VehicleInfoView(
                            GadiNo: AppStorageHandler.shared.vehicleNo ?? "Not Found",
                            trailer: trailerVM.getTrailerValue()
                        )
                            StatusView(homeViewModel: homeVM) {  status in
                                if homeVM.check34HoursSleepOrOffDutyCompleted() && status != .offDuty && status != .sleep {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        homeVM.alertType = .thirtyFourHours
                                        homeVM.showAlertOnHomeScreen = true
                                    }
                                    
                                } else {
                                    homeVM.showDriverStatusAlert = (true, status)
                                }
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
                    showLogoutPopup: $showLogoutPopup,
                    showDeleteConfirm: $showDeleteConfirm, showSyncConfirmation:  $homeVM.showSyncconfirmation,
                    
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
                    onClose: { homeVM.showDriverStatusAlert.showAlert = false },
                    onSubmit: { note in
                        let status = homeVM.showDriverStatusAlert.status
                        
                        // Set new status and start timers
                       homeVM.setDriverStatus(status: status, note: note, saveLogsToDatabase: true)
                    
                        // Close the popup after submit
                        homeVM.showDriverStatusAlert.showAlert = false
                    },
                    DVClocationManager: deviceLocationManager
                )
            }
            //nitin
            
            if homeVM.showAddDvirPopup {
                
                AddDvirPopup(isPresented: $homeVM.showAddDvirPopup)
                
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
                        navManager.navigate(to: AppRoute.HomeFlow.DailyLogs(tittle: "Daily Log"))
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
        
        // Set alert type when sync confirmation is triggered
        .onChange(of: homeVM.showSyncconfirmation) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    homeVM.alertType = .refresh
                    homeVM.showAlertOnHomeScreen = true
                    homeVM.showSyncconfirmation = false
                }
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
                    // Restore timer states when app becomes active
                    homeVM.restoreAllTimersFromLastStatus()
                }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            // Save timer states when app is about to terminate
           // homeVM.saveCurrentTimerStatesBeforeSwitch()
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
            }
        }
            
        } message: {

            Text(homeVM.alertType.getMessage())
        }
      
        //MARK: -  Sync/Refresh Confirmation Alert
//        .alert("Are you sure you want to refresh all logs?", isPresented: $homeVM.showSyncconfirmation) {
//            Button("Cancel", role: .cancel) {
//                homeVM.showSyncconfirmation = false
//            }
//            Button("OK", role: .destructive) {
//                homeVM.showSyncconfirmation = false
//                // Call refresh API directly
//                Task { @MainActor in
//                    await viewModel.refresh()
//                    print(" Refresh API call completed")
//                }
//            }
//        } message: {
//            Text("This will refresh all your local logs with the server.")
//        }
        
        
        //MARK: -   Success alert after deletion
//        .alert("Success", isPresented: $showSuccessAlert) {
//            Button("OK", role: .cancel) {
//                appRootManager.currentRoot = .login
//            }
//        } message: {
//            Text("Data deleted successfully.")
//        }
//        
        //MARK: -  For Deletation Alert  
//        .alert(homeVM.alertType.getTitle(), isPresented: $showDeleteConfirm) {
//            Button("Delete", role: .destructive) {
//                showDeleteConfirm = false
//                Task {
//                    if let driverId = AppStorageHandler.shared.driverId {
//                        await deleteViewModel.deleteAllDataOnVersionClick(driverId: driverId)
//                        homeVM.deleteAllAppData()
//                        
//                        // Delete all Continue Drive data
//                        ContinueDriveDBManager.shared.deleteAllContinueDriveData()
//                        
//                        // Show success alert
//                        showSuccessAlert = true
//                    } else {
//                        print(" Driver ID not found in UserDefaults")
//                    }
//                }
//            }
//            Button("Cancel", role: .cancel) {
//                showDeleteConfirm = false
//            }
//        }
//        message: {
//            Text(homeVM.alertType.getMessage())
//        }

        
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
    
    
//    private func loadTodayHOSEvents() {
//        let todayLogs = DatabaseManager.shared.fetchDutyEventsForToday()
//        print(" Logs fetched from DB: \(todayLogs.count)")
//        for log in todayLogs {
//            print("→ \(log.status) from \(log.startTime) to \(log.endTime)")
//        }
//        let converted = todayLogs.enumerated().compactMap { index, log -> HOSEvent? in
//            HOSEvent(
//                id: index,
//                x: log.startTime,
//                event_end_time: log.endTime,
//                dutyType: log.status
//            )
//        }
//        hoseEvents = converted
//    }

    
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
//        func checkAndShowViolationsForCurrentDayShift(day: Int, shift: Int) {
//            
//            let allLogs = DatabaseManager.shared.fetchLogs()
//            
//            // Filter violations for current day and shift
//            let currentDayShiftViolations = allLogs.filter { log in
//                log.isVoilations == 1 &&
//                log.status == "Violation" &&
//                log.day == day &&
//                log.shift == shift
//            }
//            
//            // Check if we've already shown violations for this day/shift
//            let shownViolationsKey = "shownViolations_\(day)_\(shift)"
//            let hasShownViolations = UserDefaults.standard.bool(forKey: shownViolationsKey)
//
//            if !currentDayShiftViolations.isEmpty && !hasShownViolations {
//                print(" Found \(currentDayShiftViolations.count) violations for day \(day), shift \(shift)")
//                
//                // Show the most recent violation
//                if let latestViolation = currentDayShiftViolations.last {
//                    showViolationAlert(violation: latestViolation)
//                    
//                    // Mark as shown for this day/shift
//                    UserDefaults.standard.set(true, forKey: shownViolationsKey)
//                    print(" Marked violations as shown for day \(day), shift \(shift)")
//                }
//            } else if hasShownViolations {
//                print(" Violations already shown for day \(day), shift \(shift) - skipping")
//            }
//        }
        
//        func showViolationAlert(violation: DriverLogModel) {
//            activeTimerAlert = TimerAlert(
//                title: "Violation Detected",
//                message: violation.dutyType,
//                backgroundColor: .red.opacity(0.9),
//                isViolation: true
//            )
//            
//            // Add to violation boxes
//           //  addViolationBox(text: violation.dutyType)
//            
//            print(" Showing violation alert: \(violation.dutyType)")
//        }
        
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
        
/*
        //MARK: - Reset Timers for Next Day
        func resetTimersForNextDay() selectedStatus
  */
        //MARK: - Calculate OffDuty and Sleep Time from Database
//        func calculateOffDutyAndSleepTime() -> (offDuty: TimeInterval, sleep: TimeInterval) {
//            let allLogs = DatabaseManager.shared.fetchLogs()
//            
//            guard !allLogs.isEmpty else {
//                print(" No logs found in database")
//                return (0, 0)
//            }
//            
//            // Sort logs by timestamp
//            let sortedLogs = allLogs.sorted { $0.timestamp < $1.timestamp }
//            
//            var totalOffDuty: TimeInterval = 0
//            var totalSleep: TimeInterval = 0
//            let currentTime = Date()
//            
//            print(" Processing \(sortedLogs.count) logs for time calculation")
//            
//            for (index, log) in sortedLogs.enumerated() {
//                let startTime = log.startTime ?? Date()
//                let endTime: Date
//                
//                // If this is the last log, use current time
//                if index == sortedLogs.count - 1 {
//                    endTime = currentTime
//                } else {
//                    // Use the start time of the next log as end time
//                    endTime = sortedLogs[index + 1].startTime ?? Date()
//                }
//                
//                let duration = endTime.timeIntervalSince(startTime)
//                
//                switch log.status {
//                    
//                case "OffDuty":
//                    totalOffDuty += duration
//                    print(" OffDuty: \(String(describing: log.startTime)) for \(duration/3600) hours")
//                    
//                case "OnSleep":
//                    totalSleep += duration
//                    print(" OnSleep: \(String(describing: log.startTime)) for \(duration/3600) hours")
//                    
//                default:
//                    break
//                }
//            }
//            
//            print("Total calculated - OffDuty: \(totalOffDuty/3600)h, Sleep: \(totalSleep/3600)h")
//            return (totalOffDuty, totalSleep)
//        }
        
        
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
        
        /*
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
        
    */
        
        // MARK: - Start OnDuty and Cycle Timers for Yard Move
//        func startYardMoveTimers() {
//            print(" Starting OnDuty and Cycle timers for Yard Move")
//            
//            // Start OnDuty timer
//            if !isOnDutyActive {
//                ONDuty.start()
//                isOnDutyActive = true
//                print(" OnDuty timer started for Yard Move")
//            }
//            
//            // Start Cycle timer
//            if !isCycleTimerActive {
//                cycleTimerOn.start()
//                isCycleTimerActive = true
//                print(" Cycle timer started for Yard Move")
//            }
//            
//            // Stop other timers that shouldn't run during Yard Move
//            if isDriveActive {
//                driveTimer.stop()
//                isDriveActive = false
//                print(" Drive timer stopped for Yard Move")
//            }
//            
//            if isSleepTimerActive {
//                sleepTimer.stop()
//                isSleepTimerActive = false
//                print(" Sleep timer stopped for Yard Move")
//            }
//            
//            print(" Yard Move timers configured")
//        }
//        
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




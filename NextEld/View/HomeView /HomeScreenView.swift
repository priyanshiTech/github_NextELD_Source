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
    @EnvironmentObject var navManager: NavigationManager
    @StateObject private var viewModel = RefreshViewModel()
    

    @State private var labelValue = ""
    @State private var showCertifyLogAlert = false
    @State private var showStatusalert: Bool = false
    @State private var ShowrefreshPopup: Bool = false
    @State private var isCycleCompleted: Bool = false
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
    

    //MARK: -  Show Alert Drive Before 30 min / 15 MIn
   
    
    // ELD Additions
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
                        presentSideMenu: $homeVM.presentSideMenu,
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
                            } else {
                                if (status == .onDuty || status == .onDrive) {
                                    if homeVM.checkWhetherTheLogCertifyOrNot(status: status) {
                                        if status == .onDrive {
                                            if homeVM.checkWhetherTheDVIRAddedOrNot(status: status) {
                                                homeVM.showDriverStatusAlert = (true, status)
                                            } else if homeVM.checkWetherLastRecordExistInDVIRTable(status: status) {
                                                showAddDvirPopup = true
                                            } else {
                                                showDvirPopup = true
                                            }
                                        } else {
                                            homeVM.showDriverStatusAlert = (true, status)
                                        }
                                    } else {
                                       showCertifyLogAlert = true
                                    }
                                } else {
                                    homeVM.showDriverStatusAlert = (true, status)
                                }
                                
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
            .disabled(homeVM.presentSideMenu || homeVM.showLogoutPopup || ShowrefreshPopup )
            
            if homeVM.presentSideMenu {
                Color(uiColor:.black).opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            homeVM.presentSideMenu = false
                        }
                    }
                    .zIndex(1)
                
                SideMenuView(
                    selectedSideMenuTab: $selectedSideMenuTab,
                    presentSideMenu: $homeVM.presentSideMenu,
                    showDeleteConfirm: $showDeleteConfirm,
                    showSyncConfirmation:  $homeVM.showSyncconfirmation,
                    onLogoutRequested: homeVM.handleLogoutRequest
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
                        navManager.path.append(AppRoute.HomeFlow.AddDvirScreenView(vm: trailerVM, selectedRecord: nil))
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
                        onOK: {    DatabaseManager.shared.deleteAllLogs() // Clears driverLogs and splitShiftTable
                            ContinueDriveDBManager.shared.deleteAllContinueDriveData()
                            DvirDatabaseManager.shared.deleteAllRecordsForDvirDataBase()
                            CertifyDatabaseManager.shared.deleteAllCertifyRecords()
                            homeVM.handleSyncPopupConfirmation() },
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
            
            if homeVM.showLogoutPopup {
                Color(uiColor:.black).opacity(0.5)
                    .ignoresSafeArea()
                    .zIndex(2)
                
                PopupContainer(isPresented: $homeVM.showLogoutPopup) {
                    LogOutPopup(
                        isCycleCompleted: $isCycleCompleted,
                        currentStatus: homeVM.currentDriverStatus.getName(),
                        onLogout: {
                            homeVM.handleLogoutButtonTapped { success in
                                if success {
                                    // Move to login button
                                    appRootManager.currentRoot = .login
                                }
                            }
                        },
                        onCancel: {
                            homeVM.showLogoutPopup = false
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
                                navManager.navigate(to: AppRoute.HomeFlow.NT11Connection)
                            } else if selectedDevice == "PT30" {
                                navManager.navigate(to: AppRoute.HomeFlow.PT30Connection)
                                
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
            
            if homeVM.displayLoader {
                VStack {
                    ProgressView()
                        .scaleEffect(2)
                        .padding(20)
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                }
            }
        }
        .allowsHitTesting(!homeVM.displayLoader)
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
                navManager.navigate(to: AppRoute.HomeFlow.BlockView(homeVM: homeVM))
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
//            homeVM.showSyncconfirmation = false
//            if hasPendingUnsyncedLogs() {
//                syncPopupContext = .manualRefresh
//                showPendingSyncPopup = true
//            } else {
//                scheduleRefreshAlert()
//            }
                homeVM.handleSyncPopupConfirmation()
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
        
     
        ZStack(alignment: .top) {
            
            if !homeVM.syncViewModel.syncMessage.isEmpty {
                Text(homeVM.syncViewModel.syncMessage)
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
                            homeVM.syncViewModel.syncMessage = ""
                        }
                    }
            }
        }
        
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
                homeVM.syncViewModel.syncMessage = "Fetching records..."
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshCompleted)) { notification in
            guard let userInfo = notification.userInfo,
                  let status = userInfo["status"] as? String,
                  let message = userInfo["message"] as? String else { return }
            withAnimation {
                if status == "success" {
                    let finalMessage = message.isEmpty ? "Data refreshed successfully." : message
                    homeVM.syncViewModel.syncMessage = finalMessage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            homeVM.syncViewModel.syncMessage = ""
                        }
                        DispatchQueue.main.async {
                            appRootManager.currentRoot = .splashScreen
                        }
                    }
                } else {
                    let errorMessage = message.isEmpty ? "Refresh failed." : "Refresh failed: \(message)"
                    homeVM.syncViewModel.syncMessage = errorMessage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            homeVM.syncViewModel.syncMessage = ""
                        }
                    }
                }
            }
        }
        
        
        .onAppear {
            if let driverName = UserDefaults.standard.string(forKey: "driverName"),
               !driverName.isEmpty {
                labelValue = driverName
            }
            driverWorkviewModel.appRootManager = appRootManager
            updateDriverWorkingPayload()
            Task {
                await driverWorkviewModel.driverWorkingTiming()
            }
        }
        
        .alert(homeVM.alertType.getTitle(), isPresented: $homeVM.showAlertOnHomeScreen) {
        Button("Cancel", role: .cancel) {
            homeVM.showAlertOnHomeScreen = false
            // Reset flag so alert can show again if needed
            
        }
        Button("OK", role: .destructive) {
            homeVM.showAlertOnHomeScreen = false
            switch homeVM.alertType {
            
            case .nextDay:
                break
                // print("Resetting all timers for new day...")
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
                            // print(" Session expired detected during delete - staying on SessionExpireUIView")
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
                            // print(" Delete API message: \(deleteViewModel.apiMessage)")
                        }
                    } else{
                        // print(" Driver ID not found in UserDefaults")
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
            case .logoutOFFSleepDuty:
                break
            }
        }
            
        } message: {

            Text(homeVM.alertType.getMessage())
        }
        .navigationBarBackButtonHidden()
        
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

    }






private enum SyncPopupContext {
    case manualRefresh
    case logout
}

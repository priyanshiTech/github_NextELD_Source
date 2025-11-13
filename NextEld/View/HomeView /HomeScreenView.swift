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
    @StateObject var trailerVM: TrailerViewModel = .init()
    
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
                        VehicleInfoView(GadiNo: AppStorageHandler.shared.vehicleNo ?? "Not Found",
                                        trailer: UserDefaults.standard.string(forKey: "trailer") ?? "Upcoming")
                        StatusView(homeViewModel: homeVM) { status in
                            if !homeVM.check34HoursSleepOrOffDutyCompleted() && homeVM.cycleTimer!.remainingTime <= 0 && status != .offDuty && status != .sleep {
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
                .onAppear {
                    //  loadViolationsFromDatabase()
                    //  initializeViolationFlags()
                    //  homeVM.resetDailyViolationFlags() // Reset daily flags on app start
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
                        AppStorageHandler.shared.origin = OriginType.driver.description
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
                    Color.black.opacity(0.4)
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
                Color.black.opacity(0.5)
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
                        
                    }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        homeVM.violationDataArray.removeLast()
                    }
                })
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
        
        ZStack(alignment: .top) {
            
            if !syncVM.syncMessage.isEmpty {
                Text(syncVM.syncMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
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
           if let driverName = UserDefaults.standard.string(forKey: "driverName"),
               !driverName.isEmpty {
                labelValue = driverName
            }
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
            }
        }
            
        } message: {
            Text(homeVM.alertType.getMessage())
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

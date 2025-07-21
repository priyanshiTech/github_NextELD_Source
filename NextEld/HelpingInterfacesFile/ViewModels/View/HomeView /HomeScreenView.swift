////  HomeScreenView.swift
////  NextEld
////  Created by priyanshi on 07/05/25.
////
//
import SwiftUI

// MARK: - Subviews
struct TopBarView: View {
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var navManager: NavigationManager
    var labelValue: String
    @Binding var showDeviceSelector: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.frame(height: 50).shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            
            HStack {
                HStack(spacing: 80) {
                    IconButton(iconName: "line.horizontal.3", action: {
                        presentSideMenu.toggle()
                        print(" Hamburger tapped, presentSideMenu is now: \(presentSideMenu)")
                        
                    }, iconColor: .black, iconSize:20)
                    .bold()
                    .padding()
                    Button(action: {
                        navManager.navigate(to: AppRoute.DriverLogListView)
                    }) {
                        Text(labelValue)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.blue    ) // match DynamicLabel style
                    }
                    .padding()
                    .foregroundColor(.blue)
                    .buttonStyle(PlainButtonStyle()) // prevents default blue tint on iOS
                    
                }
                Spacer()
                HStack(spacing: 5) {
                    Button(action: {
                        showDeviceSelector = true
                    }) {
                        Image("bluuu")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    IconButton(iconName: "arrow.2.circlepath", action: {})
                        .padding()
                }
            }
        }
    }
}





struct VehicleInfoView: View {
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                Text("Truck")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .bold()
                
                Label("1234", systemImage: "")
                    .foregroundColor(.blue)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightBlue))
            .cornerRadius(5)
            
            Spacer()
            
            VStack(spacing: 5) {
                Text("Trailer")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .bold()
                
                Label("adsdas", systemImage: "")
                    .foregroundColor(.blue)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightBlue))
            .cornerRadius(5)
        }
        .padding(.horizontal)
    }
}

struct StatusView: View {
    
    @Binding var confirmedStatus: String?
    @Binding var selectedStatus: String?
    @Binding var showAlert: Bool
    //MARK: -  Continue Drive ,  Rest Break
    @ObservedObject var ContiueDrive:  CountdownTimer
    @ObservedObject var RestBreak: CountdownTimer
    
    var body: some View {
        CardContainer {
            VStack(alignment: .center) {
                Text("Current Status")
                    .font(.system(size: 18))
                    .underline()
                
                // Status boxes
                HStack(spacing: 10) {
//                    StatusBox(title: "Continue drive", time: "08:00:00")
//                    StatusBox(title: "Rest break", time: "00:30:00")
                    
                    StatusBox(title: "Continue drive", time: ContiueDrive.timeString)
                    StatusBox(title: "Rest break", time: RestBreak.timeString)

                }
                
                .padding()
                
                // Status checkboxes
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == "On-Duty",
                            labelText: "On-Duty",
                            onTap: {
                                selectedStatus = "On-Duty"
                                showAlert = true
                            })
                        
                        Spacer()
                        
                        StatusCheckBox(
                            isClick: confirmedStatus == "Drive",
                            labelText: "Drive",
                            onTap: {
                                selectedStatus = "Drive"
                                showAlert = true
                            })
                    }
                    .padding()
                    
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == "Off-Duty",
                            labelText: "Off-Duty",
                            onTap: {
                                selectedStatus = "Off-Duty"
                                showAlert = true
                            })
                        
                        Spacer()
                        
                        StatusCheckBox(
                            isClick: confirmedStatus == "Sleep",
                            labelText: "Sleep",
                            onTap: {
                                selectedStatus = "Sleep"
                                showAlert = true
                            })
                    }
                    .padding()
                }
                
                // Personal Use and Yard Move buttons
                HStack {
                    StatusButton(
                        title: "Personal Use",
                        action: {
                            selectedStatus = "Personal Use"
                            showAlert = true
                        },
                        isSelected: confirmedStatus == "Personal Use"
                    )
                    
                    Spacer()
                    
                    StatusButton(
                        title: "Yard Move",
                        action: {
                            selectedStatus = "Yard Move"
                            showAlert = true
                        },
                        isSelected: confirmedStatus == "Yard Move"
                    )
                }
            }
        }
    }
}

struct StatusBox: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .foregroundColor(.gray)
                .font(.callout)
                .bold()
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Label(time, systemImage: "")
                .foregroundColor(.blue)
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color(UIColor.lightBlue))
        .cornerRadius(5)
    }
}

struct StatusButton: View {
    let title: String
    let action: () -> Void
    let isSelected: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(isSelected ? .white : .blue)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.green : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color.blue, lineWidth: 2)
                )
        }
    }
}


struct AvailableHoursView: View {
    @EnvironmentObject var navmanager: NavigationManager
    @ObservedObject var driveTimer: CountdownTimer
    @ObservedObject var ONDuty: CountdownTimer
    @ObservedObject var cycleTimer: CountdownTimer
    @ObservedObject var sleepTimer: CountdownTimer
    
    
    var body: some View {
        CardContainer {
            VStack(spacing: 2) {
                HStack(spacing: 5) {
                    Button("Recap") {
                        navmanager.navigate(to: .RecapHours(tittle: "Hours Recap"))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.purple)
                    
                    Spacer()
                    Text("Available Hours")
                        .font(.system(size: 18))
                        .underline()
                        .font(.title3)
                    Spacer()
                    
                    Button("Daily Logs") {
                        navmanager.navigate(to: .DailyLogs(tittle: "Daily Logs"))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.purple)
                }
                .padding()
                
                //MARK: -  Time boxes
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        TimeBox(title: "On-Duty", timer: ONDuty)
                        TimeBox(title: "Drive", timer: driveTimer)
                    }
                    
                    HStack(spacing: 2) {
                        TimeBox(title: "Cycle / 7 Days", timer: cycleTimer)
                        TimeBox(title: "Sleep", timer: sleepTimer)
                    }
                }
            }
        }
    }
}


struct TimeBox: View {
    let title: String
    @ObservedObject var timer: CountdownTimer
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if title == "Cycle / 7 Days" {
                        // Only apply style for Cycle
                        (
                            Text("Cycle")
                                .foregroundColor(.white)
                                .bold()
                            +
                            Text(" / 7 Days")
                                .foregroundColor(.white)
                                .font(.footnote)
                        )
                    } else {
                        // Normal case
                        Text(title)
                            .foregroundColor(.white)
                            .bold()
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(formatTime(timer.remainingTime))
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .frame(height: 35)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}


// MARK: - Main View
struct HomeScreenView: View {
    
    @State private var labelValue = ""
    @State private var OnDutyvalue: Int = 0
    @State private var selectedStatus: String? = nil
    @State private var confirmedStatus: String? = nil
    @State private var showAlert: Bool = false
    @State private var showStatusalert: Bool = false
    @State private var showLogoutPopup: Bool = false
    @State private var isCycleCompleted: Bool = false
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    @State private var showDeviceSelector: Bool = false
    @State private var selectedDevice: String? = nil
    
    @State private var hoseEvents: [HOSEvent] = []
    @StateObject private var hoseChartViewModel = HOSEventsChartViewModel()
    
    
    //MARK: -  To show a static Data
    @State private var didShowOnDutyViolation = false
    @State private var didShowDriveViolation = false
    @State private var didShowCycleViolation = false
    @State private var didShowContinusDrivingVoilation =  false
    @AppStorage("didSyncOnLaunch") private var didSyncOnLaunch: Bool = false


    
    @State private var onDutyTimer = CountdownTimer(startTime: 0)
    @StateObject private var ONDuty: CountdownTimer
    
    @State private var driveTimerState = CountdownTimer(startTime: 0)
    @StateObject private var driveTimer: CountdownTimer
    
    @State private var cycleTimerState = CountdownTimer(startTime: 0)
    @StateObject private var cycleTimerOn: CountdownTimer
    
    @State private var sleepTimerState = CountdownTimer(startTime: 0)
    @StateObject private var sleepTimer: CountdownTimer
    
    @State private var DutyTime =  CountdownTimer(startTime: 0)
    @StateObject private var dutyTimerOn: CountdownTimer
    
    @StateObject var restBreakTimer = CountdownTimer(startTime: 0)
    @StateObject var breakTime: CountdownTimer
    
    @State private var  TimeZone : String = ""
    @State private var  TimeZoneOffSet : String = ""
    
    
    init(presentSideMenu: Binding<Bool>, selectedSideMenuTab: Binding<Int>, session: SessionManager) {
        self._presentSideMenu = presentSideMenu
        self._selectedSideMenuTab = selectedSideMenuTab
        self.session = session
        
        let onDutySeconds = CountdownTimer.timeStringToSeconds("14:00:00")
        let driveSeconds = CountdownTimer.timeStringToSeconds("11:00:00")
        let cycleSeconds = CountdownTimer.timeStringToSeconds("70:00:00")
        let sleepSeconds = CountdownTimer.timeStringToSeconds("10:00:00")
        let ContinueDriveTime = CountdownTimer.timeStringToSeconds("08:00:00")
        let breakTimer =  CountdownTimer.timeStringToSeconds("30:00:00")
        
        _ONDuty = StateObject(wrappedValue: CountdownTimer(startTime: onDutySeconds))
        _driveTimer = StateObject(wrappedValue: CountdownTimer(startTime: driveSeconds))
        _cycleTimerOn = StateObject(wrappedValue: CountdownTimer(startTime: cycleSeconds))
        _sleepTimer = StateObject(wrappedValue: CountdownTimer(startTime: sleepSeconds))
        _dutyTimerOn = StateObject(wrappedValue: CountdownTimer(startTime: ContinueDriveTime))
        _breakTime = StateObject(wrappedValue: CountdownTimer(startTime: breakTimer))
        
    }
    
    
    
    let session: SessionManager
    
    @State private var activeTimerAlert: TimerAlert?
    @EnvironmentObject var navmanager: NavigationManager
    //MARK: -  Show Alert Drive Before 30 min / 15 MIn
    
    @StateObject private var syncVM = SyncViewModel()
    //MARK: -  to show a Cycle state
    @State private var isOnDutyActive = false
    @State private var isDriveActive = false
    @State private var isCycleTimerActive = false
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
    
    
    //MARK: -  Network
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showBanner: Bool = false
    @State private var bannerMessage: String = ""
    @State private var bannerColor: Color = .green
    
    //MARK: -  Last Status Track
    @State private var offDutySleepAccumulated: TimeInterval = 0
    @State private var lastStatusChangeTime: Date? = nil


    
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack {
                // Top colored bar
                ZStack(alignment: .topLeading) {
                    Color(UIColor.colorPrimary)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 0)
                }
                
                TopBarView(
                    presentSideMenu: $presentSideMenu,
                    labelValue: labelValue,
                    showDeviceSelector: $showDeviceSelector
                )
                
                UniversalScrollView {
                    VStack {
                        Text("Disconnected")
                            .font(.title2)
                            .foregroundColor(.red)
                        
                        VehicleInfoView()
                        
                        StatusView(
                            confirmedStatus: $confirmedStatus,
                            selectedStatus: $selectedStatus,
                            showAlert: $showAlert,
                            ContiueDrive: dutyTimerOn,
                            RestBreak: breakTime
                        )
                        
                        AvailableHoursView(
                            driveTimer: driveTimer,
                            ONDuty: ONDuty,
                            cycleTimer: cycleTimerOn,
                            sleepTimer: sleepTimer
                        )
                        
                        HOSEventsChartScreen()
                            .environmentObject(hoseChartViewModel)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Version - OS/02/May")
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .disabled(presentSideMenu || showLogoutPopup)
            
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
                    showLogoutPopup: $showLogoutPopup
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
                    
                    if selected == "Sleep" || selected == "Off-Duty" || selected == "Personal Use" || selected == "Yard Move" || selected == "On-Duty" {
                        StatusDetailsPopup(
                            statusTitle: selected,
                            onClose: { showAlert = false },
                            onSubmit: { note in
                                confirmedStatus = selected
                                print("Note for \(selected): \(note)")
                                
                                if selected == "On-Duty" {
                                    sleepTimer.stop()
                                    let totalWorked = totalDutyLast7or8Days()
                                    let weeklyLimit = (cycleType == "7/60") ? 60 * 3600 : 70 * 3600
                                    if Int(totalWorked) >= weeklyLimit {
                                        activeTimerAlert = TimerAlert(
                                            title: "Cycle Violation",
                                            message: "You’ve exceeded your \(cycleType) duty hour limit.",
                                            backgroundColor: .red.opacity(0.9),
                                            isViolation: true
                                        )
                                        showAlert = false
                                        return
                                    }
                                    dutyTimerOn.stop()
                                    ONDuty.start()
                                    cycleTimerOn.start()
                                    breakTime.start()
                                    isOnDutyActive = true
                                    checkAndStartCycleTimer()
                                    offDutySleepAccumulated = 0
                                } else if selected == "Sleep" {
                                    sleepTimer.start()
                                    dutyTimerOn.stop()
                                    cycleTimerOn.stop()
                                    driveTimer.stop()
                                    ONDuty.stop()
                                    DutyTime.stop()
                                    breakTime.start()
                                    checkFor10HourReset()
                                } else if selected == "Off-Duty" {
                                    let dutyTime = ONDuty.elapsed
                                    saveDailyDutyLog(duration: dutyTime)
                                    driveTimer.stop()
                                    ONDuty.stop()
                                    dutyTimerOn.stop()
                                    sleepTimer.stop()
                                    breakTime.start()
                                    
                                    cycleTimerOn.stop()
                                    DutyTime.stop()
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
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: ONDuty.timeString,
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: breakTime.timeString,
                                    RemaningRestBreak: "true",
                                    isruning: selected == "Sleep",
                                    isVoilations: selected == "Drive" || selected == "On-Duty" || selected == "Sleep"
                                )
                                let logs = DatabaseManager.shared.fetchLogs()
                                print(" Total Logs in DB: \(logs.count)")
                                hoseChartViewModel.loadEventsFromDatabase()
                                
                                print("Saved \(selected) timer to DB at \(now)")
                            }
                            
                            
                        )
                        .zIndex(3)
                    } else if selected == "Drive" {
                        CustomPopupAlert(
                            title: "Certify Log",
                            message: "please add DVIR before going to On-Drive",
                            onOK: {
                                confirmedStatus = selected
                                isDriveActive = true
                                driveTimer.start()
                                dutyTimerOn.start()
                                startCycleTimer()
                                sleepTimer.stop()
                                breakTime.stop()
                                offDutySleepAccumulated = 0
                                showAlert = false
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let now = formatter.string(from: Date())
                                
                                DatabaseManager.shared.saveTimerLog(
                                    status: "Drive",
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: ONDuty.timeString,
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: "", RemaningRestBreak: restBreakTimer.timeString, isruning: false,
                                    
                                    
                                    
                                )
                                
                                DatabaseManager.shared.saveTimerLog(
                                    status: "Continue Drive",
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: dutyTimerOn.timeString, //MARK:   this is your continue drive timer
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: "", RemaningRestBreak: restBreakTimer.timeString,
                                    isruning: true
                                )
                                print(" Saved Continue Drive timer to DB at \(now)")
                                //MARK: -  RELOAD THE CHART DATA INSTANTLY
                                hoseChartViewModel.loadEventsFromDatabase()
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
                        currentStatus: "OffDuty",
                        onLogout: {
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
                            navmanager.navigate(to: .Login)
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
                showToast(message: "⚠️ No Internet Connection", color: .red)
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
        .onAppear {
            Task {
                await syncVM.syncOfflineData()
            }
        }
        
        
        //  All modifiers applied *on ZStack*
                .onAppear {
                    if let driverName = UserDefaults.standard.string(forKey: "driverName") {
                        labelValue = driverName
                    } else {
                        labelValue = "Unknown User"
                    }
        
                    if confirmedStatus == nil {
                        selectedStatus = "Off-Duty"
                        driveTimer.stop()
                        ONDuty.stop()
                        sleepTimer.stop()
                        cycleTimerOn.stop()
                        DutyTime.stop()
                        confirmedStatus = "Off-Duty"
                    }
        
                    checkFor34HourReset()
                    restoreAllTimers()
        
        
        
        
                }
        .onReceive(dutyTimerOn.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && !didShowContinusDrivingVoilation {
                activeTimerAlert = TimerAlert(
                    title: "Continue Drive",
                    message: "30 min left for completing your ONDuty cycle for a day",
                    backgroundColor: .blue.opacity(0.6)
                )
                didShowContinusDrivingVoilation = true
            }
            else if remaining <= 900 && remaining >= 800 && !didShowContinusDrivingVoilation {
                activeTimerAlert = TimerAlert(
                    title: "Continue Drive Alert",
                    message: "15 min left for completing your ONDuty cycle for a day",
                    backgroundColor: .orange
                )
                didShowContinusDrivingVoilation = true
            }
            else if remaining <= 0 && !didShowContinusDrivingVoilation {
                activeTimerAlert = TimerAlert(
                    title: "Continue Drive Violation",
                    message: "You are continuously driving for 8 hours",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowContinusDrivingVoilation = true
            }
        }

        .onReceive(ONDuty.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && !didShowOnDutyViolation {
                activeTimerAlert = TimerAlert(
                    title: "On-Duty Reminder",
                    message: "30 min left for completing your ONDuty cycle for a day",
                    backgroundColor: .blue.opacity(0.6)
                )
                didShowOnDutyViolation = true
            }
            else if remaining <= 900 && remaining >= 800 && !didShowOnDutyViolation {
                activeTimerAlert = TimerAlert(
                    title: "On-Duty Alert",
                    message: "15 min left for completing your ONDuty cycle for a day",
                    backgroundColor: .orange
                )
                didShowOnDutyViolation = true
            }
            else if remaining <= 0 && !didShowOnDutyViolation {
                activeTimerAlert = TimerAlert(
                    title: "On-Duty Violation",
                    message: "Your onduty time has been exceeded to 14 hours",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowOnDutyViolation = true
            }
        }

        .onReceive(driveTimer.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && !didShowDriveViolation {
                activeTimerAlert = TimerAlert(
                    title: "Drive Reminder",
                    message: "30 min left for completing your On Drive cycle for a day",
                    backgroundColor: .yellow
                )
                didShowDriveViolation = true
            }
            else if remaining <= 900 && remaining >= 800 && !didShowDriveViolation {
                activeTimerAlert = TimerAlert(
                    title: "Drive Alert",
                    message: "15 minutes left For completing your On Drive Cycle Of The Day",
                    backgroundColor: .orange
                    
                    
                )
                didShowDriveViolation = true
            }
            else if remaining <= 0 && !didShowDriveViolation {
                activeTimerAlert = TimerAlert(
                    title: "Drive Violation",
                    message: "Your drive time has been exceeded to 11 hours",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowDriveViolation = true
            }
        }

        
        .onReceive(cycleTimerOn.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && !didShowCycleViolation {
                activeTimerAlert = TimerAlert(
                    title: "Cycle Alert",
                    message: "30 min left for completing your cycle for a day",
                    backgroundColor: .purple.opacity(0.7)
                )
                didShowCycleViolation = true
            }
            else if remaining <= 900 && remaining >= 800 && !didShowCycleViolation {
                activeTimerAlert = TimerAlert(
                    title: "Cycle Alert",
                    message: "15 minutes left For completing your Cycle Of The Day",
                    backgroundColor: .orange
                )
                didShowCycleViolation = true
            }
            else if remaining <= 0 && !didShowCycleViolation {
                activeTimerAlert = TimerAlert(
                    title: "Cycle Violation",
                    message: "Your weekly cycle has been exceeded to 70 hours",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowCycleViolation = true
            }
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
    func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let parts = timeString.split(separator: ":").map { Int($0) ?? 0 }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0], minutes = parts[1], seconds = parts[2]
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }
    
    // MARK: - Check for 10-hour reset (Off-Duty + Sleep)
    func checkFor10HourReset() {
        // Total Off-Duty + Sleep time
        let totalRest = offDutySleepAccumulated
        if totalRest >= 10 * 3600 {
            print(" 10-hour reset reached. Resetting all timers except Cycle Timer.")

            // Stop all timers
            driveTimer.stop()
            ONDuty.stop()
            dutyTimerOn.stop()
            sleepTimer.stop()
            breakTime.stop()

            // Reset timers to full time (but DO NOT reset cycleTimerOn)
            driveTimer.reset(startTime: CountdownTimer.timeStringToSeconds("11:00:00"))
            ONDuty.reset(startTime: CountdownTimer.timeStringToSeconds("14:00:00"))
            dutyTimerOn.reset(startTime: CountdownTimer.timeStringToSeconds("08:00:00"))
            sleepTimer.reset(startTime: CountdownTimer.timeStringToSeconds("10:00:00"))
            breakTime.reset(startTime: CountdownTimer.timeStringToSeconds("30:00:00"))

            // Clear accumulated rest time
            offDutySleepAccumulated = 0

            // Refresh UI (On-Duty will start again when user selects status)
            confirmedStatus = "Off-Duty"
            selectedStatus = "Off-Duty"

            // Reload Events after reset
            hoseChartViewModel.loadEventsFromDatabase()

            // Save logs in DB for future restore
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = formatter.string(from: Date())

            DatabaseManager.shared.saveTimerLog(
                status: "Reset After 10 Hour Rest",
                startTime: now,
                remainingWeeklyTime: cycleTimerOn.timeString, // keep same cycle time
                remainingDriveTime: driveTimer.timeString,
                remainingDutyTime: ONDuty.timeString,
                remainingSleepTime: sleepTimer.timeString,
                lastSleepTime: breakTime.timeString,
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
        if let drive = loadLatestLog(for: "Drive"),
           let remaining = drive.remainingDriveTime?.asTimeInterval(),
           remaining > 0,
           let startDate = drive.startTime.asDate() {
            driveTimer.restore(from: remaining, startedAt: startDate, wasRunning: drive.isRunning)
        }
        
        if let duty = loadLatestLog(for: "On-Duty"),
           let remaining = duty.remainingDutyTime?.asTimeInterval(),
           remaining > 0,  // Only restore if non-zero
           let started = duty.startTime.asDate() {
            ONDuty.restore(from: remaining, startedAt: started, wasRunning: duty.isRunning)
        }
        
        
        if let cycle = loadLatestLog(for: "Cycle"),
           let remaining = cycle.remainingWeeklyTime?.asTimeInterval(),
           remaining > 0,
           let started = cycle.startTime.asDate() {
            cycleTimerOn.restore(from: remaining, startedAt: started, wasRunning: cycle.isRunning)
        }
        
        if let sleep = loadLatestLog(for: "Sleep"),
           let remaining = sleep.remainingSleepTime?.asTimeInterval(),
           remaining > 0,
           let startDate = sleep.startTime.asDate() {
            sleepTimer.restore(from: remaining, startedAt: startDate, wasRunning: sleep.isRunning)
        }
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
        cycleTimerOn.start()          //MARK: -   this is the CountdownTimer you passed to AvailableHoursView
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        DatabaseManager.shared.saveTimerLog(
            status: "Cycle",
            startTime: now,
            remainingWeeklyTime: cycleTimerOn.timeString,
            remainingDriveTime: driveTimer.timeString,
            remainingDutyTime: ONDuty.timeString,
            remainingSleepTime: sleepTimer.timeString,
            lastSleepTime: "", RemaningRestBreak: breakTime.timeString, isruning: false
        )
        
        print(" Saved Cycle timer to DB at \(now)")
        
    }
    
    
    func stopCycleTimer() {
        guard isCycleTimerActive else { return }
        isCycleTimerActive = false
        cycleTimerOn.stop() //  stop your cycle countdown
        print(" Cycle Timer Stopped")
    }
    
    
}


   //#Preview {
   //    HomeScreenView()
  //}































































































































































































//
//
////  HomeScreenView.swift
////  NextEld
////  Created by priyanshi on 07/05/25.
////
//
/*import SwiftUI

// MARK: - Subviews
struct TopBarView: View {
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var navManager: NavigationManager
    var labelValue: String
    @Binding var showDeviceSelector: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.frame(height: 50).shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            
            HStack {
                HStack(spacing: 80) {
                    IconButton(iconName: "line.horizontal.3", action: {
                        presentSideMenu.toggle()
                        print(" Hamburger tapped, presentSideMenu is now: \(presentSideMenu)")
                        
                    }, iconColor: .black, iconSize:20)
                    .bold()
                    .padding()
                    Button(action: {
                        navManager.navigate(to: AppRoute.DriverLogListView)
                    }) {
                        Text(labelValue)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.blue    ) // match DynamicLabel style
                    }
                    .padding()
                    .foregroundColor(.blue)
                    .buttonStyle(PlainButtonStyle()) // prevents default blue tint on iOS
                    
                }
                Spacer()
                HStack(spacing: 5) {
                    Button(action: {
                        showDeviceSelector = true
                    }) {
                        Image("bluuu")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    IconButton(iconName: "arrow.2.circlepath", action: {})
                        .padding()
                }
            }
        }
    }
}





struct VehicleInfoView: View {
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                Text("Truck")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .bold()
                
                Label("1234", systemImage: "")
                    .foregroundColor(.blue)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightBlue))
            .cornerRadius(5)
            
            Spacer()
            
            VStack(spacing: 5) {
                Text("Trailer")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .bold()
                
                Label("adsdas", systemImage: "")
                    .foregroundColor(.blue)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightBlue))
            .cornerRadius(5)
        }
        .padding(.horizontal)
    }
}

struct StatusView: View {
    
    @Binding var confirmedStatus: String?
    @Binding var selectedStatus: String?
    @Binding var showAlert: Bool
    
    var body: some View {
        CardContainer {
            VStack(alignment: .center) {
                Text("Current Status")
                    .font(.system(size: 18))
                    .underline()
                
                // Status boxes
                HStack(spacing: 10) {
                    StatusBox(title: "Continue drive", time: "08:00:00")
                    StatusBox(title: "Rest break", time: "00:30:00")
                }
                .padding()
                
                // Status checkboxes
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == "On-Duty",
                            labelText: "On-Duty",
                            onTap: {
                                selectedStatus = "On-Duty"
                                showAlert = true
                            })
                        
                        Spacer()
                        
                        StatusCheckBox(
                            isClick: confirmedStatus == "Drive",
                            labelText: "Drive",
                            onTap: {
                                selectedStatus = "Drive"
                                showAlert = true
                            })
                    }
                    .padding()
                    
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == "Off-Duty",
                            labelText: "Off-Duty",
                            onTap: {
                                selectedStatus = "Off-Duty"
                                showAlert = true
                            })
                        
                        Spacer()
                        
                        StatusCheckBox(
                            isClick: confirmedStatus == "Sleep",
                            labelText: "Sleep",
                            onTap: {
                                selectedStatus = "Sleep"
                                showAlert = true
                            })
                    }
                    .padding()
                }
                
                // Personal Use and Yard Move buttons
                HStack {
                    StatusButton(
                        title: "Personal Use",
                        action: {
                            selectedStatus = "Personal Use"
                            showAlert = true
                        },
                        isSelected: confirmedStatus == "Personal Use"
                    )
                    
                    Spacer()
                    
                    StatusButton(
                        title: "Yard Move",
                        action: {
                            selectedStatus = "Yard Move"
                            showAlert = true
                        },
                        isSelected: confirmedStatus == "Yard Move"
                    )
                }
            }
        }
    }
}

struct StatusBox: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .foregroundColor(.gray)
                .font(.callout)
                .bold()
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Label(time, systemImage: "")
                .foregroundColor(.blue)
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color(UIColor.lightBlue))
        .cornerRadius(5)
    }
}

struct StatusButton: View {
    let title: String
    let action: () -> Void
    let isSelected: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(isSelected ? .white : .blue)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.green : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color.blue, lineWidth: 2)
                )
        }
    }
}


struct AvailableHoursView: View {
    @EnvironmentObject var navmanager: NavigationManager
    //MARK: -  Continue Drive ,  Rest Break
   // @ObservedObject var ContiueDrive:  CountdownTimer
   // @ObservedObject var ResyBreak: CountdownTimer
    @ObservedObject var driveTimer: CountdownTimer
    @ObservedObject var ONDuty: CountdownTimer
    @ObservedObject var cycleTimer: CountdownTimer
    @ObservedObject var sleepTimer: CountdownTimer
    
    
    var body: some View {
        CardContainer {
            VStack(spacing: 2) {
                HStack(spacing: 5) {
                    Button("Recap") {
                        navmanager.navigate(to: .RecapHours(tittle: "Hours Recap"))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.purple)
                    
                    Spacer()
                    Text("Available Hours")
                        .font(.system(size: 18))
                        .underline()
                        .font(.title3)
                    Spacer()
                    
                    Button("Daily Logs") {
                        navmanager.navigate(to: .DailyLogs(tittle: "Daily Logs"))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.purple)
                }
                .padding()
                
                //MARK: -  Time boxes
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        TimeBox(title: "On-Duty", timer: ONDuty)
                        TimeBox(title: "Drive", timer: driveTimer)
                    }
                    
                    HStack(spacing: 2) {
                        TimeBox(title: "Cycle / 7 Days", timer: cycleTimer)
                        TimeBox(title: "Sleep", timer: sleepTimer)
                    }
                }
            }
        }
    }
}


struct TimeBox: View {
    let title: String
    @ObservedObject var timer: CountdownTimer
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if title == "Cycle / 7 Days" {
                        // Only apply style for Cycle
                        (
                            Text("Cycle")
                                .foregroundColor(.white)
                                .bold()
                            +
                            Text(" / 7 Days")
                                .foregroundColor(.white)
                                .font(.footnote)
                        )
                    } else {
                        // Normal case
                        Text(title)
                            .foregroundColor(.white)
                            .bold()
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(formatTime(timer.remainingTime))
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .frame(height: 35)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}


// MARK: - Main View
struct HomeScreenView: View {
    
    @State private var labelValue = ""
    @State private var OnDutyvalue: Int = 0
    @State private var selectedStatus: String? = nil
    @State private var confirmedStatus: String? = nil
    @State private var showAlert: Bool = false
    @State private var showStatusalert: Bool = false
    @State private var showLogoutPopup: Bool = false
    @State private var isCycleCompleted: Bool = false
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    @State private var showDeviceSelector: Bool = false
    @State private var selectedDevice: String? = nil
    
    @State private var hoseEvents: [HOSEvent] = []
    @StateObject private var hoseChartViewModel = HOSEventsChartViewModel()
    
    
    //MARK: -  To show a static Data
    //    @StateObject private var driveTimer = CountdownTimer(startTime: 11 * 3600)
    //    @StateObject private var ONDuty = CountdownTimer(startTime: 14 * 3600)
    //    @StateObject private var cycleTimerOn = CountdownTimer(startTime: 70 * 3600)
    //    @StateObject private var sleepTimer = CountdownTimer(startTime: 10 * 3600)
    //    @StateObject private var DutyTime =  CountdownTimer(startTime: 8 * 3600)
    @AppStorage("didSyncOnLaunch") private var didSyncOnLaunch: Bool = false


    
    @State private var onDutyTimer = CountdownTimer(startTime: 0)
    @StateObject private var ONDuty: CountdownTimer
    
    @State private var driveTimerState = CountdownTimer(startTime: 0)
    @StateObject private var driveTimer: CountdownTimer
    
    @State private var cycleTimerState = CountdownTimer(startTime: 0)
    @StateObject private var cycleTimerOn: CountdownTimer
    
    @State private var sleepTimerState = CountdownTimer(startTime: 0)
    @StateObject private var sleepTimer: CountdownTimer
    
    @State private var DutyTime =  CountdownTimer(startTime: 0)
    @StateObject private var dutyTimerOn: CountdownTimer
    
    @State private var  TimeZone : String = ""
    @State private var  TimeZoneOffSet : String = ""
    
    
    init(presentSideMenu: Binding<Bool>, selectedSideMenuTab: Binding<Int>, session: SessionManager) {
        self._presentSideMenu = presentSideMenu
        self._selectedSideMenuTab = selectedSideMenuTab
        self.session = session
        
        let onDutySeconds = CountdownTimer.timeStringToSeconds("14:00:00")
        let driveSeconds = CountdownTimer.timeStringToSeconds("11:00:00")
        let cycleSeconds = CountdownTimer.timeStringToSeconds("70:00:00")
        let sleepSeconds = CountdownTimer.timeStringToSeconds("10:00:00")
        let dutyTimeSeconds = CountdownTimer.timeStringToSeconds("08:00:00")
        
        _ONDuty = StateObject(wrappedValue: CountdownTimer(startTime: onDutySeconds))
        _driveTimer = StateObject(wrappedValue: CountdownTimer(startTime: driveSeconds))
        _cycleTimerOn = StateObject(wrappedValue: CountdownTimer(startTime: cycleSeconds))
        _sleepTimer = StateObject(wrappedValue: CountdownTimer(startTime: sleepSeconds))
        _dutyTimerOn = StateObject(wrappedValue: CountdownTimer(startTime: dutyTimeSeconds))
    }
    
    
    
    let session: SessionManager
    
    @State private var activeTimerAlert: TimerAlert?
    @EnvironmentObject var navmanager: NavigationManager
    //MARK: -  Show Alert Drive Before 30 min / 15 MIn
    
    @StateObject private var syncVM = SyncViewModel()
    //MARK: -  to show a Cycle state
    @State private var isOnDutyActive = false
    @State private var isDriveActive = false
    @State private var isCycleTimerActive = false
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
    
    
    //MARK: -  Network
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showBanner: Bool = false
    @State private var bannerMessage: String = ""
    @State private var bannerColor: Color = .green
    
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack {
                // Top colored bar
                ZStack(alignment: .topLeading) {
                    Color(UIColor.colorPrimary)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 0)
                }
                
                TopBarView(
                    presentSideMenu: $presentSideMenu,
                    labelValue: labelValue,
                    showDeviceSelector: $showDeviceSelector
                )
                
                UniversalScrollView {
                    VStack {
                        Text("Disconnected")
                            .font(.title2)
                            .foregroundColor(.red)
                        
                        VehicleInfoView()
                        
                        StatusView(
                            confirmedStatus: $confirmedStatus,
                            selectedStatus: $selectedStatus,
                            showAlert: $showAlert
                        )
                        
                        AvailableHoursView(
                            driveTimer: driveTimer,
                            ONDuty: ONDuty,
                            cycleTimer: cycleTimerOn,
                            sleepTimer: sleepTimer
                        )
                        
                        HOSEventsChartScreen()
                            .environmentObject(hoseChartViewModel)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Version - OS/02/May")
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .disabled(presentSideMenu || showLogoutPopup)
            
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
                    showLogoutPopup: $showLogoutPopup
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
                    
                    if selected == "Sleep" || selected == "Off-Duty" || selected == "Personal Use" || selected == "Yard Move" || selected == "On-Duty" {
                        StatusDetailsPopup(
                            statusTitle: selected,
                            onClose: { showAlert = false },
                            onSubmit: { note in
                                confirmedStatus = selected
                                print("Note for \(selected): \(note)")
                                
                                if selected == "On-Duty" {
                                    sleepTimer.stop()
                                    let totalWorked = totalDutyLast7or8Days()
                                    let weeklyLimit = (cycleType == "7/60") ? 60 * 3600 : 70 * 3600
                                    if Int(totalWorked) >= weeklyLimit {
                                        activeTimerAlert = TimerAlert(
                                            title: "Cycle Violation",
                                            message: "You’ve exceeded your \(cycleType) duty hour limit.",
                                            backgroundColor: .red.opacity(0.9),
                                            isViolation: true
                                        )
                                        showAlert = false
                                        return
                                    }
                                    ONDuty.start()
                                    cycleTimerOn.start()
                                    isOnDutyActive = true
                                    checkAndStartCycleTimer()
                                } else if selected == "Sleep" {
                                    sleepTimer.start()
                                    cycleTimerOn.stop()
                                    driveTimer.stop()
                                    ONDuty.stop()
                                    DutyTime.stop()
                                } else if selected == "Off-Duty" {
                                    let dutyTime = ONDuty.elapsed
                                    saveDailyDutyLog(duration: dutyTime)
                                    driveTimer.stop()
                                    ONDuty.stop()
                                    sleepTimer.stop()
                                    cycleTimerOn.stop()
                                    DutyTime.stop()
                                    isDriveActive = false
                                    isOnDutyActive = false
                                    checkAndStartCycleTimer()
                                }
                                
                                showAlert = false
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let now = formatter.string(from: Date())
                                
                                DatabaseManager.shared.saveTimerLog(
                                    status: selected,
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: ONDuty.timeString,
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: selected == "Sleep" ? now : "", RemaningRestBreak: "",
                                    isruning: selected == "Drive" || selected == "On-Duty" || selected == "Sleep"
                                )
                                
                                hoseChartViewModel.loadEventsFromDatabase()
                                
                                print("Saved \(selected) timer to DB at \(now)")
                            }
                            
                            
                        )
                        .zIndex(3)
                    } else if selected == "Drive" {
                        CustomPopupAlert(
                            title: "Certify Log",
                            message: "please add DVIR before going to On-Drive",
                            onOK: {
                                confirmedStatus = selected
                                isDriveActive = true
                                driveTimer.start()
                                startCycleTimer()
                                sleepTimer.stop()
                                showAlert = false
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let now = formatter.string(from: Date())
                                
                                DatabaseManager.shared.saveTimerLog(
                                    status: "Drive",
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: ONDuty.timeString,
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: "", RemaningRestBreak: "", isruning: false,
                                    
                                    
                                    
                                )
                                //MARK: -  RELOAD THE CHART DATA INSTANTLY
                                hoseChartViewModel.loadEventsFromDatabase()
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
                        currentStatus: "OffDuty",
                        onLogout: {
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
                            navmanager.navigate(to: .Login)
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
                   showToast(message: "⚠️ No Internet Connection", color: .red)
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
        .onAppear {
            Task {
                await syncVM.syncOfflineData()
            }
        }
        
        //834589375470-jknkdfg8u09-9-08

        //  All modifiers applied *on ZStack*
        .onAppear {
            if let driverName = UserDefaults.standard.string(forKey: "driverName") {
                labelValue = driverName
            } else {
                labelValue = "Unknown User"
            }
            
            if confirmedStatus == nil {
                selectedStatus = "Off-Duty"
                driveTimer.stop()
                ONDuty.stop()
                sleepTimer.stop()
                cycleTimerOn.stop()
                DutyTime.stop()
                confirmedStatus = "Off-Duty"
            }
            
            checkFor34HourReset()
            restoreAllTimers()
            
            
            
            
        }
        .onReceive(ONDuty.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "On-Duty Reminder", message: "30 min left for completing your ONDuty cycle for a day", backgroundColor: .blue.opacity(0.6))
            } else if remaining <= 900 && remaining >= 800 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "On-Duty Alert", message: "15 min left for completing your ONDuty cycle for a day", backgroundColor: .orange)
            } else if remaining <= 0 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "On-Duty Violation", message: " ON Duty limit  exceeded", backgroundColor: .red.opacity(0.9), isViolation: true)
            }
        }
        
        .onReceive(driveTimer.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "Drive Reminder", message: "30 min left for completing your On Drive cycle for a day", backgroundColor: .yellow)
            } else if remaining <= 900 && remaining >= 800 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "Drive Alert", message: "15 minutes left For completing your On Drive Cycle Of The Day", backgroundColor: .orange)
            } else if remaining <= 0 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "Drive Violation", message: "Drive limit exceeded", backgroundColor: .red.opacity(0.9), isViolation: true)
            }
        }
        
        .onReceive(cycleTimerOn.$remainingTime) { remaining in
            if remaining <= 1800 && remaining >= 1700 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "Cycle Alert", message: "30 min left for completing your cycle for a day", backgroundColor: .purple.opacity(0.7))
            } else if remaining <= 900 && remaining >= 800 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "Cycle Alert", message: "15 minutes left For completing your Cycle Of The Day", backgroundColor: .orange)
            } else if remaining <= 0 && activeTimerAlert == nil {
                activeTimerAlert = TimerAlert(title: "Cycle Violation", message: "Cycle limit exceeded", backgroundColor: .red.opacity(0.9), isViolation: true)
            }
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
    func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let parts = timeString.split(separator: ":").map { Int($0) ?? 0 }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0], minutes = parts[1], seconds = parts[2]
        return TimeInterval(hours * 3600 + minutes * 60 + seconds)
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
        if let drive = loadLatestLog(for: "Drive"),
           let remaining = drive.remainingDriveTime?.asTimeInterval(),
           remaining > 0,
           let startDate = drive.startTime.asDate() {
            driveTimer.restore(from: remaining, startedAt: startDate, wasRunning: drive.isRunning)
        }
        
        if let duty = loadLatestLog(for: "On-Duty"),
           let remaining = duty.remainingDutyTime?.asTimeInterval(),
           remaining > 0,  // Only restore if non-zero
           let started = duty.startTime.asDate() {
            ONDuty.restore(from: remaining, startedAt: started, wasRunning: duty.isRunning)
        }
        
        
        if let cycle = loadLatestLog(for: "Cycle"),
           let remaining = cycle.remainingWeeklyTime?.asTimeInterval(),
           remaining > 0,
           let started = cycle.startTime.asDate() {
            cycleTimerOn.restore(from: remaining, startedAt: started, wasRunning: cycle.isRunning)
        }
        
        if let sleep = loadLatestLog(for: "Sleep"),
           let remaining = sleep.remainingSleepTime?.asTimeInterval(),
           remaining > 0,
           let startDate = sleep.startTime.asDate() {
            sleepTimer.restore(from: remaining, startedAt: startDate, wasRunning: sleep.isRunning)
        }
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
        cycleTimerOn.start()          //MARK: -   this is the CountdownTimer you passed to AvailableHoursView
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = formatter.string(from: Date())
        
        DatabaseManager.shared.saveTimerLog(
            status: "Cycle",
            startTime: now,
            remainingWeeklyTime: cycleTimerOn.timeString,
            remainingDriveTime: driveTimer.timeString,
            remainingDutyTime: ONDuty.timeString,
            remainingSleepTime: sleepTimer.timeString,
            lastSleepTime: "", RemaningRestBreak: "", isruning: false
        )
        
        print(" Saved Cycle timer to DB at \(now)")
        
    }
    
    
    func stopCycleTimer() {
        guard isCycleTimerActive else { return }
        isCycleTimerActive = false
        cycleTimerOn.stop() //  stop your cycle countdown
        print(" Cycle Timer Stopped")
    }
    
    
}
//   #Preview {
//       HomeScreenView()
//  }
*/

/*    //MARK:   CONVERT TIME
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E - MMM d HH:mm:ss yyyy"

        // Use saved timezone information
        let timezoneOffset = UserDefaults.standard.string(forKey: "userTimezoneOffset") ?? "+05:30"
        let timezone = UserDefaults.standard.string(forKey: "userTimezone") ?? "IST"

        // Get timezone identifier from offset
        let timezoneIdentifier = getTimezoneIdentifier(from: timezoneOffset)
        formatter.timeZone = Foundation.TimeZone(identifier: timezoneIdentifier) ?? Foundation.TimeZone.current

        let formattedDate = formatter.string(from: date)
        return "\(formattedDate) \(timezone)"
    }

     Helper function to get timezone identifier from offset
    private func getTimezoneIdentifier(from offset: String) -> String {
        switch offset {
        case "+05:30": return "Asia/Kolkata"
        case "+05:00": return "Asia/Karachi"
        case "+08:00": return "Asia/Shanghai"
        case "-05:00": return "America/New_York"
        case "-08:00": return "America/Los_Angeles"
        case "-06:00": return "America/Chicago"
        case "+00:00": return "UTC"
        case "+01:00": return "Europe/London"
        case "+02:00": return "Europe/Berlin"
        case "+03:00": return "Europe/Moscow"
        case "+04:00": return "Asia/Dubai"
        case "+06:00": return "Asia/Almaty"
        case "+07:00": return "Asia/Bangkok"
        case "+09:00": return "Asia/Tokyo"
        case "+10:00": return "Australia/Sydney"
        case "+11:00": return "Pacific/Guadalcanal"
        case "+12:00": return "Pacific/Auckland"
        default: return "UTC"
        }
    }*/

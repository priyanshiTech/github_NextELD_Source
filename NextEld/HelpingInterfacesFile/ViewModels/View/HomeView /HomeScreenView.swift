//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 07/05/25.
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
    
    @State private var savedTimeZone: String = ""
    @State private var savedTimeZoneOffset: String = ""
 
    
    
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
                                formatter.timeZone = TimeZone(secondsFromGMT: 19800) // IST = GMT+5:30
                                let now = formatter.string(from: Date())
                                
                                updatePreviousEventEndTime()
                                DatabaseManager.shared.saveTimerLog(
                                    status: selected,
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: ONDuty.timeString,
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: selected == "Sleep" ? now : "",
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
                                formatter.timeZone = TimeZone(secondsFromGMT: 19800) // IST = GMT+5:30
                                let now = formatter.string(from: Date())
                                
                                updatePreviousEventEndTime()
                                DatabaseManager.shared.saveTimerLog(
                                    status: "Drive",
                                    startTime: now,
                                    remainingWeeklyTime: cycleTimerOn.timeString,
                                    remainingDriveTime: driveTimer.timeString,
                                    remainingDutyTime: ONDuty.timeString,
                                    remainingSleepTime: sleepTimer.timeString,
                                    lastSleepTime: "", isruning: false,
                                    
                                    
                                    
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
            
        }
        .onAppear {
            loadTodayHOSEvents()
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
 

    private func loadTodayHOSEvents() {
        let todayLogs = DatabaseManager.shared.fetchDutyEventsForToday()
        print(" Logs fetched from DB: \(todayLogs.count)")

        
        let converted = todayLogs.enumerated().compactMap { index, log -> HOSEvent? in
            let start = adjustedDate(from: log.startTime)
            let end = adjustedDate(from: log.endTime)


            return HOSEvent(
                id: index,
                x: start,
                event_end_time: end,
                label: log.status,
                dutyType: log.status
            )
        }

        hoseEvents = converted
    }

    func adjustedDate(from original: Date) -> Date {
        print("🕓 Raw: \(original) — Local: \(original.toLocalString())")
        return original
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
    //MARK:   CONVERT TIME
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E - MMM d HH:mm:ss 'GMT+05:30 yyyy'"
        formatter.timeZone = Foundation.TimeZone(identifier: "Asia/Kolkata")
        return formatter.string(from: date)
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
        cycleTimerOn.start() //  this is the CountdownTimer you passed to AvailableHoursView
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 19800) // IST = GMT+5:30
        let now = formatter.string(from: Date())
        
        updatePreviousEventEndTime()
        DatabaseManager.shared.saveTimerLog(
            status: "Cycle",
            startTime: now,
            remainingWeeklyTime: cycleTimerOn.timeString,
            remainingDriveTime: driveTimer.timeString,
            remainingDutyTime: ONDuty.timeString,
            remainingSleepTime: sleepTimer.timeString,
            lastSleepTime: "", isruning: false
        )
        
        print(" Saved Cycle timer to DB at \(now)")
        
    }
    
    
    func stopCycleTimer() {
        guard isCycleTimerActive else { return }
        isCycleTimerActive = false
        cycleTimerOn.stop() //  stop your cycle countdown
        print(" Cycle Timer Stopped")
    }
    
    
    func updatePreviousEventEndTime() {
        DatabaseManager.shared.updateLastEventEndTime(to: Date())
    }
}

extension String {
    func asDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current // or use saved time zone if needed
        return formatter.date(from: self)
    }
}

   //#Preview {
   //    HomeScreenView()
  //}











































































/*mport SwiftUI
 
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
                        //showDeviceSelector = true
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
     
     @ObservedObject var driveTimer: CountdownTimer
     @ObservedObject var ONDuty: CountdownTimer
     @ObservedObject var cycleTimer: CountdownTimer
     @ObservedObject var sleepTimer: CountdownTimer
   //@ObservedObject var DutyTime: CountdownTimer
     

    // @StateObject private var sleepTimer = CountdownTimer(startTime: 10 * 3600)

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
                       //  TimeBox(title: "Continous Drive", timer: DutyTime)
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

 // MARK: - DRIVE ALERT + ELD LOGIC
//            .onReceive(driveTimer.$remainingTime) { remaining in
//                // MARK: - Standard Drive Alerts (Your existing code)
//                if remaining == 17 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Drive Reminder",
//                        message: "30 minutes left before mandatory 30-minute break.",
//                        backgroundColor: .yellow
//
//                    )
//
//                }
//
//
//                if remaining == 900 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Drive Alert",
//                        message: "15 minutes left to complete 8-hour driving limit.",
//                        backgroundColor: .orange
//                    )
//                }
//
//
//                if remaining == 0 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Drive Violation",
//                        message: "You have exceeded your 8-hour driving limit without a 30-minute break.",
//                        backgroundColor: .red.opacity(0.9),
//                        isViolation: true
//                    )
//                }
//
//                // MARK: - On-Duty Alerts (Already present)
//                if remaining == 1800 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "On-Duty Reminder",
//                        message: "30 minutes left in your 14-hour on-duty window.",
//                        backgroundColor: .blue.opacity(0.6)
//                    )
//                }
//
//
//                if remaining == 900 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "On-Duty Alert",
//                        message: "15 minutes left to complete 14-hour ON-Duty limit.",
//                        backgroundColor: .orange
//                    )
//                }
//
//                if remaining == 0 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "On-Duty Violation",
//                        message: "You have exceeded your 14-hour on-duty time limit.",
//                        backgroundColor: .red.opacity(0.9),
//                        isViolation: true
//                    )
//                }
//
//                // MARK: - Cycle Timer Alerts CYCLETIMER
//                if remaining == 1800 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Cycle Alert",
//                        message: "30 minutes left in your 70-hour cycle.",
//                        backgroundColor: .purple.opacity(0.7)
//                    )
//                }
//
//
//                if remaining == 900 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Cycle Alert",
//                        message: "15 minutes left to complete 70-hour Cycle limit.",
//                        backgroundColor: .orange
//                    )
//                }
//
//                if remaining == 0 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Cycle Violation",
//                        message: "You have exceeded the 70-hour driving cycle limit.",
//                        backgroundColor: .red.opacity(0.9),
//                        isViolation: true
//                    )
//                }
//
//                // MARK: -  NEW: Track Cumulative Driving Time
//                if isDriveActive && !isOnBreak {
//                    cumulativeDriveTime += 1
//                }
//
//                // MARK: -  NEW: 8-hour Cumulative Violation Check
//                if cumulativeDriveTime >= 8 * 3600 && activeTimerAlert == nil {
//                    activeTimerAlert = TimerAlert(
//                        title: "Break Required",
//                        message: "You’ve driven 8 cumulative hours without a 30-minute break.",
//                        backgroundColor: .red.opacity(0.9),
//                        isViolation: true
//                    )
//                }
//            }
 
 // MARK: - Main View
 struct HomeScreenView: View {
     @State private var labelValue = "Mark Joseph"
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
     
     @StateObject private var driveTimer = CountdownTimer(startTime: 11 * 3600)
     @StateObject private var ONDuty = CountdownTimer(startTime: 14 * 3600)
     @StateObject private var cycleTimerOn = CountdownTimer(startTime: 70 * 3600)
     @StateObject private var sleepTimer = CountdownTimer(startTime: 10 * 3600)
     @StateObject private var DutyTime =  CountdownTimer(startTime: 8 * 3600)
     
     //@StateObject private var driveTimer = CountdownTimer(startTime: 60) // 60 seconds  testing voilation test
     //@StateObject private var driveTimer = CountdownTimer(startTime: 20) // 20 seconds total // 15 min testing
     //@StateObject private var driveTimer = CountdownTimer(startTime: 65) // 65 seconds total 30 min test

     let session: SessionManager

     @State private var activeTimerAlert: TimerAlert?
     @EnvironmentObject var navmanager: NavigationManager
     //MARK: -  Show Alert Drive Before 30 min / 15 MIn

     
     //MARK: -  to show a Cycle state
     @State private var isOnDutyActive = false
     @State private var isDriveActive = false

     @State private var isCycleTimerActive = false
     @State private var cycleTimeElapsed = 0
     @State private var cycleTimer: Timer?



     
     var body: some View {
         ZStack(alignment: .leading) {
             
             VStack {
                 // Top colored bar
                 ZStack(alignment: .topLeading) {
                     Color(UIColor.colorPrimary)
                         .edgesIgnoringSafeArea(.top)
                         .frame(height: 0)
                 }
                 
                 // TopBarView(presentSideMenu: $presentSideMenu, labelValue: labelValue)
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
                             sleepTimer: sleepTimer,
                            // DutyTime: DutyTime
                             
                             
                         )
                         
                         HOSEventsChartScreen()
                         
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
             
             //MARK: -  Add a new Updated Timer in my screen if showAlert, let selected = selectedStatus {
             
             
             if showAlert, let selected = selectedStatus{
                 ZStack {
                     Color.black.opacity(0.5)
                         .ignoresSafeArea()
                         .zIndex(2)
                     
                     
                     if selected == "Sleep" || selected == "Off-Duty" || selected == "Personal Use" || selected == "Yard Move" || selected == "On-Duty" {
                         StatusDetailsPopup(
                             statusTitle: selected,
                             onClose: {
                                 showAlert = false
                             },
                             onSubmit: { note in
                                 confirmedStatus = selected
                                 print("Note for \(selected): \(note)")
                                 
                                 //  Start "On-Duty" timer
                                 if selected == "On-Duty" {
                                     ONDuty.start()
                                    // DutyTime.start()
                                     isOnDutyActive = true
                                     checkAndStartCycleTimer()
                                 }else if selected == "Sleep" {
                                     sleepTimer.start() //  starts when sleep note is submitted
                                 }else if selected == "Off-Duty" {
                                     //  Stop all timers
                                     driveTimer.stop()
                                     ONDuty.stop()
                                     sleepTimer.stop()
                                     cycleTimerOn.stop()
                                    // DutyTime.stop()
                                     
                                     // MARK:  Clear flags
                                     isDriveActive = false
                                     isOnDutyActive = false
                                     checkAndStartCycleTimer()
                                 }
                                 
                                 showAlert = false
                             }
                         )
                         .zIndex(3)
                     } else if selected == "Drive" {
                         CustomPopupAlert(
                             title: "Certify Log",
                             message: "please add DVIR before going to On-Drive",
                             onOK: {
                                 confirmedStatus = selected
                                 
                                 //  Start "Drive" timer
                                 isDriveActive = true
                                 driveTimer.start()
                                 checkAndStartCycleTimer()
                                 showAlert = false
                                 
                             },
                             onCancel: {
                                 showAlert = false
                             }
                         )
                         .zIndex(3)
                     }
                 }
             }
             
             // Logout Popup
             if showLogoutPopup {
                 Color.black.opacity(0.5)
                     .ignoresSafeArea()
                     .zIndex(2)
                 
                 PopupContainer(isPresented: $showLogoutPopup) {
                     LogOutPopup(
                         isCycleCompleted: $isCycleCompleted,
                         currentStatus: "OffDuty",
                         onLogout: {
                             print("Logging out…")
                             showLogoutPopup = false
                             presentSideMenu = false
                             UserDefaults.standard.set(false, forKey: "isLoggedIn")
                             UserDefaults.standard.removeObject(forKey: "userEmail")
                             UserDefaults.standard.removeObject(forKey: "authToken")
                             UserDefaults.standard.removeObject(forKey: "driverName")

                             session.logOut()
                             SessionManagerClass.shared.clearToken()
                             navmanager.navigate(to: .Login)
                         },
                         onCancel: {
                             print("Cancel logout")
                             showLogoutPopup = false
                         }
                     )
                 }
                 .zIndex(3)
             }
   
             // Device Popup - Show centered, non-intrusive
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
                 .zIndex(10)
             }

             
             if let alert = activeTimerAlert {
                 CommonTimerAlertView(alert: alert) {
                     activeTimerAlert = nil
                 }
             }
    

         }.navigationBarBackButtonHidden()
         
         //MARK: - UPDate NAME
         .onAppear {
             // Load full name or fallback to email
             if let driverName = UserDefaults.standard.string(forKey: "driverName") {
                 labelValue = driverName
                 print(" Loaded full name: \(driverName)")
             }
                 else {
                 labelValue = "Unknown User"
                 print(" No user info found in UserDefaults")
             }

             // Auto-select Off-Duty
             if confirmedStatus == nil {
                 selectedStatus = "Off-Duty"
                 confirmedStatus = "Off-Duty"
             }
         }
         
         
         //MARK: -  DRIVE ALERT
             .onReceive(driveTimer.$remainingTime) { remaining in
                 if remaining == 17 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "Drive Reminder",
                         message: "30 minutes left before mandatory 30-minute break.",
                         backgroundColor: .yellow
                     )
                 }
                 
                 if remaining == 900 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "Drive Alert",
                         message: "15 minutes left to complete 8-hour driving limit.",
                         backgroundColor: .orange
                     )
                 }
                 
                 if remaining == 0 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "Drive Violation",
                         message: "You have exceeded your 8-hour driving limit without a 30-minute break.",
                         backgroundColor: .red.opacity(0.9),
                         isViolation: true
                     )
                 }
                 //MARK: -  ON DUTY ALERT
                 if remaining == 1800 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "On-Duty Reminder",
                         message: "30 minutes left in your 14-hour on-duty window.",
                         backgroundColor: .blue.opacity(0.6)
                     )
                 }
                 if remaining == 900 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "On-Duty Alert",
                         message: "15 minutes left to complete 14-hour ON-Duty limit.",
                         backgroundColor: .orange
                     )
                 }

                 if remaining == 0 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "On-Duty Violation",
                         message: "You have exceeded your 14-hour on-duty time limit.",
                         backgroundColor: .red.opacity(0.9),
                         isViolation: true
                     )
                 }
             
                 //MARK: -  Cycle Alert
                 if remaining == 1800 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "Cycle Alert",
                         message: "15 minutes left in your 70-hour cycle.",
                         backgroundColor: .purple.opacity(0.7)
                     )
                 }
                 if remaining == 900 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "Cycle Alert",
                         message: "15 minutes left to complete 70-hour Cycle limit.",
                         backgroundColor: .orange
                     )
                 }
                 if remaining == 0 && activeTimerAlert == nil {
                     activeTimerAlert = TimerAlert(
                         title: "Cycle Violation",
                         message: "You have exceeded the 70-hour driving cycle limit.",
                         backgroundColor: .red.opacity(0.9),
                         isViolation: true
                     )
                 }
             }


             .onAppear {
                 //MARK: -  Automatically select Off-Duty on first appear
                 if confirmedStatus == nil {
                     selectedStatus = "Off-Duty"
                     confirmedStatus = "Off-Duty"
                 }
             }

     }
     func formattedDate(_ date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "E - MMM d HH:mm:ss 'GMT+05:30 yyyy'"
         formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
         return formatter.string(from: date)
     }

     func checkAndStartCycleTimer() {
         print(" Checking Cycle Timer: Drive=\(isDriveActive), Duty=\(isOnDutyActive)")

         if isOnDutyActive && isDriveActive {
             startCycleTimer()
         } else {
             stopCycleTimer()
         }
     }

     func startCycleTimer() {
         guard !isCycleTimerActive else { return }
         print("🚀 Starting Cycle Timer")
         isCycleTimerActive = true
         cycleTimerOn.start() //  this is the CountdownTimer you passed to AvailableHoursView
     
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


*/

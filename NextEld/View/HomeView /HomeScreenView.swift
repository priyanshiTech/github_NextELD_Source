//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 07/05/25.
//
//
import SwiftUI

// MARK: - Subviews

struct TopBarView: View {
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var navManager: NavigationManager
    var labelValue: String
    @Binding var showDeviceSelector: Bool
    @StateObject private var deleteViewModel = DeleteViewModel()
    
    var body: some View {
        
        ZStack {
            Color.white
                .frame(height: 50)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            
            HStack {
                IconButton(iconName: "line.horizontal.3", action: {
                    presentSideMenu.toggle()
                    print("Hamburger tapped, presentSideMenu is now: \(presentSideMenu)")
                }, iconColor: .black, iconSize: 20)
               // .padding()
                .padding(.leading, 8)
                
                Spacer()
                
                // Right: Bluetooth
                Button(action: {
                    showDeviceSelector = true
                }) {
                    Image("bluuu")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 8)
            }
            
            // Center: Title (always centered)
            Button(action: {
                navManager.navigate(to: AppRoute.DriverLogListView)
            }) {
                Text(labelValue)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color(UIColor.wine))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}




struct VehicleInfoView: View {
    var GadiNo: String
    var trailer:String
    
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                Text("Truck")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .bold()
                
                Label(GadiNo, systemImage: "")
                    .foregroundColor(Color(uiColor: .wine))
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightWine))
            .cornerRadius(5)
            
            Spacer()
            
            VStack(spacing: 5) {
                Text("Trailer")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .bold()
                
                Label(trailer, systemImage: "")
                    .foregroundColor(Color(uiColor: .wine))
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(UIColor.lightWine))
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
                
                //MARK: - Status boxes
                HStack(spacing: 10) {

                    StatusBox(title: "Continue drive", time: ContiueDrive.timeString)
                    StatusBox(title: "Rest break", time: RestBreak.timeString)

                }
                .padding()
                //MARK: -  Status checkboxes
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.onDuty,
                            labelText: "On-Duty",
                            onTap: {
                                // Only show popup if not already selected
                                if confirmedStatus != DriverStatusConstants.onDuty {
                                    selectedStatus = DriverStatusConstants.onDuty
                                    showAlert = true
                                }
                            })

                            
                        Spacer()
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.onDrive,
                            labelText: "Drive",
                            onTap: {
                                // Only show popup if not already selected
                                if confirmedStatus != DriverStatusConstants.onDrive {
                                    selectedStatus = DriverStatusConstants.onDrive
                                    showAlert = true
                                }
                            })
                    }
                    .padding()
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.offDuty,
                            labelText: "Off-Duty",
                            onTap: {
                                // Only show popup if not already selected
                                if confirmedStatus != DriverStatusConstants.offDuty {
                                    selectedStatus = DriverStatusConstants.offDuty
                                    showAlert = true
                                }
                            })
                        
                        Spacer()
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.onSleep,
                            labelText: "Sleep",
                            onTap: {
                                // Only show popup if not already selected
                                if confirmedStatus != DriverStatusConstants.onSleep {
                                    selectedStatus = DriverStatusConstants.onSleep
                                    showAlert = true
                                }
                            })
                    }
                    .padding()
                }
            

                //MARK: -  Personal Use and Yard Move buttons
                HStack {
                    StatusButton(
                        title: "Personal Use",
                        action: {
                            // Only show popup if not already selected
                            if confirmedStatus != DriverStatusConstants.personalUse {
                                selectedStatus = DriverStatusConstants.personalUse
                                showAlert = true
                            }
                        },
                        isSelected: confirmedStatus ==  DriverStatusConstants.personalUse
                    )
                    
                    Spacer()
                    StatusButton(
                        title: "Yard Move",
                        action: {
                            // Only show popup if not already selected
                            if confirmedStatus != DriverStatusConstants.yardMove {
                                selectedStatus = DriverStatusConstants.yardMove
                                showAlert = true
                            }
                        },
                        isSelected: confirmedStatus == DriverStatusConstants.yardMove
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
                .foregroundColor(Color(uiColor: .wine))
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color(UIColor.lightWine))
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
                .foregroundColor(isSelected ? .white : Color(uiColor: .wine))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.green : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color(uiColor: .wine), lineWidth: 2)
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
                        TimeBox(title: DriverStatusConstants.onDuty, timer: ONDuty)
                        TimeBox(title: DriverStatusConstants.onDrive, timer: driveTimer)
                    
                    }
                    
                    HStack(spacing: 2) {
                        TimeBox(title: "Cycle / 7 Days", timer: cycleTimer)
                        TimeBox(title: DriverStatusConstants.onSleep, timer: sleepTimer)
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
                    //Text(formatTime(timer.remainingTime))
                    Text(timer.timeString)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .frame(height: 35)
        .padding()
        .background(Color(uiColor: .wine))
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
    @State private var ShowrefreshPopup: Bool = false
    @State private var isCycleCompleted: Bool = false
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    @State private var showDeviceSelector: Bool = false
    @State private var selectedDevice: String? = nil
    @State private var hasShownSleepResetPopup = false  //For reset SLEpp Timer
    @State private var hoseEvents: [HOSEvent] = []
    @StateObject private var hoseChartViewModel = HOSEventsChartViewModel()
    
    @State private var didShow30MinWarning = false
    @State private var didShow15MinWarning = false
    @State private var didShowViolation = false
    
    //MARK: -  To show a Voilation
    @State private var didShowOnDutyViolation = false
    @State private var didShowDriveViolation = false
    @State private var didShowCycleViolation = false
    @State private var didShowContinusDrivingVoilation =  false
    @AppStorage("didSyncOnLaunch") private var didSyncOnLaunch: Bool = false
    @State var isOnAppearCalled = false
    @State var isVoilation = false
    
    @EnvironmentObject var dutyManager: DutyStatusManager
    
    
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
    @State private var hasAppearedBefore = false
    @State private var savedOnDutyRemaining: TimeInterval = 0
    @State private var savedDriveRemaining: TimeInterval = 0
    @State private var savedCycleRemaining: TimeInterval = 0
    @State private var savedSleepingRemaning: TimeInterval = 0
    
    
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
        
        /*    let onDutySeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.onDutyTime ?? 140000)")
         let driveSeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.onDriveTime ?? 110000)")
         let cycleSeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.cycleTime ?? 700000)")
         let sleepSeconds = CountdownTimer.timeStringToSeconds("\(DriverInfo.onSleepTime ?? 100000)")
         let ContinueDriveTime = CountdownTimer.timeStringToSeconds(" \( DriverInfo.continueDriveTime ??  080000)")
         let breakTimer =  CountdownTimer.timeStringToSeconds("00:30:00")*/
        
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
                                
                                confirmedStatus = selected
                                dutyManager.dutyStatus = selected
                                print("Note for \(selected): \(note)")
                                
                                // Reset NEXTDAY popup flag when starting new work day
                                if selected == DriverStatusConstants.onDuty || selected == DriverStatusConstants.onDrive {
                                    hasShownNextDayPopup = false
                                    print("🔄 Reset NEXTDAY popup flag - new work day started")
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
                                    
                                    dutyTimerOn.stop()
                                    ONDuty.start()
                                    cycleTimerOn.start()
                                    isOnDutyActive = true
                                    checkAndStartCycleTimer()
                                    offDutySleepAccumulated = 0
                                    
                                }
                                
                                if selected == DriverStatusConstants.onSleep {
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
                                    
                                    dutyTimerOn.stop()
                                    ONDuty.stop()
                                    driveTimer.stop()
                                    cycleTimerOn.stop()
                                    //                                    breakTime.start()
                                    isSleepTimerActive = true
                                    // checkAndStartCycleTimer()
                                    offDutySleepAccumulated = 0
                                    
                                }
                                //                                else if selected == DriverStatusConstants.onSleep {
                                //                                    print(" Switching to Sleep - Timers already saved")
                                //
                                //                                    // Update saved states with current values before stopping
                                //                                    savedOnDutyRemaining = ONDuty.remainingTime
                                //                                    savedDriveRemaining = driveTimer.remainingTime
                                //                                    savedCycleRemaining = cycleTimerOn.remainingTime
                                //                                    print(" Updated saved states - OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
                                //
                                //                                    sleepTimer.start()
                                //                                    dutyTimerOn.stop()
                                //                                    cycleTimerOn.stop()
                                //                                    driveTimer.stop()
                                //                                    ONDuty.stop() // Stop but don't reset
                                //                                    DutyTime.stop()
                                //                                    breakTime.start()
                                //                                    checkFor10HourReset()
                                //
                                //                                }
                                
                                
                                else if selected == DriverStatusConstants.offDuty {
                                    print(" Switching to OffDuty - Timers already saved")
                                    
                                    // Update saved states with current values before stopping
                                    savedOnDutyRemaining = ONDuty.remainingTime
                                    savedDriveRemaining = driveTimer.remainingTime
                                    savedCycleRemaining = cycleTimerOn.remainingTime
                                    print(" Updated saved states - OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
                                    
                                    let dutyTime = ONDuty.elapsed
                                    saveDailyDutyLog(duration: dutyTime)
                                    driveTimer.stop()
                                    ONDuty.stop() // Stop but don't reset
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
                                
                                confirmedStatus = selected
                                dutyManager.dutyStatus = selected
                                
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
                                
                                isDriveActive = true
                                driveTimer.start()
                                ONDuty.start()
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
        
        
//        .onAppear {
//
//            if isOnAppearCalled { return }
//            isOnAppearCalled = true
//            print(" HomeScreenView onAppear called")
//            print(" Current status - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
//
//            if let driverName = UserDefaults.standard.string(forKey: "driverName"),
//               !driverName.isEmpty {
//                labelValue = driverName
//            } else {
//                DispatchQueue.main.async {
//                    navmanager.navigate(to: AppRoute.Login)
//                }
//                return
//            }
//
//            // Check if we have any saved timer data
//            let hasSavedData = !DatabaseManager.shared.fetchLogs().isEmpty
//            print(" Has saved data: \(hasSavedData)")
//
//            if hasSavedData {
//                print(" Found saved data - restoring timers")
//                // Delay restoration to ensure UI is ready
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.restoreAllTimers()
//                    hasRestoredTimers = true
//                    print(" Timer restoration completed - confirmedStatus: \(self.confirmedStatus ?? "nil"), selectedStatus: \(self.selectedStatus ?? "nil")")
//                }
//            } else {
//                print(" No saved data - initializing fresh")
//                if !hasAppearedBefore {
//                    hasAppearedBefore = true
//                }
//                // Always ensure status is set to Off-Duty if no saved data
//                if confirmedStatus == nil {
//                    selectedStatus = DriverStatusConstants.offDuty
//                    confirmedStatus = DriverStatusConstants.offDuty
//                    print("🔧 Set status to OffDuty (no saved data)")
//                }
//            }
//
//            // Always ensure status is properly set when view appears
//            if confirmedStatus == nil {
//                selectedStatus = DriverStatusConstants.offDuty
//                confirmedStatus = DriverStatusConstants.offDuty
//                print("🔧 Set status to OffDuty (fallback)")
//            }
//
//            print(" Final status after onAppear - confirmedStatus: \(confirmedStatus ?? "nil"), selectedStatus: \(selectedStatus ?? "nil")")
//            checkFor34HourReset()
//        }
        
//        .onReceive(dutyTimerOn.$remainingTime) { remaining in
//            if remaining <= 1800 && remaining >= 1700 && !didShowContinusDrivingVoilation {
//                activeTimerAlert = TimerAlert(
//                    title: "Continue Drive",
//                    message: "30 min left for completing your ONDuty cycle for a day \(times.local) GMT \(times.gmt)",
//                    backgroundColor: Color(uiColor: .wine).opacity(0.6)
//                )
//                didShowContinusDrivingVoilation = true
//            }
//            else if remaining <= 900 && remaining >= 800 && !didShowContinusDrivingVoilation {
//                activeTimerAlert = TimerAlert(
//                    title: "Continue Drive Alert",
//                    message: "15 min left for completing your ONDuty cycle for a day \(times.local) GMT \(times.gmt)",
//                    backgroundColor: .orange
//                )
//                didShowContinusDrivingVoilation = true
//            }
//            else if remaining <= 0 && !didShowContinusDrivingVoilation {
//                activeTimerAlert = TimerAlert(
//                    title: "Continue Drive Violation",
//                    message: "You are continuously driving for 8 hours\(times.local) GMT \(times.gmt)",
//                    backgroundColor: .red.opacity(0.9),
//                    isViolation: true
//                )
//                didShowContinusDrivingVoilation = true
//            }
//        }
        

        
        
        //***************************+++++++++++++++++++++++++++********************************************************************************************************
        // MARK: - OnDuty Timer Violation Logic with Working Time
        
        .onReceive(ONDuty.$remainingTime) { remainingTime in
            let totalDriveTime = DriverInfo.onDutyTime ?? 0
            let workingTime = Double(totalDriveTime) - remainingTime
            let violationThreshold = Double(totalDriveTime)
            
            // Debug logs
            print("Working: \(workingTime/3600) h, Remaining: \(remainingTime/3600) h")
            let times = DateTimeHelperVoilation.getLocalAndGMT()
            
            // Drive Violation - Only show box for actual violations
            if workingTime >= violationThreshold && !didShowViolation {
                activeTimerAlert = TimerAlert(
                    title: "On-Duty Violation",
                    message: "Your On-Duty time has been exceeded to 14 hours \(times.local) GMT \(times.gmt)",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowViolation = true
                
                // Show violation box immediately - ONLY for violations
                addViolationBox(text: "Your On-Duty time has been exceeded to 14 hours")
                
                print("Violation fired once")
                saveViolationToDatabase(status: "Violation", DutyType: "Your On-Duty time has been exceeded to 14 hours \(times.local)", isVoilation: true)
                
            } else {
                // 30-min warning - NO violation box
                if let warning1 = DriverInfo.setWarningOnDutyTime1,
                   workingTime >= Double(warning1),
                   !didShow30MinWarning {
                    
                    activeTimerAlert = TimerAlert(
                        title: "On-Duty Reminder",
                        message: "30 minutes left for completing your On-Duty cycle of the day \(times.local) GMT \(times.gmt)",
                        backgroundColor: .yellow
                    )
                    didShow30MinWarning = true
                    print("30min warning fired once")
                    // Save as warning, not violation - NO violation box
                    saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before On-Duty time exceeds", isVoilation: false)
                }
                
                // 15-min warning - NO violation box
                else if let warning2 = DriverInfo.setWarningOnDutyTime2,
                        Int(workingTime) >= Int((warning2)),
                        !didShow15MinWarning {
                    
                    activeTimerAlert = TimerAlert(
                        title: "On-Duty Alert",
                        message: "15 minutes left for completing your On-Duty  of the day \(times.local) GMT \(times.gmt)",
                        backgroundColor: .orange
                    )
                        didShow15MinWarning = true
                    print("15min warning fired once")
                    // Save as warning, not violation - NO violation box
                    saveViolationToDatabase(status: "Warning", DutyType: "15 minutes left before On-Duty time exceeds", isVoilation: false)
                }
                
            }
        }
        // MARK: - OnDrive Timer Violation with Working Time
        
        .onReceive(driveTimer.$remainingTime) { remainingTime in
            let totalDriveTime = DriverInfo.onDriveTime ?? 0
            let workingTime = Double(totalDriveTime) - remainingTime
            let violationThreshold = Double(totalDriveTime)
            
            print("Working: \(workingTime/3600) h, Remaining: \(remainingTime/3600) h")
            // Violation check
            if workingTime >= violationThreshold && !didShowViolation {
                activeTimerAlert = TimerAlert(
                    title: "On-Drive Violation",
                    message: "Your Ondrive time has been exceeded to 11 hours",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowViolation = true
                
                addViolationBox(text: "Your On Drive time has been exceeded to 11 hours")
                print("Violation fired once")
                
                saveViolationToDatabase(status: "Violation", DutyType: "Your On Drive time has been exceeded to 11 hours \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)
                
            } else {
                // 30-min warning - NO violation box
                if let warning1 =  DriverInfo.setWarningOnDriveTime1,
                   Int(workingTime) >= Int(warning1),
                   !didShow30MinWarning {
                    
                    activeTimerAlert = TimerAlert(
                        title: "On-Drive Reminder",
                        message: """
                        30 min left for completing your On Drive cycle for a day
                        Local: \(times.local)
                        GMT:   \(times.gmt)
                        """,
                        backgroundColor: .yellow
                    )
                    didShow30MinWarning = true
                    
                    print("30min warning fired once")
                    // Save as warning, not violation - NO violation box
                    saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before On Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                }
                
                // 15-min warning - NO violation box
                else if let warning2 =   DriverInfo.setWarningOnDriveTime2,
                        Int(workingTime) >= Int(warning2),
                        !didShow15MinWarning {
                    
                    activeTimerAlert = TimerAlert(
                        title: "On-Drive Reminder",
                        message: """
                        15 min left for completing your On Drive cycle for a day
                        Local: \(times.local)
                        GMT:   \(times.gmt)
                        """,
                        backgroundColor: .orange
                    )
                        didShow15MinWarning = true
                    print("15min warning fired once")
                    // Save as warning, not violation - NO violation box
                    saveViolationToDatabase(status: "Warning", DutyType: "15 minutes left before On Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                }
            }
            
        }
        
        // MARK: - Cycle Timer Violation Logic with Working Time
        .onReceive(cycleTimerOn.$remainingTime) { remainingTime in
            
            //   let totalCycleTime = CountdownTimer.timeStringToSeconds("70:00:00") // 70 hours in seconds
            let totalCycleTime = DriverInfo.cycleTime ?? 252000
            let workingTime = Double(totalCycleTime) - remainingTime
            let violationThreshold = totalCycleTime
            
            print(" Cycle 30min warning: Worked \(workingTime/3600) hours, \(remainingTime/3600) hours remaining")
            
            if Int(workingTime) >= violationThreshold && !didShowViolation {
                activeTimerAlert = TimerAlert(
                    title: "cycle Violation",
                    message:  "Your Cycle time has been exceeded to 70 hours \(times.local) GMT \(times.gmt)",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowViolation = true
                print("Violation fired once")
                
                saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before cycle time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)

            }
                                else {
                                    // 30-min warning (safe unwrap)
                                    if let warning1 = DriverInfo.cycleRestartTime,
                                        //DriverInfo.setWarningOnDriveTime1,
                                       Int(workingTime) >= warning1,
                                       !didShow30MinWarning {
                                        activeTimerAlert = TimerAlert(
                                            title: "Cycle Time Reminder",
                                            message: "30 minutes left for completing your  cycle of the Week \(times.local) GMT \(times.gmt)",
                                            backgroundColor: .yellow
                                        )
                                        didShow30MinWarning = true
                                        print("30min warning fired once")
                                        
                                        saveViolationToDatabase(status: "Warning", DutyType: "30 minutes left before cycle time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)
                                        
//
                                    }
            
                                    // 15-min warning (safe unwrap)
                                    else if let warning2 = DriverInfo.setWarningOnDriveTime2,
            
                                                Int(workingTime) >= Int(warning2),
                                            !didShow15MinWarning {
                                        activeTimerAlert = TimerAlert(
                                            title: "cycle Alert",
                                            message: "15 minutes left for completing your  cycle of the week \(times.local) GMT \(times.gmt)",
                                            backgroundColor: .orange
                                        )
                                        didShow15MinWarning = true
                                        print("15min warning fired once")
                                        
                                        saveViolationToDatabase(status: "Warning", DutyType: "15 minutes left before cycle time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)

                                    }
                                }
            
            
            
        }
        
        
        // MARK: - Continue Drive Timer Violation Logic with Working Time
        
        .onReceive(driveTimer.$remainingTime) { remainingTime in
            let totalDriveTime = DriverInfo.continueDriveTime ?? 0
            let workingTime = Double(totalDriveTime) - remainingTime
            let violationThreshold = Double(totalDriveTime)
            
            print("Working: \(workingTime/3600) h, Remaining: \(remainingTime/3600) h")
            
            //  Violation check at 8:00
            if workingTime >= violationThreshold && !didShowViolation {
                activeTimerAlert = TimerAlert(
                    title: "Continue Violation",
                    message: "Your drive time has been exceeded to 8 hours \(times.local) GMT \(times.gmt)",
                    backgroundColor: .red.opacity(0.9),
                    isViolation: true
                )
                didShowViolation = true
                print("Violation fired once")
                
                saveViolationToDatabase(status: "voilation", DutyType: "30 minutes left before Continue Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: true)

                
            } else {
                //  30-min warning at 7:30 (27000s)
                let warning30Min = 27000
                if Int(workingTime) >= warning30Min && !didShow30MinWarning {
                    activeTimerAlert = TimerAlert(
                        title: "Continue Drive Reminder",
                        message: "30 minutes left before reaching 8 hours  \(times.local) GMT \(times.gmt)",
                        backgroundColor: .yellow
                    )
                    
                    // DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    didShow30MinWarning = true
               
                    print("30min warning fired once")
                    saveViolationToDatabase(status: "voilation", DutyType: "30 minutes left before Continue Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)

                }
                
                //  15-min warning at 7:45 (27900s)
                let warning15Min = 27900
                if Int(workingTime) >= warning15Min && !didShow15MinWarning {
                    activeTimerAlert = TimerAlert(
                        title: "Continue Drive Alert",
                        message: "15 minutes left before reaching 8 hours  \(times.local) GMT \(times.gmt)",
                        backgroundColor: .orange
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        didShow15MinWarning = true }
                    print("15min warning fired once")
                    saveViolationToDatabase(status: "warning", DutyType: "15 minutes left before Continue Drive time exceedsLocal: \(times.local) ,GMT:\(times.gmt) ", isVoilation: false)

                }
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
                
                //  \n\nAuto-dismissing in 3 seconds...
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
            dutyTimerOn.stop()
            sleepTimer.stop()
            breakTime.stop()
            
            //Reset timers to full time (but DO NOT reset cycleTimerOn)
            driveTimer.reset(startTime: CountdownTimer.timeStringToSeconds("(11:00:00"))
            ONDuty.reset(startTime: CountdownTimer.timeStringToSeconds("14:00:00"))
            dutyTimerOn.reset(startTime: CountdownTimer.timeStringToSeconds("08:00:00"))
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
        let allLogs = DatabaseManager.shared.fetchLogs()
        print(" Total logs in database: \(allLogs.count)")
        
        guard !allLogs.isEmpty else {
            print(" No logs found, keeping timers as they are")
            return
        }
        
        // Get the most recent log
        let latestLog = allLogs.last!
        let currentStatus = latestLog.status
        print("🔄 Latest log status: \(currentStatus)")
        print(" Latest log time: \(latestLog.startTime)")
        print(" Latest log remaining times - Duty: \(latestLog.remainingDutyTime ?? "nil"), Drive: \(latestLog.remainingDriveTime ?? "nil"), Cycle: \(latestLog.remainingWeeklyTime ?? "nil")")
        
        // Calculate elapsed time since the log was saved
        let now = Date()
        let logTime = latestLog.startTime.asDate() ?? now
        let elapsedTime = now.timeIntervalSince(logTime)
        
        print("⏰ Current time: \(now)")
        print(" Log time: \(logTime)")
        print(" Elapsed time: \(elapsedTime) seconds (\(elapsedTime/60) minutes)")
        
        // Set the confirmed status from database
        print("🔄 Restoring status from database: \(currentStatus)")
        
        // Handle special case: if database has "NEXTDAY", show "OffDuty" in UI
        if currentStatus == "NEXTDAY" {
            confirmedStatus = DriverStatusConstants.offDuty
            selectedStatus = DriverStatusConstants.offDuty
            print("🔄 Mapped NEXTDAY to OffDuty for UI display")
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
        print(" &&&&&&&&&&&&Restoring ALL timer values  &&&&&&&&&&&& from database &&&&&&&&&&&& ")
        
        
        // Restore OnDuty timer
        if let dutyRemaining = latestLog.remainingDutyTime?.asTimeInterval() {
            // Start OnDuty timer for both OnDuty and OnDrive statuses
            if currentStatus == "OnDuty" || currentStatus == "OnDrive" {  // ← Changed this line
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
            if currentStatus == "OnDrive" {  // ← Changed this line
                // Running timer - subtract elapsed time (allow negative values)
                let adjustedDriveRemaining = driveRemaining - elapsedTime
                driveTimer.reset(startTime: adjustedDriveRemaining)
                driveTimer.start()
                //ONDuty.start()
                isDriveActive = true
                
                print(" Drive timer restored: \(driveTimer.timeString) (running - elapsed time subtracted)")
            } else {
                // Stopped timer - use exact saved value
                driveTimer.reset(startTime: driveRemaining)
                print(" Drive timer restored: \(driveTimer.timeString) (stopped - exact saved value)")
            }
        }
        
        
        
        // Restore Cycle timer
        if let cycleRemaining = latestLog.remainingWeeklyTime?.asTimeInterval() {
            
            // Only start if current status is OnDuty or OnDrive (running timers)
            if currentStatus == "OnDuty" || currentStatus == "OnDrive" {
                // Running timer - subtract elapsed time (allow negative values)
                let adjustedCycleRemaining = cycleRemaining - elapsedTime
                cycleTimerOn.reset(startTime: adjustedCycleRemaining)
                cycleTimerOn.start()
                isCycleTimerActive = true
                print(" Cycle timer restored: \(cycleTimerOn.timeString) (running - elapsed time subtracted)")
            } else {
                // Stopped timer - use exact saved value
                cycleTimerOn.reset(startTime: cycleRemaining)
                print(" Cycle timer restored: \(cycleTimerOn.timeString) (stopped - exact saved value)")
            }
        }
        
        // Restore Sleep timer
        if let sleepRemaining = latestLog.remainingSleepTime?.asTimeInterval() {
            
            // Only start if current status is OnSleep (running timer)
            if currentStatus == "OnSleep" {
                // Running timer - subtract elapsed time (allow negative values)
                let adjustedSleepRemaining = sleepRemaining - elapsedTime
                sleepTimer.reset(startTime: adjustedSleepRemaining)
                sleepTimer.start()
                print(" Sleep timer restored: \(sleepTimer.timeString) (running - elapsed time subtracted)")
            } else {
                // Stopped timer - use exact saved value
                sleepTimer.reset(startTime: sleepRemaining)
                print(" Sleep timer restored: \(sleepTimer.timeString) (stopped - exact saved value)")
            }
        }
        
        print(" Timer restoration completed")
    }
    
    //MARK: - Save current timer states before switching
    func saveCurrentTimerStatesBeforeSwitch() {
        // Save current timer states to our state variables
        savedOnDutyRemaining = ONDuty.remainingTime
        savedDriveRemaining = driveTimer.remainingTime
        savedCycleRemaining = cycleTimerOn.remainingTime
        
        print(" Saving timer states before switch:")
        print(" OnDuty: \(savedOnDutyRemaining/60) min, Drive: \(savedDriveRemaining/60) min, Cycle: \(savedCycleRemaining/60) min")
    }
    
    //MARK: - Save current timer states
    func saveCurrentTimerStates() {
        guard let currentStatus = confirmedStatus else {
            print(" No confirmed status, cannot save timer states")
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
            print("📊 No logs found in database")
            return (0, 0)
        }
        
        // Sort logs by timestamp
        let sortedLogs = allLogs.sorted { $0.timestamp < $1.timestamp }
        
        var totalOffDuty: TimeInterval = 0
        var totalSleep: TimeInterval = 0
        let currentTime = Date()
        
        print("📊 Processing \(sortedLogs.count) logs for time calculation")
        
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
                print("📊 OffDuty: \(log.startTime) for \(duration/3600) hours")
                
            case "OnSleep":
                totalSleep += duration
                print("📊 OnSleep: \(log.startTime) for \(duration/3600) hours")
                
            default:
                break
            }
        }
        
        print("📊 Total calculated - OffDuty: \(totalOffDuty/3600)h, Sleep: \(totalSleep/3600)h")
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
//    func loadViolationsFromDatabase() {
//        let logs = DatabaseManager.shared.fetchLogs()
//        // Only show violation boxes for actual violations, not warnings
//        let violationLogs = logs.filter { $0.isVoilations == 1 && $0.status == "Violation" }
//
//        violationBoxes.removeAll()
//
//        for log in violationLogs {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM dd"
//            let dateString = formatter.string(from: log.startTime.asDate() ?? Date())
//
//            formatter.dateFormat = "HH:mm:ss"
//            let timeString = formatter.string(from: log.startTime.asDate() ?? Date())
//
//            let violationData = ViolationBoxData(
//                text: log.dutyType,
//                date: dateString,
//                time: timeString,
//                timestamp: log.startTime.asDate() ?? Date()
//            )
//
//            violationBoxes.append(violationData)
//        }
//
//        if !violationBoxes.isEmpty {
//            showViolationBoxes = true
//        }
//    }
    
    
}









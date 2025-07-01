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
                        print("✅ Hamburger tapped, presentSideMenu is now: \(presentSideMenu)")

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
    @ObservedObject var dutyTimer: CountdownTimer
    @ObservedObject var cycleTimer: CountdownTimer
    @ObservedObject var sleepTimer: CountdownTimer

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
                        TimeBox(title: "On-Duty", timer: dutyTimer)
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
    @StateObject private var dutyTimer = CountdownTimer(startTime: 14 * 3600)
    @StateObject private var cycleTimerOn = CountdownTimer(startTime: 70 * 3600)
    @StateObject private var sleepTimer = CountdownTimer(startTime: 10 * 3600)

    

    @EnvironmentObject var navmanager: NavigationManager
    //MARK: -  Show Alert Drive Before 30 min
    @State private var showDrive30MinAlert = false
    @State private var drive30MinAlertTime: Date?
    
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
                            dutyTimer: dutyTimer,
                            cycleTimer: cycleTimerOn,
                            sleepTimer: sleepTimer
                           
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
                            
                            // 🟢 Start "On-Duty" timer
                            if selected == "On-Duty" {
                                dutyTimer.start()
                                isOnDutyActive = true
                                checkAndStartCycleTimer()
                            }else if selected == "Sleep" {
                                sleepTimer.start() // ✅ starts when sleep note is submitted
                            }else if selected == "Off-Duty" {
                                // ✅ Stop all timers
                                driveTimer.stop()
                                dutyTimer.stop()
                                sleepTimer.stop()
                                cycleTimerOn.stop()

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
                            
                            // 🟢 Start "Drive" timer
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
            if showDrive30MinAlert, let alertTime = drive30MinAlertTime {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()

                    VStack(spacing: 16) {
                        Text("ONDutyalert")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)

                        Text("You are continue Driving - 30 min left for take 30 min break at \(formattedDate(alertTime))")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        Button(action: {
                            showDrive30MinAlert = false
                        }) {
                            Text("OK")
                                .bold()
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                }
                .zIndex(99)
            }


        }.navigationBarBackButtonHidden()
            .onAppear {
                    print("📍 presentSideMenu in [HomeScreenView] = \(presentSideMenu)")
                }
                .onChange(of: presentSideMenu) { newValue in
                    print(" Side menu changed: \(newValue)")
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



//  HomeScreenView.swift
//  NextEld
//  Created by priyanshi on 07/05/25.
//

import SwiftUI

// MARK: - Subviews
struct TopBarView: View {
    @Binding var presentSideMenu: Bool
    var labelValue: String
    @State private var showbtPopup: Bool =  false
    @State private var SelectedBtnDevices: String? = nil
    @State private var ShowBtnDevice: Bool =  false
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.white
                .frame(height: 50)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            
            HStack {
                HStack(spacing: 80) {
                    // MARK: -
                    IconButton(iconName: "line.horizontal.3", action: {
                        presentSideMenu.toggle()
                    }, iconColor: .black, iconSize: 25)
                    .padding()
                    DynamicLabel(text: labelValue, systemImage: "")
                        .font(.system(size: 15))
                }
                Spacer()
                HStack(spacing: 5) {
                    Button(action: {
                        showbtPopup = true
                        print("Button tapped!")
                        
                    }) {
                        Image("bluuu") // or any button content
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    
                    IconButton(iconName: "arrow.2.circlepath", action: {})
                        .foregroundColor(.black)
                        .padding()
                }
//                PopupContainer(isPresented: $showbtPopup) {
//                    DeviceSelectorView(selectedBtnDevice: $SelectedBtnDevices, isPresentedDevices: $ShowBtnDevice)
//                }
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
    @EnvironmentObject var navmanager:NavigationManager

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
                        TimeBox(title: "Drive", time: "11:00:00")
                        TimeBox(title: "On-Duty", time: "14:00:00")
                    }
                    HStack(spacing: 2) {
                        TimeBox(title: "Cycle", time: "19:38:06")
                        TimeBox(title: "Sleep", time: "10:00:00")
                    }
                }
            }
        }
    }
}

struct TimeBox: View {
    let title: String
    let time: String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(title)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Label(time, systemImage: "")
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
    @EnvironmentObject var navmanager: NavigationManager
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                // Top colored bar
                ZStack(alignment: .topLeading) {
                    Color(UIColor.colorPrimary)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 10)
                }
                
                TopBarView(presentSideMenu: $presentSideMenu, labelValue: labelValue)
                
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
                        
                        AvailableHoursView()
                        
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
            
            // Status Popups
            if showAlert, let selected = selectedStatus {
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
        }
        .animation(.easeInOut, value: presentSideMenu)
        .animation(.easeInOut, value: showLogoutPopup)
        .navigationBarBackButtonHidden(true)
    }
}

   //#Preview {
   //    HomeScreenView()
  //}

//MARK: -  LogoutView



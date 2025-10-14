//
//  StatusView.swift
//  NextEld
//
//  Created by priyanshi  on 06/10/25.
//

import Foundation
import SwiftUI


struct StatusView: View {
    
//    @Binding var confirmedStatus: String?
//    @Binding var selectedStatus: String?
//    @Binding var showAlert: Bool
//    @Binding var showCertifyLogAlert: Bool
    //MARK: -  Continue Drive ,  Rest Break
//    @ObservedObject var ContiueDrive:  CountdownTimer
//    @ObservedObject var RestBreak: CountdownTimer
    @State private var selectedDriverStatus: DriverStutusType = .offDuty
    private var driverStatusTypes: Array<DriverStutusType> = [.onDuty, .onDrive, .offDuty, .sleep]
    let columns = [
        GridItem(.fixed(100), spacing: 80),
            GridItem(.fixed(100), spacing: 80)
        ]
    @ObservedObject var homeViewModel: HomeViewModel
    var onDriveStatusSelection: ((DriverStutusType) -> Void)
    
    //MARK: - Timer control functions
//    let onStopAllTimers: () -> Void
//    let onStartYardMoveTimers: () -> Void
    
    init(homeViewModel: HomeViewModel, onDriveStatusSelection: @escaping (DriverStutusType) -> Void) {
        self.homeViewModel = homeViewModel
        self.onDriveStatusSelection = onDriveStatusSelection
    }
    
    var body: some View {
        CardContainer {
            VStack(alignment: .center, spacing: 20) {
                Text("Current Status")
                    .font(.system(size: 18))
                    .underline()
                
                //MARK: - Status boxes
                HStack(spacing: 10) {
                    
                    StatusBox(
                              title: homeViewModel.getTimerInfo(for: .continueDrive).title,
                              time: homeViewModel.getTimerInfo(for: .continueDrive).timer
                    )
                    StatusBox(
                        title: homeViewModel.getTimerInfo(for: .breakTimer).title,
                        time: homeViewModel.getTimerInfo(for: .breakTimer).timer
                    )

                }
                .padding()
                //MARK: -  Status checkboxes
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(driverStatusTypes, id: \.self) { type in
                        
                        StatusCheckBox(
                            isClick: type == selectedDriverStatus,
                            labelText: type.getName(),
                            onTap: {
                                onDriveStatusSelection(type)
//                                if confirmedStatus != DriverStatusConstants.onDuty {
//                                    let hasPreviousLogs = CertifyDatabaseManager.shared.hasPreviousDayLogsUncertified()
//                                    if hasPreviousLogs {
//                                        //  Trigger popup overlay
//                                        showCertifyLogAlert = true
//                                    } else {
//                                        // Continue normal flow
//                                        selectedStatus = DriverStatusConstants.onDuty
//                                        showAlert = true
//                                    }
//                                }
                            }
                        )
                        
                    }
                   
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                
                /*
                
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.onDuty,
                            labelText: "On-Duty",
                            onTap: {
//                                if confirmedStatus != DriverStatusConstants.onDuty {
//                                    let hasPreviousLogs = CertifyDatabaseManager.shared.hasPreviousDayLogsUncertified()
//                                    if hasPreviousLogs {
//                                        //  Trigger popup overlay
//                                        showCertifyLogAlert = true
//                                    } else {
//                                        // Continue normal flow
//                                        selectedStatus = DriverStatusConstants.onDuty
//                                        showAlert = true
//                                    }
//                                }
                            }
                        )


                            
                        Spacer()
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.onDrive,
                            labelText: "Drive",
                            onTap: {
                                // Only show popup if not already selected
//                                if confirmedStatus != DriverStatusConstants.onDrive {
//                                selectedStatus = DriverStatusConstants.onDrive
//                                showAlert = true
//                                }
                            })
                    }
                    .padding()
                    HStack {
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.offDuty,
                            labelText: "Off-Duty",
                            onTap: {
                                // Only show popup if not already selected
//                                if confirmedStatus != DriverStatusConstants.offDuty {
//                                    selectedStatus = DriverStatusConstants.offDuty
//                                showAlert = true
//                                }
                            })
                        Spacer()
                        
                        StatusCheckBox(
                            isClick: confirmedStatus == DriverStatusConstants.onSleep,
                            labelText: "Sleep",
                            onTap: {
//                                if confirmedStatus != DriverStatusConstants.onSleep {
//                                selectedStatus = DriverStatusConstants.onSleep
//                                showAlert = true
//                                }
                            })
                    }
                    .padding()
                }
            */

                //MARK: -  Personal Use and Yard Move buttons
                HStack {
                    StatusButton(
                        title: DriverStutusType.personalUse.getName(),
                        action: {
                            selectedDriverStatus = .personalUse
                            onDriveStatusSelection(selectedDriverStatus)
                            // Only show popup if not already selected
//                            if confirmedStatus != DriverStatusConstants.personalUse {
//                            selectedStatus = DriverStatusConstants.personalUse
//                            showAlert = true
//                                
//                                // Stop all timers when Personal Use is selected
//                               // onStopAllTimers()
//                            }
                        },
                        isSelected: selectedDriverStatus == .personalUse
                    )
                    
                    Spacer()
                    StatusButton(
                        title: DriverStutusType.yardMode.getName(),
                        action: {
                            selectedDriverStatus = .yardMode
                            onDriveStatusSelection(selectedDriverStatus)
                            // Only show popup if not already selected
//                            if confirmedStatus != DriverStatusConstants.yardMove {
//                                selectedStatus = DriverStatusConstants.yardMove
//                            showAlert = true
//                                
//                                // Start OnDuty and Cycle timers for Yard Move
//                              //  onStartYardMoveTimers()
//                            }
                        },
                        isSelected: selectedDriverStatus == .yardMode
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .onChange(of: homeViewModel.currentDriverStatus) { newValue in
                self.selectedDriverStatus = newValue
            }
        }
    }
 
}

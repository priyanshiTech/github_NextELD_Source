//
//  StatusView.swift
//  NextEld
//
//  Created by priyanshi  on 06/10/25.
//

import Foundation
import SwiftUI

struct StatusView: View {
    
    @Binding var confirmedStatus: String?
    @Binding var selectedStatus: String?
    @Binding var showAlert: Bool
    //MARK: -  Continue Drive ,  Rest Break
    @ObservedObject var ContiueDrive:  CountdownTimer
    @ObservedObject var RestBreak: CountdownTimer
    
    //MARK: - Timer control functions
    let onStopAllTimers: () -> Void
    let onStartYardMoveTimers: () -> Void
    
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
                                
                                // Stop all timers when Personal Use is selected
                                onStopAllTimers()
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
                                
                                // Start OnDuty and Cycle timers for Yard Move
                                onStartYardMoveTimers()
                            }
                        },
                        isSelected: confirmedStatus == DriverStatusConstants.yardMove
                    )
                }
            }
        }
    }
 
}

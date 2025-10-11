//
//  AvailableHourBox.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI

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

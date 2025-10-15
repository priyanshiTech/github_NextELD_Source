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
    @ObservedObject var homeViewModel: HomeViewModel
    private var timerTypes: [TimerType] = [.onDuty, .onDrive, .cycleTimer, .sleepTimer]
    let columns = [
        GridItem(.flexible(), spacing: 2),
            GridItem(.flexible(), spacing: 2)
        ]
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        CardContainer {
            VStack(spacing: 2) {
                HStack(spacing: 5) {
                    Button("Recap") {
                      //  navmanager.navigate(to: AppRoute.logsFlow(.RecapHours(title: "Hours Recap")))
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
                       // navmanager.navigate(to: AppRoute.logsFlow(.DailyLogs(title: "Daily Logs")))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.purple)
                }
                .padding()
                
                //MARK: -  Time boxes
                
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(timerTypes, id: \.self) { type in
                        TimeBox(
                            type: type,
                            title: type.getName(),
                            time: returnRemaingTime(for: type)
                        )
                    }
                   
                }
//                
//                
//                
//                VStack(spacing: 2) {
//                    HStack(spacing: 2) {
//                        TimeBox(title: DriverStatusConstants.onDuty, timer: ONDuty)
//                        TimeBox(title: DriverStatusConstants.onDrive, timer: driveTimer)
//                    
//                    }
//                    
//                    HStack(spacing: 2) {
////                        TimeBox(title: "Cycle / 7 Days", timer: cycleTimer)
////                        TimeBox(title: DriverStatusConstants.onSleep, timer: sleepTimer)
//                    }
//                }
            }
        }
    }
    
    
    private func returnRemaingTime(for type: TimerType) -> String {
        var timer = ""
        switch type {
        case .onDuty:
                timer = homeViewModel.onDutyTimer?.remainingTime.timeString ?? ""
        case .cycleTimer:
                timer = homeViewModel.cycleTimer?.remainingTime.timeString ?? ""
        case .sleepTimer:
                timer = homeViewModel.sleepTimer?.remainingTime.timeString ?? ""
        case .onDrive:
                timer = homeViewModel.onDriveTimer?.remainingTime.timeString ?? ""
        default:
            break
        }
        return timer
    }
    
}

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
    private var timerTypes: [TimerType] = [.onDrive ,.onDuty, .cycleTimer, .sleepTimer]
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
                        navmanager.navigate(to: AppRoute.HomeFlow.RecapHours(title: AppConstants.HourRecap))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(Color(uiColor: .wine))
                    
                    Spacer()
                    Text("Available Hours")
                        .font(.system(size: 18))
                        .underline()
                        .font(.title3)
                    Spacer()
                    
                    Button("Daily Logs") {
                        
                        navmanager.path.append(AppRoute.HomeFlow.DailyLogs(tittle: "Daily Logs"))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(Color(uiColor: .wine))
                }
                .padding()
                
                //MARK: -  Time boxes
         

               
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(timerTypes, id: \.self) { type in
                        if type == .onDuty {
                            
                            TimeBox(timer: homeViewModel.onDutyTimer!, type: type, title: type.getName())
                        } else if type == .onDrive {
                            TimeBox(timer: homeViewModel.onDriveTimer!, type: type, title: type.getName())
                           
                        } else if type == .cycleTimer
                        {
                            TimeBox(timer: homeViewModel.cycleTimer!, type: type, title: type.getName())
                           
                        } else if type == .sleepTimer {
                            TimeBox(timer: homeViewModel.sleepTimer!, type: type, title: type.getName())
                        }
                        
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
    
    
//    private func returnRemaingTime(for type: TimerType) -> String {
//        var timer = ""
//       
//        return timer
//    }
    
}

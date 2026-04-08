//
//  HoursRecap.swift
//  NextEld
//  Created by priyanshi   on 15/05/25.
//

import Foundation
import SwiftUI


struct HoursRecap: View {
    var tittle: String
    @EnvironmentObject var navManager: NavigationManager
    @State private var last7Days: [WorkEntry] = []
    @State private var remainingCycleTime: TimeInterval = 0

    private let calendar = Calendar.current

    private func formatTime(_ interval: TimeInterval) -> String {
        let hrs = Int(interval) / 3600
        let mins = (Int(interval) % 3600) / 60
        let secs = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }

    private func formatDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }

    private var total7Day: TimeInterval {
        last7Days.reduce(0) { $0 + $1.hoursWorked }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                
                Button(action: { navManager.goBack() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine))

            // Table Header
            HStack {
                Text("Date").bold().foregroundColor(.white)
                Spacer()
                Text("Hours Worked").bold().foregroundColor(.white)
            }
            .padding()
            .background(Color(uiColor: .wine))

            // Table Content
            List {
                ForEach(last7Days) { entry in
                    HStack {
                        Text(entry.date.toLocalString(format: .dateOnlyFormat))
                        Spacer()
                        Text(formatTime(entry.hoursWorked))
                    }
                }

                HStack {
                    Text("Total 7 day work")
                    Spacer()
                    Text(formatTime(total7Day))
                }
                HStack {
                    Text("Hours Worked Today")
                    Spacer()
                    Text(DatabaseManager.shared.getTodaysWork().timeString)
                }
                HStack {
                    Text("Hours Available Today")
                    Spacer()
                    Text(DatabaseManager.shared.getRemainingWorkedToday().timeString)
                }
                HStack {
                    Text("Hours Available Tomorrow")
                    Spacer()
                   // Text("60:41:32") // replace with real calculation
                    Text(DatabaseManager.shared.getRemainingCycleTime().timeString)
                }
            }
        }
        .onAppear {
            last7Days = DatabaseManager.shared.fetchWorkEntriesLast7Days()
           // calculateTimeWhenDaysIsGreaterThan8days()
            
        }
        .navigationBarBackButtonHidden()
    }
    
    func calculateTimeWhenDaysIsGreaterThan8days() {
        if AppStorageHandler.shared.days <= 8 {
            return
        }
        let onDutyTime = AppStorageHandler.shared.onDutyTime ?? 0
        var remainingCycleTime: TimeInterval = DatabaseManager.shared.getRemainingCycleTime()

        if let workEntry = DatabaseManager.shared.getRecapeAfterSevenDays() {
            let totalTime = workEntry.hoursWorked + remainingCycleTime
            if totalTime > onDutyTime {
                remainingCycleTime =  onDutyTime
            } else {
                remainingCycleTime = totalTime
            }
        }
    }
}








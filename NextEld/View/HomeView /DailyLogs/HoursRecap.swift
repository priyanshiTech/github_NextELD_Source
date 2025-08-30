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
                        Text(formatDate(entry.date))
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
                    Text(formatTime(last7Days.last?.hoursWorked ?? 0))
                }
                HStack {
                    Text("Hours Available Today")
                    Spacer()
                    Text(DatabaseManager.shared.formatTime(DatabaseManager.shared.availableHoursToday()))
                }
                HStack {
                    Text("Hours Available Tomorrow")
                    Spacer()
                   // Text("60:41:32") // replace with real calculation
                    Text(DatabaseManager.shared.formatTime(DatabaseManager.shared.availableCycleHours(days: 7, limitHours: 70)))
                }
            }
        }
        .onAppear {
            last7Days = DatabaseManager.shared.fetchWorkEntriesLast7Days()
        }
        .navigationBarBackButtonHidden()
    }
}











































/*struct HoursRecap: View {
    var tittle: String
    
    @EnvironmentObject var navManager: NavigationManager
    
    private let calendar = Calendar.current
    
    // Generate last 7 days with dummy hours
    private var last7Days: [WorkEntry] {
        let today = Date()
        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            // Dummy hours (replace with real data from DB / API)
            let worked: TimeInterval = offset == 1 ? 10*3600 + 57*60 + 32 : (offset == 0 ? 0 : 0)
            return WorkEntry(date: date, hoursWorked: worked)
        }.reversed() // So earliest first
    }
    
    // Helpers
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
    
    // Totals
    private var total7Day: TimeInterval {
        last7Days.reduce(0) { $0 + $1.hoursWorked }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header bar
            HStack {
                Button(action: {
                    navManager.goBack()
                }) {
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
                        Text(formatDate(entry.date))
                        Spacer()
                        Text(formatTime(entry.hoursWorked))
                    }
                }
                
                // Summary Rows
                //  Section {
                HStack {
                    Text("Total 7 day work")
                    Spacer()
                    Text(formatTime(total7Day))
                }
                HStack {
                    Text("Hours Worked Today")
                    Spacer()
                    Text(formatTime(last7Days.last?.hoursWorked ?? 0))
                }
                HStack {
                    Text("Hours Available Today")
                    Spacer()
                    Text("14:00:00") // <- Replace with your real logic
                }
                HStack {
                    Text("Hours Available Tomorrow")
                    Spacer()
                    Text("60:41:32") // <- Replace with your real logic
                }
            }
            //
            
        } .navigationBarBackButtonHidden()
        
        }
       
    }


#Preview {
    HoursRecap(tittle: "Hours Recap")
        .environmentObject(NavigationManager())
}*/
































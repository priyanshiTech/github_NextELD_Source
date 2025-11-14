//
//  LogsDetails.swift
//  NextEld
//
//  Created by priyanshi   on 17/05/25.
//

import SwiftUI

struct LogsDetails: View {
    @EnvironmentObject var navManager: NavigationManager
    var title: String
    let entry: WorkEntry
    @State private var selectedDate: Date
    @State private var allLogs: [DriverLogModel] = []
    
    init(title: String, entry: WorkEntry) {
        self.title = title
        self.entry = entry
        self._selectedDate = State(initialValue: entry.date)
    }
    
    var body: some View {
        //MARK: -  Header
        
        
        VStack(spacing: 0){
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0)
                
            }
            ZStack(alignment: .top) {
                Color(uiColor: .wine)
                    .frame(height: 50)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                HStack {
                    Button(action: {
                        navManager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    Spacer()
                    //MARK: - previous page click date show
                    // Text(DateUtils.formatDate(entry.date, format: "dd-MM-yyyy"))
                    Text(title)
                    
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack(spacing: 5) {
                       // CustomIconButton(iconName: "eye_fill_icon", title: "", action: { navManager.navigate(to: .EyeViewData(tittle: "daily Logs"))})
                        CustomIconButton(iconName: "eye_fill_icon", title: "", action: {
                            
                          //  navManager.navigate(to: .logsFlow(.EyeViewData(title: "Daily Logs", entry: entry)))
                            
                            navManager.navigate(to: AppRoute.LogsFlow.EyeViewData(
                                title: "Daily Logs",
                                entry: entry))

                        })


                    }
                }
                .padding(.horizontal) // or even remove entirely to test
                .frame(height: 50)
                .alignmentGuide(.top) { _ in 0 } // optional, helps align precisely
//                .padding()
            }
            //MARK: -  show a date Format
            HStack{
                DateStepperView(currentDate: $selectedDate)
            }  .background(Color.white.shadow(radius: 5))
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HOSEventsChartScreen(events: [])
                        .frame(maxWidth: .infinity)
                    
                    Text("Version - OS/02/May")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Current Day Logs List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Day Logs")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if logsForSelectedDate.isEmpty {
                            Text("No logs available for this date.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } else {
                            // Header row
                            HStack(alignment: .center, spacing: 0) {
                                Text("Date & Time")
                                    .font(.system(.subheadline, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Duration")
                                    .font(.system(.subheadline, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Status")
                                    .font(.system(.subheadline, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray5))
                            
                            // Data rows
                            ForEach(0..<logsForSelectedDate.count, id: \.self) { index in
                                let log = logsForSelectedDate[index]
                                logRowView(log: log, index: index)
                            }
                        }
                    }
                }
                .padding()
            }
        }.navigationBarBackButtonHidden()
        .onAppear {
            loadLogsFromDatabase()
        }
        .onChange(of: selectedDate) { _ in
            loadLogsFromDatabase()
        }
        
    }
    
    private func logRowView(log: DriverLogModel, index: Int) -> some View {
        let duration = calculateDuration(for: log, at: index)
        
        return HStack(alignment: .center, spacing: 0) {
            // Date-Time column
            Text(formattedDateTime(log.startTime))
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Duration column
            Text(duration)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Status column
            Text(log.status)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(statusColor(for: log.status))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(index % 2 == 0 ? Color(.systemGray6) : Color(.systemBackground))
    }
    
    private var logsForSelectedDate: [DriverLogModel] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? selectedDate
        
        return allLogs
            .filter { $0.startTime >= startOfDay && $0.startTime < endOfDay }
            .sorted { $0.startTime < $1.startTime }
    }
    
    private func loadLogsFromDatabase() {
        // Load all logs for the selected date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? selectedDate
        
        // Fetch all logs and filter by date
        let allFetchedLogs = DatabaseManager.shared.fetchLogs(addWarningAndViolation: true)
        allLogs = allFetchedLogs.filter { $0.startTime >= startOfDay && $0.startTime < endOfDay }
    }
    
    private func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func calculateDuration(for log: DriverLogModel, at index: Int) -> String {
        // Find the next log to calculate duration
        let sortedLogs = logsForSelectedDate
        
        if index < sortedLogs.count - 1 {
            let nextLog = sortedLogs[index + 1]
            let duration = nextLog.startTime.timeIntervalSince(log.startTime)
            return formatDuration(duration)
        } else {
            // Last log - calculate duration till now or end of day
            let endTime = min(Date(), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: selectedDate)) ?? Date())
            let duration = endTime.timeIntervalSince(log.startTime)
            return formatDuration(duration)
        }
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "onduty", "on duty":
            return .orange
        case "driving":
            return .green
        case "sleeper":
            return .blue
        case "offduty", "off duty":
            return .gray
        default:
            return .purple
        }
    }
    
    func List(){
        //MARK: -  impliment The exact data for  on - duty , off-duty, new shift and all
        
    }
    
}
        


//#Preview {
//    LogsDetails()
//}

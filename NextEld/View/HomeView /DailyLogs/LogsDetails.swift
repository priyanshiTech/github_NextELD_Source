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
    @State private var timerTick: Int = 0
    @State private var timer: Timer?
    @StateObject private var homeVM : HomeViewModel = .init()

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
                    .shadow(color:  Color(uiColor:.black).opacity(0.2), radius: 4, x: 0, y: 4)
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
                            navManager.navigate(to: AppRoute.HomeFlow.EyeViewData(
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
                   // HOSEventsChartScreen(events: hoseEventsForSelectedDate)
                    HOSEventsChartScreen(events: homeVM.graphEvents)

                        .frame(maxWidth: .infinity)
                    
                    Text("Version - OS/02/May")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    currentDayLogsSection
                }
                .padding()
            }
        }.navigationBarBackButtonHidden()
        
        .onAppear {
           // loadLogsFromDatabase()
            //DateTimeHelper.currentDateTime()
            if allLogs.isEmpty {
                loadLogsFromDatabase()
            }

        }
//        .onChange(of: selectedDate) { oldValue, newValue in
//            loadLogsFromDatabase()
//        }
        
        .onDisappear {
            stopTimer()
        }
        
    }
    private var currentDayLogsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Day Logs")
                .font(.headline)
            
            if logsForSelectedDate.isEmpty {
                Text("No logs available for this date.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
            } else {
                ForEach(Array(logsForSelectedDate.enumerated()), id: \.offset) { index, log in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            // Show exact date and time from database as stored (UTC timezone to match database)
                            Text( DateTimeHelper.formatDatabaseDateTime(log.startTime))
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            // Show elapsed time in hours format for on-duty status
                            if isOnDutyStatus(log.status) {
                                Text(elapsedTimeInHours(for: log.startTime))
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .id("\(log.id ?? 0)-\(timerTick)")
                            } else {
                                // Show date only for other statuses - always use device's current timezone
                                Text(DateTimeHelper.formatDateOnly(log.startTime))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        statusBadge(for: log.status)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var logsForSelectedDate: [DriverLogModel] {
        let calendar = Calendar.current
        let timeZone = TimeZone.current

        return allLogs.filter { log in
            // Get date components for both dates in current timezone
            let logDateComponents = calendar.dateComponents(in: timeZone, from: log.startTime)
            let selectedDateComponents = calendar.dateComponents(in: timeZone, from: selectedDate)
            
            // Compare year, month, and day components
            return logDateComponents.year == selectedDateComponents.year &&
                   logDateComponents.month == selectedDateComponents.month &&
                   logDateComponents.day == selectedDateComponents.day
        }
        .sorted { $0.startTime < $1.startTime }
    }
    
    private var hoseEventsForSelectedDate: [HOSEvent] {
        let logs = logsForSelectedDate
        guard !logs.isEmpty else { return [] }
        
        var events: [HOSEvent] = []
        let calendar = Calendar.current
        
        for (index, log) in logs.enumerated() {
            let start = log.startTime
            let nextStart = index + 1 < logs.count
            ? logs[index + 1].startTime
            : DateTimeHelper.currentDateTime()
            
            events.append(
                HOSEvent(
                    id: Int(log.id ?? Int64(index)),
                    x: start,
                    event_end_time: nextStart,
                    dutyType: DriverStatusType(fromName: log.status) ?? .offDuty
                )
            )
        }
        
        return events
    }
    
    private func driverStatusType(for status: String) -> DriverStatusType {
        switch status.lowercased() {
        case "onduty", "on-duty", "on_duty":
            return .onDuty
        case "drive", "driving", "ondrive", "on-drive", "on_drive":
            return .onDrive
        case "sleep", "sleeper", "on_sleep", "on-sleep":
            return .sleep
        case "personal_use", "personaluse", "personal conveyance":
            return .personalUse
        case "yardmove", "yard_move", "yard":
            return .yardMode
        case "offduty", "off-duty", "off_duty":
            return .offDuty
        default:
            return .offDuty
        }
    }
    
    private func loadLogsFromDatabase() {
        let logs = DatabaseManager.shared.fetchLogs(addWarningAndViolation: true)
        allLogs = logs
    }
    
    private func isOnDutyStatus(_ status: String) -> Bool {
        let lowercased = status.lowercased()
        return lowercased == "onduty" || lowercased == "on duty"
    }

    
    private func elapsedTimeInHours(for startTime: Date) -> String {
        let currentTime = DateTimeHelper.currentDateTime()
        let elapsed = currentTime.timeIntervalSince(startTime)
        
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        
        // Format: H:MM:SS (e.g., 2:00:00, 2:30:45)
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func statusBadge(for status: String) -> some View {
        Text(status)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(statusColor(for: status))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor(for: status).opacity(0.15))
            .cornerRadius(12)
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
    
 
}
        


//#Preview {
//    LogsDetails()
//}

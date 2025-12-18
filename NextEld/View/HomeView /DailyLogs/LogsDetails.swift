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
    
    private var isSelectedDateToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
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
                VStack(alignment: .center) {
                   // HOSEventsChartScreen(events: hoseEventsForSelectedDate)
                   // HOSEventsChartScreen(events: homeVM.graphEvents)
                    HOSEventsChartScreen(
                        events: hoseEventsForSelectedDate
                    )
                        .frame(maxWidth: .infinity)
                    Text(" Version: \(AppInfo.version)(\(AppInfo.build))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    
                }
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 16) {
                    //MARK: - Violation Boxes (Part of Main Scroll)
                    if !violationsForToday.isEmpty {
                        ViolationsSectionView(violations: violationsForToday)
                    }
                    currentDayLogsSection
                }
                .padding()
            }
        }.navigationBarBackButtonHidden()

        .onChange(of: selectedDate) { oldValue, newValue in
            loadLogsFromDatabase()
        }
        
        .onDisappear {
            stopTimer()
        }
        
    }
    
    
    // Computed property to fetch violations for today
    private var violationsForToday: [DriverLogModel] {
        let today = selectedDate
        let startOfDay = DateTimeHelper.startOfDay(for: today)
        let endOfDay = DateTimeHelper.endOfDay(for: today) ?? today
        
        let logs = DatabaseManager.shared.fetchLogs(
            filterTypes: [.betweenDates(startDate: startOfDay, endDate: endOfDay)],
            addWarningAndViolation: true
        )
        
        // Filter only violations (status contains "violation" or "warning")
        return logs.filter { log in
            let status = log.status.lowercased()
            return status.contains("voilation") || status.contains("warning")
        }.sorted { $0.startTime < $1.startTime }
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
                    HStack(spacing: 12) {
                        // Left colored bar based on status - red for warning/violation
                      //  Rectangle()
                          //  .fill(isWarningOrViolation(log.status) ? Color.red : statusColor(for: log.status))
                        Rectangle()
                            .fill(logBarColor(for: log.status))
                            .frame(width: 4)

                        
                        VStack(alignment: .leading, spacing: 4) {
                            // Date and time - red for warning/violation
                            Text(DateTimeHelper.formatDatabaseDateTime(log.startTime))
                                .font(.subheadline)
                               // .foregroundColor(isWarningOrViolation(log.status) ? .red : .primary)
                                .foregroundColor(logTextColor(for: log.status))

                            
                            // Status name - show Warning(dutyType) or Violation(dutyType) format - red for warning/violation
                            Text(formatStatusDisplay(log: log))
                                .font(.subheadline)
                               // .foregroundColor(isWarningOrViolation(log.status) ? .red : .secondary)
                                .foregroundColor(logTextColor(for: log.status))

                            }
                        
                        Spacer()
                        
                        // Duration on right side
                        Text(calculateDuration(for: index, log: log))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var logsForSelectedDate: [DriverLogModel] {
        let startDate = DateTimeHelper.startOfDay(for: selectedDate)
        let endDate = DateTimeHelper.endOfDay(for: selectedDate) ?? selectedDate
        let logs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: startDate, endDate: endDate)],addWarningAndViolation: true).sorted { $0.startTime < $1.startTime }
        return logs
        
    }
    
    //LAST Log for Previous date if no record found in DB
    private func lastLogBeforeSelectedDate() -> DriverLogModel? {

        let startOfSelected = DateTimeHelper.startOfDay(for: selectedDate)

        // Fetch all logs once
        let allLogs = DatabaseManager.shared.fetchLogs(
            addWarningAndViolation: true
        )

        // Filter logs strictly BEFORE selected date
        let previousLogs = allLogs
            .filter { $0.startTime < startOfSelected }
            .sorted { $0.startTime > $1.startTime }

        return previousLogs.first
    }


    
    
    private var hoseEventsForSelectedDate: [HOSEvent] {
     
        
        var logs = DatabaseManager.shared.fetchDutyEventsForToday(currentDate: selectedDate)
       // logs.sort { $0.startTime < $1.startTime }

        let events = logs.enumerated().map { index, log in
            let status = DriverStatusType(fromName: log.status) ?? .offDuty
            var endDate = nextLogCalculation()
            if !(index == logs.count-1) {
                let nextIndexLog = logs[index+1]
                endDate = nextIndexLog.startTime
            }
            
            return HOSEvent(
                id: log.id,
                x: log.startTime,
                event_end_time: endDate,
                dutyType: status
            )
        }
        
        return events
    }
    
    func nextLogCalculation() -> Date {
        let selectedDateIsInTodaysDate = DateTimeHelper.currentCalendar.isDateInToday(selectedDate)
        if selectedDateIsInTodaysDate {
            return DateTimeHelper.currentDateTime()
        } else {
            return DateTimeHelper.endOfDay(for: selectedDate)?.addingTimeInterval(-1) ?? DateTimeHelper.currentDateTime()
        }
    }

//MARK:  for those date showing only
    // MARK: - Date validation helpers

    private var earliestLogDate: Date? {
        let logs = DatabaseManager.shared.fetchLogs()
        return logs
            .map { DateTimeHelper.startOfDay(for: $0.startTime) }
            .min()
    }

    private var latestAllowedDate: Date {
        DateTimeHelper.startOfDay(for: Date()) // today
    }

    private func nearestPreviousLogDate(from date: Date) -> Date? {
        let startOfDate = DateTimeHelper.startOfDay(for: date)

        let dates = DatabaseManager.shared.fetchLogs()
            .map { DateTimeHelper.startOfDay(for: $0.startTime) }
            .filter { $0 < startOfDate }
            .sorted(by: >)

        return dates.first
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

    // Calculate duration between current log and next log (or current time if last log)
    private func calculateDuration(for index: Int, log: DriverLogModel) -> String {
        let logs = logsForSelectedDate
        let startTime = log.startTime
        let endTime: Date
        
        if index + 1 < logs.count {
            // Use next log's start time
            endTime = logs[index + 1].startTime
        } else {
            // Last log - use current time if today, else end of day
            let calendar = Calendar.current
            if calendar.isDateInToday(selectedDate) {
                endTime = DateTimeHelper.currentDateTime()
            } else {
                endTime = DateTimeHelper.endOfDay(for: selectedDate) ?? selectedDate
            }
        }
        
        let elapsed = endTime.timeIntervalSince(startTime)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        let seconds = Int(elapsed) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Format status display - show Warning(dutyType) or Violation(dutyType) if applicable
    private func formatStatusDisplay(log: DriverLogModel) -> String {
        let status = log.status.lowercased()
        let dutyType = log.dutyType
        
        if status.contains("warning") {
            // Show Warning(dutyType) format
            return "Warning(\(dutyType))"
        } else if status.contains("violation") {
            // Show Violation(dutyType) format
            return "Violation(\(dutyType))"
        } else {
            // Normal status - just show the status
            return log.status
        }
    }
    
    // Check if status is warning or violation
    private func isWarningOrViolation(_ status: String) -> Bool {
        let lowercased = status.lowercased()
        return lowercased.contains("warning") || lowercased.contains("violation")
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
    
    private func isWarning(_ status: String) -> Bool {
        status.lowercased().contains("warning")
    }

    private func isViolation(_ status: String) -> Bool {
        status.lowercased().contains("violation")
    }

    private func logTextColor(for status: String) -> Color {
        if isViolation(status) {
            return .red
        } else if isWarning(status) {
            return .yellow
        } else {
            return .primary
        }
    }

    private func logBarColor(for status: String) -> Color {
        if isViolation(status) {
            return .red
        } else if isWarning(status) {
            return Color(UIColor.yellow)
        } else {
            return statusColor(for: status)
        }
    }
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "onduty", "on duty" ,  "yardmove":
            return .blue
        case "ondrive":
            return .green
        case "onsleep":
            return .gray
        case "offduty", "off duty", "personaluse":
            return .orange
        default:
            return .gray
        }
    }
    
}

        


//#Preview {
//    LogsDetails()
//}

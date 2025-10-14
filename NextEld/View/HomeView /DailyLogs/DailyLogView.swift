//
//  DailyLogView.swift
//  NextEld
//
//  Created by priyanshi  on 13/05/25.
//

import SwiftUI


struct LogDate: Identifiable {
    let id = UUID()
    let date: String
    let isMissing: Bool
}

struct DailyLogView: View {
    
    @State var lbldate: String = ""
    var title: String
    @EnvironmentObject var navManager: NavigationManager
    let entry: WorkEntry  //passed from previous screen
    
    //MARK: -  Database dates for last 7 days
    private var logDates: [LogDate] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        // Get today's date
        let today = Date()
        
        // Calculate date range for last 7 days
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
            return []
        }
        
        // DB se logs nikalo
        let logs = DatabaseManager.shared.fetchLogs()
        
        // Filter logs for last 7 days and extract unique dates
        let logsInRange = logs.compactMap { log -> String? in
            guard let logDate = log.startTime.toDate() else { return nil }
            
            // Check if log date is within last 7 days
            if logDate >= sevenDaysAgo && logDate <= today {
                return formatter.string(from: logDate)
            }
            return nil
        }
        
        // Get unique dates and sort them
        let uniqueDates = Array(Set(logsInRange)).sorted { date1, date2 in
            guard let d1 = formatter.date(from: date1),
                  let d2 = formatter.date(from: date2) else { return false }
            return d1 > d2 // latest first
        }
        
        // Convert to LogDate objects (all dates from DB are not missing)
        return uniqueDates.map { LogDate(date: $0, isMissing: false) }
    }
    //MARK: - Database records for certification check
    private var certifiedRecords: [CertifyRecord] {
        return CertifyDatabaseManager.shared.fetchAllRecords()
    }
    //MARK: - Check if a date is fully certified (date exists + isSynced = 1 + isLogCertified = "Yes")
    private func isDateFullyCertified(_ logDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        print(" Checking certification for date: \(logDate)")
        
        for record in certifiedRecords {
            // Convert DB date to same format for comparison
            if let dbDate = parseDate(record.date) {
                let dbDateString = formatter.string(from: dbDate)
                
                print("     Comparing with DB record:")
                print("    - DB Date: \(record.date) -> Formatted: \(dbDateString)")
                print("    - Log Date: \(logDate)")
                print("    - Date Match: \(dbDateString == logDate)")
                print("    - isSynced: \(record.syncStatus) (needs to be 1)")
                print("    - isLogCertified: \(record.isCertify) (needs to be 'Yes')")
                
                // Check all three conditions:
                // 1. Date matches
                // 2. isSynced = 1
                // 3. isLogCertified = "Yes"
                let dateMatches = dbDateString == logDate
                let isSynced = record.syncStatus == 1
                let isCertified = record.isCertify == "Yes"
                
                print("    - All conditions met: \(dateMatches && isSynced && isCertified)")
                
                if dateMatches && isSynced && isCertified {
                    print("     FULLY CERTIFIED - All conditions met!")
                    return true
                } else if dateMatches {
                    print("      Date exists but NOT fully certified:")
                    print("      - isSynced: \(isSynced)")
                    print("      - isLogCertified: \(isCertified)")
                }
            }
        }
        
        print("     NOT CERTIFIED - No matching record or conditions not met")
        return false
    }
    
    // Helper function to parse various date formats
    private func parseDate(_ dateString: String) -> Date? {
        let formats = [
            "yyyy-MM-dd",
            "dd-MM-yyyy",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "MM/dd/yyyy",
            "dd/MM/yyyy"
        ]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    var body: some View {
        
        //MARK: top Header Colour
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0)
                
            }
            //MARK: -  Header
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
                            .bold()
                            .imageScale(.large)
                    }
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
//                    HStack(spacing: 5) {
//                        CustomIconButton(iconName: "email_icon", title: "", action: { navManager.navigate(to: AppRoute.logsFlow(.EmailLogs(title: " Daily Logs")))})
//                            .padding()
//                        CustomIconButton(iconName: "alarm_icon", title: "", action: { navManager.navigate(to: AppRoute.logsFlow(.RecapHours(title: "Hours Recap")))})
//                            .foregroundColor(.black)
//                    }
                    HStack(spacing: 5) {
                        CustomIconButton(iconName: "email_icon", title: "", action: { navManager.navigate(to: AppRoute.DvirFlow.emailLogs(tittle: " Daily Logs"))})
                            .padding()
                        CustomIconButton(iconName: "alarm_icon", title: "", action: { navManager.navigate(to: AppRoute.RecapHours(tittle: "Hours Recap"))})
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
            }
            
            HStack{
                
                Image(systemName: "exclamationmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color(uiColor: .wine)) // mark = white, circle = blue
                    .font(.system(size: 25))
                
                Text("Please display required logs as per FMCSA and CCATM")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding()
            
            //MARK: -  List Section
            List(logDates) { log in
                HStack {
                    Text(dateFormattedString(log.date))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Condition: Check if date is fully certified (date exists + isSynced = 1 + isLogCertified = "Yes")
                    let isCertified = isDateFullyCertified(log.date)
                  //  print(" Final result for \(log.date): isCertified = \(isCertified)")
                    
                    if isCertified {
                        Button(action: {
                            navManager.navigate(to: AppRoute.HomeFlow.CertifySelectedView(tittle: dateFormattedString(log.date)))
                            print("Certified tapped for \(dateFormattedString(log.date))")
                        }) {
                            Text("Certified")
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(6)
                        }
                    } else {
                        Button(action: {
                            navManager.navigate(to: AppRoute.HomeFlow.CertifySelectedView(tittle: dateFormattedString(log.date)))
                            print("Uncertified tapped for \(dateFormattedString(log.date))")
                        }) {
                            Text("Uncertified")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                }
                .contentShape(Rectangle())
            }
            
//            List(logDates) { log in
//                HStack {
//                    Text(dateFormattedString(log.date))
//                        .foregroundColor(.primary)
//                    
//                    Spacer()
//                    
//                    // Condition: Check if date is fully certified (date exists + isSynced = 1 + isLogCertified = "Yes")
//                    let isCertified = isDateFullyCertified(log.date)
//                  //  print(" Final result for \(log.date): isCertified = \(isCertified)")
//                    
//                    if isCertified {
//                        Button(action: {
//                            navManager.navigate(to: AppRoute.logsFlow(.CertifySelectedView(title: dateFormattedString(log.date))))
//                            print("Certified tapped for \(dateFormattedString(log.date))")
//                        }) {
//                            Text("Certified")
//                                .foregroundColor(.green)
//                                .fontWeight(.semibold)
//                                .padding(.horizontal, 12)
//                                .padding(.vertical, 8)
//                                .background(Color.green.opacity(0.1))
//                                .cornerRadius(6)
//                        }
//                    } else {
//                        Button(action: {
//                            navManager.navigate(to: AppRoute.logsFlow(.CertifySelectedView(title: dateFormattedString(log.date))))
//                            print("Uncertified tapped for \(dateFormattedString(log.date))")
//                        }) {
//                            Text("Uncertified")
//                                .foregroundColor(.red)
//                                .fontWeight(.semibold)
//                                .padding(.horizontal, 12)
//                                .padding(.vertical, 8)
//                                .background(Color.red.opacity(0.1))
//                                .cornerRadius(6)
//                        }
//                    }
//                }
//                .contentShape(Rectangle())
//            }
            .onAppear {
                // Debug information
                let allDates = logDates.map { dateFormattedString($0.date) }
                print("All Log Dates:", allDates)
                print("All Certified DB Records Count:", certifiedRecords.count)
                
                // Check if any dates match with full certification criteria
                for log in logDates {
                    let isFullyCertified = isDateFullyCertified(log.date)
                    print("Date: \(log.date) -> Fully Certified: \(isFullyCertified)")
                    
                    // Show detailed certification status for debugging
                    for record in certifiedRecords {
                        if let dbDate = parseDate(record.date) {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            let dbDateString = formatter.string(from: dbDate)
                            
                            if dbDateString == log.date {
                                print("  - DB Record found:")
                                print("    - Date: \(record.date)")
                                print("    - isSynced: \(record.syncStatus)")
                                print("    - isLogCertified: \(record.isCertify)")
                                print("    - All conditions met: \(record.syncStatus == 1 && record.isCertify == "Yes")")
                            }
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden()
    }


    
    // MARK: - Helper Function
    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    private func dateFormattedString(_ date: String) -> String {
        // Since logDates are now already in dd-MM-yyyy format, just return as is
        return date
    }
    
    //MARK: - Today's Working Details
    private func getTodaysWorkingDetails() -> (workedHours: String, availableHours: String, cycleHoursRemaining: String) {
        let dbManager = DatabaseManager.shared
        let today = Date()
        
        // Total worked hours today
        let workedHours = dbManager.totalWorkedHours(for: today)
        let workedHoursFormatted = dbManager.formatTime(workedHours)
        
        // Available hours today (14 hour limit)
        let availableHours = dbManager.availableHoursToday()
        let availableHoursFormatted = dbManager.formatTime(availableHours)
        
        // Cycle hours remaining (70 hour/7 days)
        let cycleHours = dbManager.availableCycleHours(days: 7, limitHours: 70)
        let cycleHoursFormatted = dbManager.formatTime(cycleHours)
        
        return (workedHoursFormatted, availableHoursFormatted, cycleHoursFormatted)
    }
    
    
}

extension String {
    func toDate() -> Date? {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        ]
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                return date
            }
        }
        return nil
    }

}

//#Preview {
//    let sampleEntry = WorkEntry(date: Date(), hoursWorked: 8.0)
//    DailyLogView(title: "Daily Logs", entry: sampleEntry, logs: [DriverLogModel])
//        .environmentObject(NavigationManager())
//}

























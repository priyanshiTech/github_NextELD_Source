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
    
    //MARK: -  Database dates from driverLogs (unique, latest first)
    private var logDates: [LogDate] {
        var dailyLogsDates: [LogDate] = []
        let todayDate = DateTimeHelper.currentDate().asDate(format: .dateOnlyFormat) ?? Date()
        let logs = DatabaseManager.shared.fetchLogs()
        guard let firstLog = logs.first else {
            return dailyLogsDates
        }
        let startOfDay = DateTimeHelper.startOfDay(for: firstLog.startTime)
        var numberOfDay = abs(DateTimeHelper.getNoOfDaysBetween(from: startOfDay, to: todayDate))
        
        if numberOfDay == 0 {
            let currentDate = DateTimeHelper.getStringFromDate(todayDate, format: .dateOnlyFormat)
            dailyLogsDates.append(LogDate(date: currentDate, isMissing: false))
        } else {
            if numberOfDay > 14 {
                numberOfDay = 14
            }
                    
            for dayValue in 0...numberOfDay {
                let date = DateTimeHelper.calendar.date(byAdding: .day, value: -(dayValue), to: todayDate) ?? Date()
                let convertedDate = DateTimeHelper.getStringFromDate(date, format: .dateOnlyFormat)
                dailyLogsDates.append(LogDate(date: convertedDate, isMissing: false))
            }
            
        }
        return dailyLogsDates
     }
    //MARK: - Database records for certification check
    private var certifiedRecords: [CertifyRecord] {
        return CertifyDatabaseManager.shared.fetchAllRecords()
    }
    //MARK: - Check if a date is fully certified (date exists + isSynced = 1 + isLogCertified = "Yes")
    private func isDateFullyCertified(_ logDate: String) -> Bool {
        return certifiedRecords.filter( { $0.date == logDate }).first?.isCertify == "Yes"
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        
//        // print(" Checking certification for date: \(logDate)")
//        
//        for record in certifiedRecords {
//            // Convert DB date to same format for comparison
//            if let dbDate = DateTimeHelper.parseDate(record.date) {
//                let dbDateString = formatter.string(from: dbDate)
//                
//                // print("     Comparing with DB record:")
//                // print("    - DB Date: \(record.date) -> Formatted: \(dbDateString)")
//                // print("    - Log Date: \(logDate)")
//                // print("    - Date Match: \(dbDateString == logDate)")
//                // print("    - isSynced: \(record.syncStatus) (needs to be 1)")
//                // print("    - isLogCertified: \(record.isCertify) (needs to be 'Yes')")
//                
//                // Check all three conditions:
//                // 1. Date matches
//                // 2. isSynced = 1
//                // 3. isLogCertified = "Yes"
//                let dateMatches = dbDateString == logDate
//                let isSynced = record.syncStatus == 1
//                let isCertified = record.isCertify == "Yes"
//                
//                // print("    - All conditions met: \(dateMatches && isSynced && isCertified)")
//                
//                if dateMatches && isSynced && isCertified {
//                    // print("     FULLY CERTIFIED - All conditions met!")
//                    return true
//                } else if dateMatches {
//                    // print("      Date exists but NOT fully certified:")
//                    // print("      - isSynced: \(isSynced)")
//                    // print("      - isLogCertified: \(isCertified)")
//                }
//            }
//        }
//        
        // print("     NOT CERTIFIED - No matching record or conditions not met")
       // return false
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

                    HStack(spacing: 5) {
                        
                        CustomIconButton(iconName: "email_icon", title: "", action: { navManager.navigate(to: AppRoute.HomeFlow.EmailLogs(title: AppConstants.DailyLogs))})
                            .padding()
                        
                        CustomIconButton(iconName: "alarm_icon", title: "", action: { navManager.navigate(to: AppRoute.HomeFlow.RecapHours(title: AppConstants.HourRecap))})
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

            
            // MARK: - List Section
            List {
                ForEach(logDates) { log in
                    HStack {
                        Text(log.date)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                // Navigate to LogsDetails on cell click
//                                let formatter = DateFormatter()
//                                formatter.dateFormat = "dd-MM-yyyy"
//                                if let logDate = formatter.date(from: log.date) {
//                                    
//                                }
                                if let logDate = log.date.asDate(format: .dateOnlyFormat) {
                                    let selectedEntry = WorkEntry(date: logDate, hoursWorked: 0)
                                    navManager.navigate(to: AppRoute.HomeFlow.LogsDetails(title: "Daily Log", entry: selectedEntry))
                                }
                                
                            }

                        let isCertified = isDateFullyCertified(log.date)
                        Button(action: {
                            // Navigate to certify screen on button click
                            navManager.navigate(to: AppRoute.HomeFlow.CertifySelectedView(tittle: dateFormattedString(log.date)))
                            // print("Tapped for \(dateFormattedString(log.date)) → Certified: \(isCertified)")
                        }) {
                            Text(isCertified ? "Certified" : "Uncertified")
                                .foregroundColor(isCertified ? .green : .red)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background((isCertified ? Color.green : Color.red).opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                }
            }

//            .onAppear {
//                // Debug information
//                let allDates = logDates.map { dateFormattedString($0.date) }
//                // print("All Log Dates:", allDates)
//                // print("All Certified DB Records Count:", certifiedRecords.count)
//                
//                // Check if any dates match with full certification criteria
//                for log in logDates {
//                    let isFullyCertified = isDateFullyCertified(log.date)
//                    // print("Date: \(log.date) -> Fully Certified: \(isFullyCertified)")
//                    
//                    // Show detailed certification status for debugging
//                    for record in certifiedRecords {
//                        if let dbDate = DateTimeHelper.parseDate(record.date) {
//                            let formatter = DateFormatter()
//                            formatter.dateFormat = "dd-MM-yyyy"
//                            let dbDateString = formatter.string(from: dbDate)
//                            
//                            if dbDateString == log.date {
//                                // print("  - DB Record found:")
//                                // print("    - Date: \(record.date)")
//                                // print("    - isSynced: \(record.syncStatus)")
//                                // print("    - isLogCertified: \(record.isCertify)")
//                                // print("    - All conditions met: \(record.syncStatus == 1 && record.isCertify == "Yes")")
//                            }
//                        }
//                    }
//                }
//            }
        }.navigationBarBackButtonHidden()
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
        let workedHours = dbManager.getTodaysWork().totalWorkedToday
        let workedHoursFormatted = workedHours.timeString
        
        // Available hours today (14 hour limit)
        let availableHours = dbManager.getTodaysWork().remainingWorkedToday
        let availableHoursFormatted = availableHours.timeString
        
        // Cycle hours remaining (70 hour/7 days)
        let cycleHours = dbManager.getRemainingCycleTime().timeString
        let cycleHoursFormatted = cycleHours
        
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























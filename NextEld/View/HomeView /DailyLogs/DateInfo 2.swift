//
//  DateInfo.swift
//  NextEld
//
//  Created by Priyanshi   on 17/05/25.
//

import Foundation
import SwiftUI

struct WorkEntry: Identifiable, Hashable, Codable {
    let id: UUID
    let date: Date
    let hoursWorked: Double
    
    init(date: Date, hoursWorked: Double) {
        self.id = UUID()
        self.date = date
        self.hoursWorked = hoursWorked
    }
}

struct DateStepperView: View {
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
            dailyLogsDates.append(LogDate(date: todayDate, isMissing: false))
        } else {
            if numberOfDay > 14 {
                numberOfDay = 14
            }
                    
            for dayValue in 0...numberOfDay {
                let date = DateTimeHelper.calendar.date(byAdding: .day, value: -(dayValue), to: todayDate) ?? Date()
                dailyLogsDates.append(LogDate(date: date, isMissing: false))
            }
            
        }
        return dailyLogsDates
     }
    
    
    
       @Binding var currentDate: Date
// private var currentDate = Date()
    var body: some View {
        
        HStack(spacing: 20) {
            Button(action: {
                let lastDay = DateTimeHelper.calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                if logDates.contains(where: { $0.date == lastDay }) {
                    currentDate = lastDay
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor( Color(uiColor:.black))
            }
            Spacer()
            
            Text(currentDate.toLocalString(format: .dateOnlyFormat))
                .foregroundColor( Color(uiColor:.black))
                .bold()
            
            Spacer()
            
            Button(action: {
                let calendar = DateTimeHelper.calendar
                let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                let todayDate = DateTimeHelper.currentDate().asDate(format: .dateOnlyFormat) ?? Date()
                if nextDate <= todayDate {
                    currentDate = nextDate
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor( Color(uiColor:.black))
            }
        }
        .padding()
    }
    
    //MARK: -  Formatter showing only date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // dd MMMM, yyyy
        

        return formatter.string(from: currentDate)
    }
}
//MARK: Global function
import Foundation

struct DateUtils {
    static func dateFromRaw(_ rawDate: String, inputFormat: String = "ddMMyyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        return formatter.date(from: rawDate)
    }
    static func formatDate(_ date: Date, format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}


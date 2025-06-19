//
//  DateInfo.swift
//  NextEld
//
//  Created by Priyanshi   on 17/05/25.
//

import Foundation
import SwiftUI

struct WorkEntry: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let hoursWorked: Double
}

func generateWorkEntries() -> [WorkEntry] {
    var entries: [WorkEntry] = []
    let calendar = Calendar.current
    let today = Date()

    // MARK: - Get the range of days in the current month
    if let range = calendar.range(of: .day, in: .month, for: today) {
        
        //MARK: -  Get the first day of the current month
        var components = calendar.dateComponents([.year, .month], from: today)
        components.day = 1

        if let firstDayOfMonth = calendar.date(from: components) {
            for day in range {
                if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                    let hours = Double.random(in: 4...10)
                    entries.append(WorkEntry(date: date, hoursWorked: hours))
                }
            }
        }
    }

    return entries
}

struct DateStepperView: View {
       @Binding var currentDate: Date
// private var currentDate = Date()
    var body: some View {
        
        HStack(spacing: 20) {
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            Spacer()
            
            
            //MARK: -  Date label (only date, no weekday)
           // Text(formattedDate)
            Text(DateUtils.formatDate(currentDate, format: "dd-MM-yyyy"))


                .foregroundColor(.black)
                .bold()
            Spacer()
            
            
            //MARK: -  Right chevron - increment date
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
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


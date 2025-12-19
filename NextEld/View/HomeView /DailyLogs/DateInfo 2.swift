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
       @Binding var currentDate: Date
// private var currentDate = Date()
    var body: some View {
        
        HStack(spacing: 20) {
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor( Color(uiColor:.black))
            }
            Spacer()
            
            Text(DateUtils.formatDate(currentDate, format: "dd-MM-yyyy"))
                .foregroundColor( Color(uiColor:.black))
                .bold()
            
            Spacer()
            
            Button(action: {
                let calendar = Calendar.current
                let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                let today = calendar.startOfDay(for: Date())
                if calendar.startOfDay(for: nextDate) <= today {
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


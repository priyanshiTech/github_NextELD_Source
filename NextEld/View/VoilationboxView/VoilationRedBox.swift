//
//  VoilationRedBox.swift
//  NextEld
//
//  Created by priyanshi   on 18/12/25.
//

import Foundation
import SwiftUI

// MARK: - Violations Section View

struct ViolationsSectionView: View {
    let violations: [DriverLogModel]
    
    private var violationOnlyLogs: [DriverLogModel] {
        violations.filter {
            $0.status.lowercased().contains("violation")
        }
    }
    
    var body: some View {
        if !violationOnlyLogs.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Violations -")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 2)
                
                //  2-column Android-style layout
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(violationOnlyLogs, id: \.id) { violation in
                        ViolationBoxView(violation: violation)
                            .padding(4)   //  IMPORTANT: separates boxes
                    }
                }
                
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
}


struct ViolationBoxView: View {
    let violation: DriverLogModel
    
    var body: some View {
        HStack(spacing: 0) {
            
            // LEFT: Violation message
            Text(formatViolationMessage(violation))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.red)
                .lineLimit(3)                    //prevent tall boxes
                .fixedSize(horizontal: false, vertical: true)
            //.padding(.vertical, 6)//⬇ reduced
                .padding(.horizontal, 2)
                .frame(width:82, height: 50, alignment: .leading)
            Rectangle()
                .fill(Color.red)
                .frame(width: 1)
            
            Text(formatTimestamp(violation.startTime))
       //  Text(DateTimeHelper.formatDateToLocalTime(violation.startTime))
                .font(.caption)
                .foregroundColor(.red)
                .padding(10)
                .frame(width:82, alignment: .leading)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.red, lineWidth: 1.5)
        )
        .cornerRadius(6)
    }
    
    //  Your existing logic (UNCHANGED)
    private func formatViolationMessage(_ violation: DriverLogModel) -> String {
        let status = violation.status.lowercased()
        let dutyType = violation.dutyType
        
        if status.contains("violation") {
            if status.contains("onduty") || dutyType.lowercased().contains("onduty") {
                return "Your onduty time has been exceeded to 14 hours"
            } else if status.contains("ondrive") || dutyType.lowercased().contains("ondrive") || dutyType.lowercased().contains("drive") {
                return "Your drive time has been exceeded to 11 hours"
            } else if status.contains("continue") || dutyType.lowercased().contains("continue") {
                return "You are continuously driving for 8 hours"
            } else {
                return dutyType
            }
        }
        return violation.status
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM, HH:mm:ss"
        return formatter.string(from: date)
    }

}


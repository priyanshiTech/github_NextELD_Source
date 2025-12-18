//
//  ViolationsSectionView.swift
//  NextEld
//
//  Created on 15/12/25.
//

import SwiftUI

struct ViolationsSectionView: View {
    let violations: [DriverLogModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Violations -")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            // Grid layout for violation boxes (2 columns)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(Array(violations.enumerated()), id: \.offset) { index, violation in
                    ViolationBoxView(violation: violation)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
}

struct ViolationBoxView: View {
    let violation: DriverLogModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Violation message
            Text(formatViolationMessage(violation))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            
            Spacer()
            
            // Timestamp
            Text(formatTimestamp(violation.startTime))
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.red)
        .cornerRadius(8)
    }
    
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
                return "Violation(\(dutyType))"
            }
        } else if status.contains("warning") {
            if status.contains("onduty") || dutyType.lowercased().contains("onduty") {
                return "Warning: Your onduty time is approaching 14 hours"
            } else if status.contains("ondrive") || dutyType.lowercased().contains("ondrive") || dutyType.lowercased().contains("drive") {
                return "Warning: Your drive time is approaching 11 hours"
            } else if status.contains("continue") || dutyType.lowercased().contains("continue") {
                return "Warning: You are continuously driving for 8 hours"
            } else {
                return "Warning(\(dutyType))"
            }
        }
        
        return violation.status
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M dd, HH:mm:ss"
        // Format: "M12 18, 01:30:03" style
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let second = Calendar.current.component(.second, from: date)
        return String(format: "M%d %d, %02d:%02d:%02d", month, day, hour, minute, second)
    }
}

#Preview {
    ViolationsSectionView(violations: [])
}


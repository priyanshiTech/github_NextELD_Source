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
            //$0.status.lowercased().contains("Violation")
            $0.status == AppConstants.violation
        }
    }
    
    var body: some View {
        if !violationOnlyLogs.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Violations -")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                //  2-column Android-style layout
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(violationOnlyLogs, id: \.id) { violation in
                        ViolationBoxView(violation: violation)
                    }
                }
            }
        }
    }
}


struct ViolationBoxView: View {
    let violation: DriverLogModel
    
    var body: some View {
        HStack(spacing: 0) {
            // LEFT: Violation message
            Text("\(violation.dutyType)\n\(violation.startTime.toLocalString(format: .dayMonthTime))")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.red)
                .padding(8)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.red, lineWidth: 1.5)
        )
        .cornerRadius(6)
    }
    
    //  Your existing logic (UNCHANGED)
//    private func formatViolationMessage(_ violation: DriverLogModel) -> String {
//        let status = violation.status.lowercased()
//        let dutyType = violation.dutyType
//        
//        if status.contains("voilation") {
//            if status.contains("onduty") || dutyType.lowercased().contains("onduty") {
//                return "Your onduty time has been exceeded to 14 hours"
//            } else if status.contains("ondrive") || dutyType.lowercased().contains("ondrive") || dutyType.lowercased().contains("drive") {
//                return "Your drive time has been exceeded to 11 hours"
//            } else if status.contains("continue") || dutyType.lowercased().contains("continue") {
//                return "You have been  continuously driving for 8 hours"
//            } else {
//                return dutyType
//            }
//        }
//        return violation.status
//    }
    

}


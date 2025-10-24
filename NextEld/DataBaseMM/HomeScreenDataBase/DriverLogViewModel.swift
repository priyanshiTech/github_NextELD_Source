//
//  DriverLogViewModel.swift
//  NextEld
//
//  Created by Priyanshi  on 26/06/25.
//

import Foundation
import SwiftUI
class DriverLogViewModel: ObservableObject {
    @Published var logs: [DriverLogModel] = []

    func loadLogs() {
        logs = DatabaseManager.shared.fetchLogs()
//        print(" Loaded \(logs.count) logs from SQLite")
//        print("⏱ Loaded \(logs.count) logs")
//        logs.forEach {
//            let drive = $0.remainingDriveTime ?? 0
//            let duty = $0.remainingDutyTime ?? 0
//            let weekly = $0.remainingWeeklyTime ?? 0
//
//            print("→ [\($0.status)] Drive: \(drive), Duty: \(duty), Weekly: \(weekly)")
//        }

    }


}
 







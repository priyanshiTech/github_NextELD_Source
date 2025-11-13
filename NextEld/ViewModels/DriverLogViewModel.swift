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
        logs = DatabaseManager.shared.fetchLogs(addWarningAndViolation: true)
    }


}
 







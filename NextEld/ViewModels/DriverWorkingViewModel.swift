//
//  DriverWorkingModel.swift
//  NextEld
//
//  Created by priyanshi on 13/11/25.
//

import Foundation
import SwiftUI
@MainActor

final class DriverWorkingViewModel: ObservableObject {
    @Published var status = ""
    @Published var onDutyTime = ""
    @Published var onDriveTime = ""
    @Published var onSleepTime = ""
    @Published var weeklyTime = ""
    @Published var onBreak = ""
    @Published var message = ""
    @Published var showAlert = false
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?

    func driverWorkingTiming() async -> Bool {
        isSessionExpired = false
        // print("Sending Forget Username Request with Driver Working : \(status)")
        let request = ELDStatusRequest(driverId: AppStorageHandler.shared.driverId ?? 0,
                                       shift: AppStorageHandler.shared.shift,
                                       days: AppStorageHandler.shared.days,
                                       status: status,
                                       onDutyTime: onDutyTime,
                                       onDriveTime: onDriveTime,
                                       onSleepTime: onSleepTime,
                                       weeklyTime:  weeklyTime,
                                       tokenNo: AppStorageHandler.shared.authToken ?? "",
                                       onBreak: onBreak ) // or update field to match actual API

        do {
            let response: ELDStatusResponse = try await NetworkManager.shared.post(.DriverWorkingtime , body: request)
            // print("API Call Succeeded")
            // print(" Message: \(response.message)")
            // print(" Token value: \(response.token ?? "nil")")
            if response.token.lowercased() == "false" {
                SessionManagerClass.shared.clearToken()
                isSessionExpired = true
                // print(" Session expired detected in ForgetUsernameViewModel")
                appRootManager?.currentRoot = .SessionExpireUIView
                return false
            }
            message = response.message
            showAlert = true
            return true
        } catch {
            // print(" API Call Failed: \(error)")
            message = "Something went wrong: \(error.localizedDescription)"
            showAlert = true
            return false
        }
    }
}

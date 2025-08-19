//
//  LogOutAPiViewModel.swift
//  NextEld
//
//  Created by priyanshi  on 18/08/25.
//

import Foundation
import SwiftUI

@MainActor
class APILogoutViewModel: ObservableObject {
    @Published var apiMessage: String = ""
    @Published var status: String = ""
    @Published var token: String = ""
    @Published var employeeId: Int = 0
    @Published var loginDateTime: Int64 = 0
    @Published var logoutDateTime: Int64 = 0
 
    func callLogoutAPI() async {
        //  Prepare request
        let request = LogoutRequestModel(
            employeeId: DriverInfo.driverId ?? 0,
            loginDateTime: DriverInfo.loginDateTime ?? (CurrentTimeHelperStamp.currentTimestamp),
            tokenNo: DriverInfo.authToken,
            logoutDateTime: CurrentTimeHelperStamp.currentTimestamp
        )
        print("Request For *****LogoutAPI*****: \(request)")

        do {
            // Call API
            let response: LogoutResponse = try await NetworkManager.shared.post(
                .LogoutAPI,
                body: request
            )

            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Success"
                self.status = response.status ?? ""
                self.token = response.result?.tokenNo ?? ""
                self.employeeId = response.result?.employeeId ?? 0
                self.loginDateTime = response.result?.loginDateTime ?? 0
                self.logoutDateTime = response.result?.logoutDateTime ?? 0
            } else {
                self.apiMessage = response.message ?? "Failed"
                self.status = response.status ?? ""
            }
        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
        }
    }
}

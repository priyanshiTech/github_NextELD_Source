//
//  loginlogAPIViewModel.swift
//  NextEld
//
//  Created by priyanshi  on 18/08/25.
//
import Foundation
import SwiftUI

@MainActor
class APILoginLogViewModel: ObservableObject {
    @Published var apiMessage: String = ""
    @Published var status: String = ""
    @Published var result: String = ""

    
    
    func callLoginLogUpdateAPI() async {

        
        let request = LoginLogRequestModel(
            driverId: DriverInfo.driverId ?? 0,
            loginDateTime: DriverInfo.loginDateTime ?? 101,
            timestamps: CurrentTimeHelperStamp.currentTimestamp
        )
        print("Request For *****LoginLogAPI*****:\(request)")


        do {
            let response: LoginLogResponce = try await NetworkManager.shared.post(
                .LoginLogAPI,
                body: request
            )

            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Success"
                self.status = response.status ?? ""
                self.result = response.result ?? ""
            } else {
                self.apiMessage = response.message ?? "Failed"
                self.status = response.status ?? ""
            }
        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
        }
    }
}

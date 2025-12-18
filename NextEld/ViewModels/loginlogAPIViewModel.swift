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

        let currentTimeStamp: Int = Int(CurrentTimeHelperStamp.currentTimestamp)
        let request = LoginLogRequestModel(
            driverId: AppStorageHandler.shared.driverId ?? 0,
            loginDateTime: AppStorageHandler.shared.loginDateTime ?? 0,
            timestamp: currentTimeStamp
        )
    print("Request For *****LoginLogAPI*****:\(request)")
        AppStorageHandler.shared.loginDateTime = request.timestamp
        print("Request For correct time stamp *****: \(AppStorageHandler.shared.loginDateTime)")



        do {
            let response: LoginLogResponce = try await NetworkManager.shared.post(
                .LoginLogAPI,
                body: request
            )
            
            let dateTime = Date(timeIntervalSince1970: TimeInterval(currentTimeStamp)).toLocalString().asDate() ?? DateTimeHelper.currentDateTime()
            

            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Success"
                self.status = response.status ?? ""
                self.result = response.result ?? ""
                
                // Manually created first log
               
                DatabaseManager.shared.saveTimerLog(
                    status: "Login",
                    startTime: dateTime,
                    dutyType: "Login",
                    remainingWeeklyTime: 0,
                    remainingDriveTime: 0,
                    remainingDutyTime: 0,
                    remainingSleepTime: 0,
                    breakTimeRemaning: 0,
                    lastSleepTime: 0,
                    RemaningRestBreak: "0.0",
                    origin: OriginType.unidentified.description)
             
                
            } else {
                self.apiMessage = response.message ?? "Failed"
                self.status = response.status ?? ""
            }
        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
        }
    }
}

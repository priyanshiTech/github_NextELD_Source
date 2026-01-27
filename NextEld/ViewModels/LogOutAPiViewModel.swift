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
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
 
    func callLogoutAPI() async -> Bool {
        isSessionExpired = false
        //  Prepare request
//        var loginDateTime = 0
//        if let lastLoginRecord = DatabaseManager.shared.getLastRecordOfDriverLogs(filterTypes: [.login], applyBaseFilter: false) {
//            loginDateTime = Int(lastLoginRecord.timestamp)
//        }
        
        
       // let logintime =  AppStorageHandler.shared.loginDateTime!
        let request = LogoutRequestModel(
            employeeId: AppStorageHandler.shared.driverId ?? 0,
            loginDateTime:  AppStorageHandler.shared.loginDateTime ?? 0 ,
            tokenNo: AppStorageHandler.shared.authToken ?? "" ,
            logoutDateTime: CurrentTimeHelperStamp.currentTimestamp
        )
         print("Request For *****LogoutAPI*****: \(request)")

        do {
            
            // Call API
            let response: LogoutResponse = try await NetworkManager.shared.post(
                .LogoutAPI,
                body: request
            )

            // print(" Logout API Response token: \(response.token ?? "nil")")
//            if let tokenValue = response.token?.lowercased(), tokenValue == "false" {
//                
//                isSessionExpired = true
//                // print("  Session expired detected during logout - navigating to SessionExpireUIView")
//                appRootManager?.currentRoot = .SessionExpireUIView
//                return false
//            }

            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Success"
                self.status = response.status ?? ""
                self.token = response.result?.tokenNo ?? ""
                self.employeeId = response.result?.employeeId ?? 0
                self.loginDateTime = response.result?.loginDateTime ?? 0
                self.logoutDateTime = response.result?.logoutDateTime ?? 0
                return true
            } else {
                self.apiMessage = response.message ?? "Failed"
                self.status = response.status ?? ""
                return false
            }
        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
            return false
        }
    }
}

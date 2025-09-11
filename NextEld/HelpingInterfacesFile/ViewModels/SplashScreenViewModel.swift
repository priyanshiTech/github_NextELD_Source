//
//  SplashScreenViewModel.swift
//  NextEld
//
//  Created by priyanshi on 02/09/25.
//

import Foundation
import SwiftUI

@MainActor
class APITokenUpdateViewModel: ObservableObject {
    @Published var apiMessage: String = ""
    @Published var status: String = ""
    @Published var result: String = ""
    

    
    
    @MainActor
    func callSplashUpdateAPI() async -> Bool {
        let request = DriverRequest(
            driverId: DriverInfo.driverId ?? 0,
            tokenNo: DriverInfo.authToken
        )

        print("Request For *****TokenUpdateAPI*****: \(request)")

        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .SpalshDataAPI,
                body: request
            )
            print("Splash API Response: \(response)")

            if response.status == "SUCCESS", let result = response.result {
                self.apiMessage = response.message ?? "Success"
                self.status = response.status ?? ""
                self.result = result.tokenNo ?? ""
                saveToUserDefaults(result: result)
                return true   //  success
            } else {
                self.apiMessage = response.message ?? "Failed"
                self.status = response.status ?? ""
                return false  //  failed
            }
        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
            return false  // error
        }
    }

    private func saveToUserDefaults(result: TokenResult) {
        let defaults = UserDefaults.standard
        
        //  Required fields
        defaults.set(result.employeeId, forKey: "KEY_USER_ID")
        defaults.set(result.email, forKey: "KEY_USER_EMAIL")
        defaults.set(result.firstName, forKey: "KEY_FIRST_NAME")
        defaults.set(result.lastName, forKey: "KEY_LAST_NAME")
        defaults.set("\(result.firstName ?? "") \(result.lastName ?? "")", forKey: "KEY_USER_NAME")
        defaults.set(result.clientName, forKey: "KEY_COMPANY")
        defaults.set(result.clientId, forKey: "KEY_CLIENT_ID")
        
        //  Vehicle + MAC
        if let vehicleId = result.vehicleId, vehicleId != 0 {
            defaults.set(vehicleId, forKey: "KEY_VEHICLE_ID")
        }
        if let vehicleNo = result.vehicleNo, !vehicleNo.isEmpty {
            defaults.set(vehicleNo, forKey: "KEY_VEHICLE_NUM")
        }
        if let mac = result.macAddress, !mac.isEmpty, mac.lowercased() != "null" {
            defaults.set(mac, forKey: "KEY_DEVICE_MAC")
        }
        
        //  Flags (personal use, yard moves, etc.)
        defaults.set(result.personalUse, forKey: "KEY_IS_PERSONAL_USE_ACTIVE")
        defaults.set(result.yardMoves, forKey: "KEY_IS_YARD_MOVE_ACTIVE")
        
        //  Optional loginDateTime
        if let loginTime = result.loginDateTime {
            defaults.set(loginTime, forKey: "KEY_LOGIN_TIME")
        }
        
        //  Save token
        defaults.set(result.tokenNo, forKey: "KEY_AUTH_TOKEN")
        defaults.synchronize()
        print(" UserDefaults updated with API response")
    }
}





































/*class APITokenUpdateViewModel: ObservableObject {
    @Published var apiMessage: String = ""
    @Published var status: String = ""
    @Published var result: String = ""
    
    func callTokenUpdateAPI() async {
        let request = DriverRequest(
            driverId: DriverInfo.driverId ?? 0,
            tokenNo: DriverInfo.authToken
        )
        
        print("Request For *****TokenUpdateAPI*****: \(request)")
        
        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .SpalshDataAPI,
                body: request
            )
            
            if response.status == "SUCCESS" {
                self.apiMessage = response.message ?? "Success"
                self.status = response.status ?? ""
                self.result = response.result
            } else {
                self.apiMessage = response.message ?? "Failed"
                self.status = response.status ?? ""
            }
        } catch {
            self.apiMessage = "Error: \(error.localizedDescription)"
        }
    }
}*/

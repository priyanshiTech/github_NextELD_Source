//
//  ViewDriveringDtatusBydateModel.swift
//  NextEld
//
//  Created by priyanshi on 11/08/25.
//

import Foundation
import SwiftUI

struct DriverStatusRequest: Codable {
    let driverId: String
    let dateTime: String
    let tokenNo: String
}


@MainActor
class DriverStatusViewModel: ObservableObject {
    @Published var data: DriverStatusResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    private let networkManager: NetworkManager
       
       init(networkManager: NetworkManager) {
           self.networkManager = networkManager
       }
       

    func fetch(driverId: String, date: Date, token: String) async {
        isLoading = true
        errorMessage = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)

        let requestBody = DriverStatusRequest(
            driverId: driverId,
            dateTime: dateString,
            tokenNo: token
        )

        do {
            let response: DriverStatusResponse = try await NetworkManager.shared.post(
                .viewdriveringstatusbydate,
                body: requestBody
            )
            
            // Check if API returned FAIL status or null result
            if let status = response.status, status.uppercased() == "FAIL" {
                // API explicitly returned FAIL status
                self.data = nil
                self.errorMessage = response.message ?? "No record found."
                print("⚠️ API returned FAIL status: \(response.message ?? "No record found.")")
            } else if response.result == nil || response.result?.isEmpty == true {
                // Result is null or empty array
                self.data = nil
                self.errorMessage = response.message ?? "No data available for the selected date."
                print("⚠️ API returned null/empty result: \(response.message ?? "No data available")")
            } else {
                // Success case - data is available
                self.data = response
                self.errorMessage = nil
                print("✅ API returned success with \(response.result?.count ?? 0) record(s)")
            }
        } catch {
            self.data = nil
            self.errorMessage = error.localizedDescription
            print("❌ API call failed with error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}




























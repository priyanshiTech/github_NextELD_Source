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
            self.data = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}





























/*import Foundation

struct DriverStatusRequest: Codable {
    let driverId: String
    let dateTime: String
    let tokenNo: String
}

import Foundation

@MainActor
class DriverStatusViewModel: ObservableObject {
    @Published var response: DispatchStatusView?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchDriverStatus() async {
        isLoading = true
        errorMessage = nil
        
        // Use current date as timestamp in milliseconds
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        
        let requestBody = DriverStatusRequest(
            driverId: "17",
            dateTime: "\(timestamp)", // API expects timestamp
            tokenNo: "3b790c5b-4f90-48ec-b0a3-ab026d9fc495"
        )
        
        do {
            let result: DispatchStatusView = try await NetworkManager.shared.post(
                .viewdriveringstatusbydate,
                body: requestBody
            )
            self.response = result
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
*/

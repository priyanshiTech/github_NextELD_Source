//
//  DisConnetedViewModel.swift
//  NextEld
//
//  Created by priyanshi on 21/08/25.
//

import Foundation
import SwiftUI

@MainActor
class DeviceStatusViewModel: ObservableObject {
    @Published var responseMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // Call API to update device status
    func updateDeviceStatus(status: String) async {
        isLoading = true
        errorMessage = nil
        responseMessage = nil

        let requestBody = DeviceStatusRequest(
            driverId: DriverInfo.driverId ?? 0,
            tokenNo: DriverInfo.authToken,
            status: status
        )

        do {
            let response: DeviceStatusResponse = try await networkManager.post(
                .ConnectdDisConnectedAPI,  
                body: requestBody
            )
            
            if response.status == "SUCCESS" {
                self.responseMessage = response.message
            } else {
                self.errorMessage = response.message
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

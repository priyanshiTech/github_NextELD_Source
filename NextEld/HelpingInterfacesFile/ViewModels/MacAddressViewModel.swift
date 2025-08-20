//
//  MacAddressViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
import Foundation
import SwiftUI

@MainActor
class AddMacAddressViewModel: ObservableObject {
    @Published var responseMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Call API to Add MAC Address
    func addMacAddress(driverId: Int,
                       vehicleId: Int,
                       macAddress: String = "",
                       modelNo: String = "",
                       version: String = "",
                       serialNo: String = "") async {
        
        isLoading = true
        errorMessage = nil
        responseMessage = nil

        let requestBody = AddMacAddressRequest(
            macAddress: macAddress,
            driverId: driverId,
            tokenNo: DriverInfo.authToken,   // assuming you have DriverInfo like your EmployeeRulesViewModel
            vehicleId: vehicleId,
            modelNo: modelNo,
            version: version,
            serialNo: serialNo
        )

        do {
            let response: AddMacAddressResponse = try await networkManager.post(
                .MacAddress,   
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

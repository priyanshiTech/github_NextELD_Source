//
//  MacAddressViewModel.swift
//  NextEld
//
//  Created by priyanshi on 20/08/25.
//

import Foundation
import Foundation
import SwiftUI

@MainActor
class AddMacAddressViewModel: ObservableObject {
    @Published var responseMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?


    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // Call API to Add MAC Address
    func addMacAddress(
        
        macAddress: String = "",
        modelNo: String = "",
        version: String = "",
        serialNo: String = "",
        vehicleId: Int) async -> Bool {
        
        // Reset session expired flag at start of each API call
        isSessionExpired = false
        
        isLoading = true
        errorMessage = nil
        responseMessage = nil

        let requestBody = AddMacAddressRequest(
            macAddress: macAddress,
            driverId: AppStorageHandler.shared.driverId ?? 0,
            tokenNo: AppStorageHandler.shared.authToken ?? "",
            vehicleId: vehicleId  ,
            modelNo: modelNo,
            version: version,
            serialNo: serialNo
        )

        do {
            let response: AddMacAddressResponse = try await networkManager.post(
                .MacAddress,   
                body: requestBody
            )
            
            // print(" AddMacAddressViewModel - API Response received")
            // print(" Response token value: \(response.token)")
            
            // Check if token is false - session expired (check FIRST, before any other processing)
            if response.token.lowercased() == "false" {
                // Session expired - token is false
                SessionManagerClass.shared.clearToken()
                isSessionExpired = true
                appRootManager?.currentRoot = .SessionExpireUIView
                // print("  Session expired - token is false, navigating to SessionExpireUIView")
                isLoading = false
                return false
            }
            
            // If token is true or valid, proceed with normal flow
            if response.status == "SUCCESS" {
                self.responseMessage = response.message
            } else {
                self.errorMessage = response.message
            }

        } catch {
            self.errorMessage = error.localizedDescription
            // print(" AddMacAddressViewModel - API Error: \(error.localizedDescription)")
            isLoading = false
            return false
        }

        isLoading = false
        return true
    }
}

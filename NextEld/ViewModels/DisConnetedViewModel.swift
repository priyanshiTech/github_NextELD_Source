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
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // Call API to update device status
    func updateDeviceStatus(status: String) async -> Bool {
        // Reset session expired flag at start of each API call
        isSessionExpired = false
        
        isLoading = true
        errorMessage = nil
        responseMessage = nil

        let requestBody = DeviceStatusRequest(
            driverId: AppStorageHandler.shared.driverId ?? 0,
            tokenNo: AppStorageHandler.shared.authToken ?? "" ,
            status: status
        )
        
    

        do {
            let response: DeviceStatusResponse = try await networkManager.post(
                .ConnectdDisConnectedAPI,  
                body: requestBody
            )
            
            // print(" DeviceStatusViewModel - API Response received")
            // print(" Response token value: \(response.token)")
            
            // Check if token is false - session expired
           
            
            if response.status == "SUCCESS" {
                self.responseMessage = response.message
                
            
            } else  if response.token.lowercased() == "false" {
                // Session expired - token is false
                SessionManagerClass.shared.clearToken()
                isSessionExpired = true
                // print("  Session expired detected - token is false")
                // print("  appRootManager is \(appRootManager != nil ? "set" : "nil")")
                appRootManager?.currentRoot = .SessionExpireUIView
                // print("  Navigating to SessionExpireUIView")
                isLoading = false
                return false
            } else {
                self.errorMessage = response.message
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
        return true
    }
}

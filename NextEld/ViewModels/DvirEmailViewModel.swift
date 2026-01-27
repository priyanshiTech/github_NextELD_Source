//
//  DvirEmailViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
import SwiftUI

@MainActor
class DVIRAPIViewModel: ObservableObject {
 //   @Published var dvirResults: [String] = []   // Adjust type later if "result" contains objects
    @Published var dvirResults: [DVIREmailModel] = []

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?
    
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetch DVIR Data
    func fetchDVIRData(fromDate: String, toDate: String, email: String) async -> Bool {
        
        // Reset session expired flag at start of each API call
        isSessionExpired = false
        isLoading = true
        errorMessage = nil
        successMessage = nil

        let requestBody = ReportRequestModel(
            
            clientId: AppStorageHandler.shared.clientId ?? 0,
            driverId: AppStorageHandler.shared.driverId ?? 0,
            fromDate: fromDate,
            toDate: toDate,
            email: email,
            tokenNo: AppStorageHandler.shared.authToken ?? ""
        )

        do {
            let response: DVIRResponseModel = try await networkManager.post(
                .EmailDVirAPI,
                body: requestBody
            )
            
            // print(" DVIRAPIViewModel - API Response received")
            // print(" Response token value: \(response.token)")

            // Check if token is false - session expired (check FIRST, before any other processing)
            if response.token?.lowercased() == "false" {
                // Session expired - token is false
                
                isSessionExpired = true
                // print("  Session expired detected - token is false")
                // print("  appRootManager is \(appRootManager != nil ? "set" : "nil")")
                appRootManager?.currentRoot = .SessionExpireUIView
                isLoading = false
                return false
            }

            
  
            // If token is true or valid, proceed with normal flow
            if response.status == "SUCCESS" {
                
                self.dvirResults = response.result
                
                
                self.successMessage = "DVIR Data Information Send Successfully"
                //response.message
            } else {
                self.errorMessage = response.message
            }
            

        } catch {
            self.errorMessage = error.localizedDescription
            // print(" DVIRAPIViewModel - API Error: \(error.localizedDescription)")
            isLoading = false
            return false
        }

        isLoading = false
        return true
    }
}

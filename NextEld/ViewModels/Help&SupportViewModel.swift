//
//  Help&SupportViewModel.swift
//  NextEld
//
//  Created by priyanshi on 12/08/25.
//

import Foundation
// MARK: - ViewModel
@MainActor
class SupportViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func sendSupportMessage(userMessage: String) async {
        isSessionExpired = false
        isLoading = true
        errorMessage = nil

        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else {
            errorMessage = "Please enter your query."
            isLoading = false
            return
        }
        
        guard let driverId = AppStorageHandler.shared.driverId, driverId != 0 else {
            errorMessage = "Driver information not available."
            isLoading = false
            return
        }
        
        let requestBody = MessageRequestSupportNew(
            driver_id: String(driverId),
            message: trimmedMessage,
            domain_name: API.DominNameNew
        )


        do {
            let response: HelpSupportResponce = try await networkManager.post(
                .HelpSupportInfo,
                body: requestBody
            )
            // print(" Support API Response token: \(response.token ?? "nil")")
            if let tokenValue = response.token?.lowercased(), tokenValue == "false" {
                
                isSessionExpired = true
                // print(" Session expired detected in SupportViewModel")
                // print(" appRootManager is \(appRootManager != nil ? "set" : "nil")")
                appRootManager?.currentRoot = .SessionExpireUIView
                isLoading = false
                return
            }
            if response.status?.uppercased() == "SUCCESS" {
                self.successMessage = response.message ?? "Message sent successfully"
            } else {
                self.errorMessage = response.message ?? "Failed to send message."
            }

        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return
        }
        
        isLoading = false
    }
}

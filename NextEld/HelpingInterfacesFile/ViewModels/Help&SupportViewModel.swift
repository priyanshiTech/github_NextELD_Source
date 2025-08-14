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
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func sendSupportMessage(userMessage: String) async {
        isLoading = true
        errorMessage = nil
        
        let requestBody = MessageRequestSupport(
            companyId: 1, // replace with real value
            driverId: 19, // replace with real value
            message: userMessage,
            tokenNo: "a37b180c-936b-4185-91be-8cbf3b616f7f",
            utcDateTime: Int64(Date().timeIntervalSince1970 * 1000),
            vehicleId: 3
        )
        
        do {
            let response: HelpSupportResponce = try await networkManager.post(
                .HelpSupportInfo,
                body: requestBody
            )
            
            self.successMessage = response.message ?? "Message sent successfully"
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

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
        
//        let requestBody = MessageRequestSupportNew(
//            // driverId:  "\(String(describing: DriverInfo.driverId))",
//            driverId: "\(DriverInfo.driverId)",
//            message: "hello message from Excel end driver testing",
//            companyDomainName: "exceleld.com")
        
        let requestBody = MessageRequestSupportNew(
            driverId: String(DriverInfo.driverId ?? 0),
            message: "hello message from Excel end driver testing",
            companyDomainName: "exceleld.com"
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

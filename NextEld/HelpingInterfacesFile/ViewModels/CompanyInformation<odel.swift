//
//  CompanyInformation<odel.swift
//  NextEld
//
//  Created by priyanshi on 11/08/25.
//

import Foundation
import SwiftUI

struct EmployeeRequest: Codable {
    let employeeId: Int
    let tokenNo: String
}

@MainActor
class EmployeeViewModel: ObservableObject {
    @Published var companyInfo: CompanyInformation?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchEmployeeData(employeeId: Int, tokenNo: String) async {
        isLoading = true
        errorMessage = nil
        
        let requestBody = EmployeeRequest(employeeId: employeeId, tokenNo: tokenNo)
        
        do {
            let response: Company = try await networkManager.post(
                .CompanyDriverInformation,    // Replace with your actual API endpoint
                body: requestBody
            )
            // Take the first record from the result array
            if let firstRecord = response.result?.first {
                self.companyInfo = firstRecord
            } else {
                self.errorMessage = "No company information found."
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}


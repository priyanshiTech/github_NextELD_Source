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
    
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    func fetchEmployeeData(employeeId: Int, tokenNo: String) async  -> Bool{
        isSessionExpired = false
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
                // Check if token is false - session expired (check FIRST, before any other processing)
                if response.token?.lowercased() == "false" {
                          // Session expired - token is false
                          
                          isSessionExpired = true
                          appRootManager?.currentRoot = .SessionExpireUIView
                          // print("  Session expired - token is false, navigating to SessionExpireUIView")
                          isLoading = false
                          return false
                      }

                
                self.companyInfo = firstRecord
            } else {
                self.errorMessage = "No company information found."
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
        return true
    }
}


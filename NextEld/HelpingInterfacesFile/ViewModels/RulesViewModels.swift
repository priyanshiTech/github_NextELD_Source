//
//  RulesViewModels.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
import Foundation
import SwiftUI

@MainActor
class EmployeeRulesViewModel: ObservableObject {
    @Published var employees: [EmployeeRuleResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetch Employee Rules Info
    func fetchEmployeeRules(employeeId: Int, clientId: Int) async {
        isLoading = true
        errorMessage = nil

        let requestBody = EmployeeRulesRequest(
            employeeId: employeeId,
            clientId: clientId,
            tokenNo: DriverInfo.authToken
        )

        do {
            let response: EmployeeResponse = try await networkManager.post(
                .ForRulesAPI,
                body: requestBody
            )

            if !response.result.isEmpty {
                self.employees = response.result
            } else {
                self.errorMessage = response.message
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

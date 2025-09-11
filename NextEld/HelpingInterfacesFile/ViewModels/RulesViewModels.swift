//
//  RulesViewModels.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
import Foundation
import SwiftUI



/*@MainActor
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
            employeeId: DriverInfo.driverId ?? 17,
            clientId: DriverInfo.clientId ?? 1,
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
}*/


import Foundation
import SwiftUI

@MainActor
class EmployViewStatusViewModel: ObservableObject {
    @Published var employees: [EmployeeRule] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetch Employee View Status Info
    func fetchEmployeeStatus(employeeId: Int, clientId: Int) async {
        isLoading = true
        errorMessage = nil

        // Request body (adjust according to API requirements)
        let requestBody = EmployeeRulesRequest(
            employeeId: DriverInfo.driverId ?? employeeId,
            clientId: DriverInfo.clientId ?? clientId,
            tokenNo: DriverInfo.authToken
        )

        do {
            let response: EmployViewStatusResponse = try await networkManager.post(
                .ForRulesAPI,   //  replace with correct endpoint
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

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
            employeeId: AppStorageHandler.shared.driverId ?? employeeId,
            clientId: AppStorageHandler.shared.clientId ?? clientId,
            tokenNo: AppStorageHandler.shared.authToken ?? ""
        )

        do {
            let response: EmployViewStatusResponse = try await networkManager.post(
                .ForRulesAPI,   //  replace with correct endpoint
                body: requestBody
            )

            if !response.result.isEmpty {
                self.employees = response.result
                
                // Persist feature flags for the current driver (or first record as fallback)
                let activeEmployee =
                response.result.first(where: { $0.employeeId == requestBody.employeeId }) ??
                response.result.first
                
                if let employee = activeEmployee {
                    let defaults = UserDefaults.standard
                    defaults.set(employee.personalUse, forKey: "KEY_IS_PERSONAL_USE_ACTIVE")
                    defaults.set(employee.yardMoves, forKey: "KEY_IS_YARD_MOVE_ACTIVE")
                    defaults.set(employee.exempt, forKey: "KEY_IS_EXEMPT_ACTIVE")
                    
                    AppStorageHandler.shared.personalUseActive = employee.personalUse
                    AppStorageHandler.shared.yardMovesActive = employee.yardMoves
                    AppStorageHandler.shared.exempt = employee.exempt
                    
                    print(" Rules View Flags → Personal: \(employee.personalUse), Yard: \(employee.yardMoves), Exempt: \(employee.exempt)")
                }
            } else {
                self.errorMessage = response.message
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

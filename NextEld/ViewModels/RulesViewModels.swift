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
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetch Employee View Status Info
    func fetchEmployeeStatus(employeeId: Int, clientId: Int) async -> Bool {
        // Reset session expired flag at start of each API call
        isSessionExpired = false
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

            // print(" EmployViewStatusViewModel - API Response received")
            // print(" Response token value: \(response.token)")
            // Check if token is false - session expired (check FIRST, before any other processing)
            if response.token.lowercased() == "false" {
                // Session expired - token is false
                
                isSessionExpired = true
                appRootManager?.currentRoot = .SessionExpireUIView
                // print("  Session expired - token is false, navigating to SessionExpireUIView")
                isLoading = false
                return false
            }

            // If token is true or valid, proceed with normal flow
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
                    
                    // print(" Rules View Flags → Personal: \(employee.personalUse), Yard: \(employee.yardMoves), Exempt: \(employee.exempt)")
                }
            } else {
                self.errorMessage = response.message
            }
        } catch {
            self.errorMessage = error.localizedDescription
            // print(" EmployViewStatusViewModel - API Error: \(error.localizedDescription)")
            isLoading = false
            return false
        }
        isLoading = false
        return true
    }
}

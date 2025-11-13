//
//  DefectViewModel.swift
//  NextEld
//
//  Created by priyanshi  on 19/08/25.
//

import Foundation
import SwiftUI

@MainActor
class DefectAPIViewModel: ObservableObject {
    @Published var defects: [ResultDefect] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSessionExpired: Bool = false
    var appRootManager: AppRootManager?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetches defects from API
    func fetchDefects() async -> Bool {
        // Reset session expired flag at start of each API call
        isSessionExpired = false
        
        isLoading = true
        errorMessage = nil

        let requestBody = DefectAPIRequestModel(
            clientId: AppStorageHandler.shared.clientId ?? 0 ,
            defectId: 0,
            driverId: AppStorageHandler.shared.driverId ?? 0,
            tokenNo: AppStorageHandler.shared.authToken ?? ""
        )

        do {
            let response: DefectAPIResponceMdoel = try await networkManager.post(
                .DefectAPIModel,
                body: requestBody
            )
            
            print(" DefectAPIViewModel - API Response received")
            print(" Response token value: \(response.token ?? "nil")")
            
            if let tokenValue = response.token?.lowercased(), tokenValue == "false" {
                SessionManagerClass.shared.clearToken()
                isSessionExpired = true
                print("  Session expired detected - token is false")
                print("  appRootManager is \(appRootManager != nil ? "set" : "nil")")
                appRootManager?.currentRoot = .SessionExpireUIView
                isLoading = false
                return false
            }

            if let records = response.result, !records.isEmpty {
                self.defects = records
            } else {
                self.errorMessage = response.message ?? "No defects found."
            }
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }

        isLoading = false
        return true
    }
}

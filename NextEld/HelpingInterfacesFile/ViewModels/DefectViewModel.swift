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

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetches defects from API
    func fetchDefects() async {
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

            if let records = response.result, !records.isEmpty {
                self.defects = records
            } else {
                self.errorMessage = response.message ?? "No defects found."
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

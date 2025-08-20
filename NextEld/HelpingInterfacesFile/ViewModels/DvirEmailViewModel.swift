//
//  DvirEmailViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
import SwiftUI

@MainActor
class DVIRAPIViewModel: ObservableObject {
    @Published var dvirResults: [String] = []   // Adjust type later if "result" contains objects
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetch DVIR Data
    func fetchDVIRData(fromDate: String, toDate: String, email: String) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        let requestBody = ReportRequestModel(
            driverId: DriverInfo.driverId ?? 0,
            fromDate: fromDate,
            toDate: toDate,
            email: email,
            tokenNo: DriverInfo.authToken
        )

        do {
            let response: DVIRResponseModel = try await networkManager.post(
                .EmailDVirAPI,
                body: requestBody
            )

            if response.status == "SUCCESS" {
                self.dvirResults = response.result ?? []
                self.successMessage = response.message
            } else {
                self.errorMessage = response.message
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

//
//  DisclamerViewModel.swift
//  NextEld
//
//  Created by priyanshi on 15/11/25.
//

import Foundation
import SwiftUI

// MARK: - ViewModel
@MainActor
class DisclamerViewModel: ObservableObject {
    
    @Published var Disclamerdata: DisclaimerResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func Disclamerrecord(driverId: Int) async {
        isLoading = true
        errorMessage = nil

        let requestBody = DisclaimerRequest(driverId: driverId)

        do {
            let response: DisclaimerResponse = try await networkManager.post(
                .DisclamerAPI,
                body: requestBody
            )

            // Directly assign response object
            self.Disclamerdata = response

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

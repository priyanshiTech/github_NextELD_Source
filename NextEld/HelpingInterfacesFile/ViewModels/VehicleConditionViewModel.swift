//
//  VehicleConditionViewModel.swift
//  NextEld
//
//  Created by priyanshi on 03/11/25.
//

import Foundation
import SwiftUI


struct vehicleConditionModel: Codable {
    let clientId: Int
    let vehicleConditionId: Int
   
}

// MARK: - ViewModel
@MainActor
class VConditionViewModel: ObservableObject {
    @Published var conitions: [VehicleConditionResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func vehicleConditionData(clientId: Int, vehicleConditionId: Int) async {
        isLoading = true
        errorMessage = nil

        let requestBody = vehicleConditionModel(
            clientId: AppStorageHandler.shared.clientId ?? 0,
            vehicleConditionId: 0,
           
        )

        do {
            let response: VehicleModel = try await networkManager.post(
                .vehicleConditionApi,
                body: requestBody
            )

            if let records = response.result, !records.isEmpty {
                self.conitions = records
            } else {
                self.errorMessage = "No vehicle data found."
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}



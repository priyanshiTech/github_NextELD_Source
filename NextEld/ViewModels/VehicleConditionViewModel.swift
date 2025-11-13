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
        
        print(" VConditionViewModel - Starting vehicleConditionData API call...")
        print(" Request Parameters:")
        print("   - clientId: \(clientId)")
        print("   - vehicleConditionId: \(vehicleConditionId)")
        print(" API Endpoint: \(API.Endpoint.vehicleConditionApi.url)")

        let requestBody = vehicleConditionModel(
            clientId: AppStorageHandler.shared.clientId ?? 0,
            vehicleConditionId: 0
        )

        do {
            print(" Calling API...")
            let response: VehicleModel = try await networkManager.post(
                .vehicleConditionApi,
                body: requestBody
            )
            
            print("VConditionViewModel - API Response received")
            print("Response status: \(response.status ?? "nil")")
            print(" Response message: \(response.message ?? "nil")")

            if let records = response.result, !records.isEmpty {
                self.conitions = records
                print(" VConditionViewModel - Conditions loaded: \(records.count)")
                print(" Condition names: \(records.compactMap { $0.vehicleConditionName })")
            } else {
                self.errorMessage = "No vehicle data found."
                print(" VConditionViewModel - No conditions found")
            }
        } catch {
            self.errorMessage = error.localizedDescription
            print(" VConditionViewModel - API Error: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print(" Error domain: \(nsError.domain), code: \(nsError.code)")
            }
        }

        isLoading = false
        print("VConditionViewModel - vehicleConditionData completed")
    }
}



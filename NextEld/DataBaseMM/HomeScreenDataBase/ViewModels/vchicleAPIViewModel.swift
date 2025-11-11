//
//  vchicleAPIViewModel.swift
//  NextEld
//
//  Created by priyanshi   on 20/08/25.
//

import Foundation
import SwiftUI

@MainActor
class VehicleInfoViewModel: ObservableObject {
    @Published var vehicles: [VehicleResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    /// Fetch Vehicle Information
    func fetchVehicleInfo() async {
        isLoading = true
        errorMessage = nil
        
        print(" VehicleInfoViewModel - Starting fetchVehicleInfo API call...")
        print(" Request Parameters:")
        print("   - vehicleId: \(AppStorageHandler.shared.vehicleId ?? 0)")
        print("   - clientId: \(AppStorageHandler.shared.clientId ?? 0)")
        print("   - driverId: \(AppStorageHandler.shared.driverId ?? 1)")
        print("   - tokenNo: \(AppStorageHandler.shared.authToken?.prefix(20) ?? "nil")...")
        print(" API Endpoint: \(API.Endpoint.VchicleList.url)")

        let requestBody = VehicleInfoRequest(
            vehicleId: AppStorageHandler.shared.vehicleId ?? 0,
            clientId: AppStorageHandler.shared.clientId ?? 0,
            driverId: AppStorageHandler.shared.driverId ?? 1,
            tokenNo: AppStorageHandler.shared.authToken ?? "",
        )

        do {
            print(" Calling API...")
            let response: VehicleInfoResponse = try await networkManager.post(
                .VchicleList,
                body: requestBody
            )
            
            print(" VehicleInfoViewModel - API Response received")
            print(" Response status: \(response.status ?? "nil")")
            print(" Response message: \(response.message ?? "nil")")

            if let records = response.result, !records.isEmpty {
                self.vehicles = records
                print(" VehicleInfoViewModel - Vehicles loaded: \(records.count)")
                print(" Vehicle numbers: \(records.map { $0.vehicleNo })")
            } else {
                self.errorMessage = response.message
                print(" VehicleInfoViewModel - No vehicles found. Message: \(response.message ?? "nil")")
            }

        } catch {
            self.errorMessage = error.localizedDescription
            print(" VehicleInfoViewModel - API Error: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print(" Error domain: \(nsError.domain), code: \(nsError.code)")
            }
        }

        isLoading = false
        print(" VehicleInfoViewModel - fetchVehicleInfo completed")
    }
}

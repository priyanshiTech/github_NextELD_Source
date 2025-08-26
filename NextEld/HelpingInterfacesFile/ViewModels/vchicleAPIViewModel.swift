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

        let requestBody = VehicleInfoRequest(
            vehicleId: DriverInfo.vehicleId ?? 0,
            clientId: DriverInfo.clientId ?? 0,
            driverId: DriverInfo.driverId ?? 1,
            tokenNo: DriverInfo.authToken
        )

        do {
            let response: VehicleInfoResponse = try await networkManager.post(
                .VchicleList,
                body: requestBody
            )

            if let records = response.result, !records.isEmpty {
                self.vehicles = records
            } else {
                self.errorMessage = response.message
            }

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

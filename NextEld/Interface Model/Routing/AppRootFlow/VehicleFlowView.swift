//
//  VehicleFlowView.swift
//  NextEld
//
//  Created by priyanshi   on 09/10/25.
//

import Foundation
import SwiftUI

struct VehicleFlowView: View {
    @Binding var selectedVehicle: String
    @Binding var vehicleID: Int

    var body: some View {
        NavigationStack {
            NT11ConnectionView() // or some default
                .navigationDestination(for: AppRoute.VehicleFlow.self) { route in
                    switch route {
                    case .ADDVehicle:
                        ADDVehicle(selectedVehicleNumber: $selectedVehicle, VechicleID: $vehicleID)
                    case .AddVichleMode:
                        AddVichleMode(selectedVehicle: $selectedVehicle, selectedVehicleId: $vehicleID)
                    case .AddVehicleForDVIR:
                        AddVehicleForDvir(selectedVehicleNumber: $selectedVehicle, VechicleID: $vehicleID)
                    case .AddDvirScreenView(let selectedVehicle, let selectedRecord, let isFromHome):
                        AddDvirScreenView(
                            selectedVehicle: $selectedVehicle,
                            selectedVehicleId: $vehicleID,
                            selectedRecord: selectedRecord,
                            isFromHome: isFromHome
                        )
                    case .PT30Connection:
                        PT30ConnectionView()
                    case .NT11Connection:
                        NT11ConnectionView()
                    case .trailerScreen:
                        TrailerView(tittle: "Trailer")
                    case .ShippingDocment:
                        ShippingDocView(tittle: "Shipping Document")
                    case .DotInspection(let title):
                        DotInspection(title: title)
                    }
                }
        }
    }
}

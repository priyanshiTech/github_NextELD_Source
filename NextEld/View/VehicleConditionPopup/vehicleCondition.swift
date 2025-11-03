//
//  vehicleCondition.swift
//  NextEld
//
//  Created by priyanshi on 03/11/25.
//

import Foundation
import SwiftUI

//MARK: -  show's in Vechicle condition

struct VehicleConditionPopupView: View {
    @Binding var isPresented: Bool
    @State private var selected: String? = nil
    @EnvironmentObject var vehicleVM: VehicleConditionViewModel
    @StateObject private var viewModel = VConditionViewModel(networkManager: NetworkManager())

    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Spacer()
                Text("Select Vehicle Condition")
                    .font(.headline)
                    .foregroundColor(Color(uiColor: .wine))
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            // MARK: - API DATA SECTION
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.conitions.isEmpty {
                Text("No vehicle conditions found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.conitions, id: \.vehicleConditionId) { condition in
                            HStack {
                                Text(condition.vehicleConditionName ?? "Not Fund")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: selected == condition.vehicleConditionName ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(Color(uiColor: .wine))
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle()) // Make row tappable
                            .onTapGesture {
                                selected = condition.vehicleConditionName
                            }
                            Divider()
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(maxHeight: 250)
            }

            // MARK: - Submit Button
            Button(action: {
                vehicleVM.selectedCondition = selected
                isPresented = false
            }) {
                Text("Add Condition")
                    .frame(maxWidth: 250)
                    .padding()
                    .background(selected == nil ? Color.gray : Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selected == nil)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        // Fetch API Data when popup appears
        .task {
            await viewModel.vehicleConditionData(
                clientId: AppStorageHandler.shared.clientId ?? 0,
                vehicleConditionId: 0
            )
        }
    }
}








/*struct VehicleConditionPopupView: View {
    @Binding var isPresented: Bool
    @State private var selected: String? = nil   // single selection
    @EnvironmentObject var vehicleVM: VehicleConditionViewModel
    @StateObject private var viewModel = VConditionViewModel(networkManager: NetworkManager())

    let conditions = [
        "Vehicle Condition Satisfactory",
        "Vehicle Condition Unsatisfactory"
    ]

    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Spacer()
                Text("Select Vehicle Condition")
                    .font(.headline)
                    .foregroundColor(Color(uiColor: .wine))
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            // Options
            ForEach(conditions, id: \.self) { condition in
                HStack {
                    Text(condition)
                    Spacer()
                    Image(systemName: selected == condition ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(Color(uiColor: .wine))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .contentShape(Rectangle()) // Make whole row tappable
                .onTapGesture {
                    selected = condition
                }
            }

            // Submit
            Button(action: {
                vehicleVM.selectedCondition = selected
                isPresented = false
            }) {
                Text("Add Condition")
                    .frame(maxWidth: 250)
                    .padding()
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selected == nil) // disable until selection made
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .task {
            await viewModel.vehicleConditionData(clientId: AppStorageHandler.shared.clientId ?? 0, vehicleConditionId: 0)
               }
    }
}*/



















































//
//  AddVehicleForDvir.swift
//  NextEld
//
//  Created by priyanshi on 11/09/25.
//

import Foundation
import SwiftUI


struct AddVehicleForDvir: View {
    
    @Binding var selectedVehicleNumber: String
    @Binding var VechicleID: Int

    @EnvironmentObject var navmanager: NavigationManager
    @State private var searchText = ""
    @State private var localSelectedVehicle: String = "" // Local state to track selection
    @State private var localVehicleID: Int = 0 // Local state to track vehicle ID

    @StateObject private var vehicleVM = VehicleInfoViewModel(networkManager: NetworkManager())

    //  Filter ab API ke vehicles par
    var filteredVehicles: [VehicleResult] {
        if searchText.isEmpty {
            return vehicleVM.vehicles
        } else {
            return vehicleVM.vehicles.filter {
                $0.vehicleNo.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack(spacing: 5) {
            // Header
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 30)

            HStack {
                // Back Button (left corner)
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Spacer()
                // Title (center)
                Text("Add Vehicle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                // Empty space so title stays center
                Image(systemName: "arrow.left")
                    .opacity(0) // invisible, for symmetry
                    .imageScale(.large)
            }
            .frame(height: 56)
            .padding(.horizontal)
            .background(Color(uiColor: .wine))

            // Search Bar
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color(uiColor: .wine))
                TextField("Search vehicle", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
            .padding(.horizontal)
            .padding(.vertical, 8)

            // List from API
            List {
                ForEach(filteredVehicles, id: \.vehicleId) { vehicle in
                    Button(action: {
                        // Update both local and binding state immediately and synchronously
                        let vehicleNo = vehicle.vehicleNo.trimmingCharacters(in: .whitespaces)
                        let vehicleId = vehicle.vehicleId
                        
                        // Update bindings FIRST - synchronously
                        selectedVehicleNumber = vehicleNo
                        VechicleID = vehicleId
                        
                        // Then update local state
                        localSelectedVehicle = vehicleNo
                        localVehicleID = vehicleId
                        
                        print("✅ Vehicle selected: '\(vehicleNo)', ID: \(vehicleId)")
                        print("   Binding state - vehicle: '\(selectedVehicleNumber)', ID: \(VechicleID)")
                        print("   Local state - vehicle: '\(localSelectedVehicle)', ID: \(localVehicleID)")
                    }) {
                        HStack {
                            Text(vehicle.vehicleNo)
                            Spacer()
                            // Use local state OR binding for comparison
                            if vehicle.vehicleNo.trimmingCharacters(in: .whitespaces) == localSelectedVehicle || 
                               vehicle.vehicleNo.trimmingCharacters(in: .whitespaces) == selectedVehicleNumber.trimmingCharacters(in: .whitespaces) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(uiColor: .wine))
                            } else {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(PlainListStyle())
            // Submit Button
            Button {
                // CRITICAL: Sync local state to bindings BEFORE navigation
                guard !localSelectedVehicle.isEmpty else {
                    print("⚠️ Submit clicked but no vehicle selected")
                    navmanager.goBack()
                    return
                }
                
                // Update bindings synchronously FIRST - this must happen before navigation
                selectedVehicleNumber = localSelectedVehicle
                VechicleID = localVehicleID
                
                print("✅ Submit: Updated bindings synchronously:")
                print("   selectedVehicleNumber = '\(selectedVehicleNumber)'")
                print("   VechicleID = \(VechicleID)")
                
                // Use Task to ensure binding propagates before navigation
                Task { @MainActor in
                    // Give SwiftUI a moment to process the binding update
                    try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
                    print("🚀 Navigating back now...")
                    navmanager.goBack()
                }
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundColor(.white)
                    .background(Color(uiColor: .wine))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom, 16)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden()
        
        
        .onAppear {
            // Sync local state with binding when view appears
            localSelectedVehicle = selectedVehicleNumber
            localVehicleID = VechicleID
            print("onAppear - Synced from bindings:")
            print("  localSelectedVehicle: '\(localSelectedVehicle)' (from selectedVehicleNumber: '\(selectedVehicleNumber)')")
            print("  localVehicleID: \(localVehicleID) (from VechicleID: \(VechicleID))")
        }
        .onDisappear {
            // Final sync attempt - synchronously update if needed
            if !localSelectedVehicle.isEmpty && (selectedVehicleNumber != localSelectedVehicle || VechicleID != localVehicleID) {
                selectedVehicleNumber = localSelectedVehicle
                VechicleID = localVehicleID
                print("onDisappear: Final sync attempt")
                print("  Set selectedVehicleNumber = '\(localSelectedVehicle)'")
                print("  Set VechicleID = \(localVehicleID)")
            }
            print("View disappearing - Final state:")
            print("  selectedVehicleNumber: '\(selectedVehicleNumber)'")
            print("  localSelectedVehicle: '\(localSelectedVehicle)'")
            print("  VechicleID: \(VechicleID)")
            print("  localVehicleID: \(localVehicleID)")
        }
        .task {
            await vehicleVM.fetchVehicleInfo()
            print("API se aaye vehicles: \(vehicleVM.vehicles.map{$0.vehicleNo})")
            print("API se aaye vehicles ID Number : \(vehicleVM.vehicles.map{$0.vehicleId})")
        }
        
    }

}





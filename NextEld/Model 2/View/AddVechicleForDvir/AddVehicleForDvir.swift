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
    @EnvironmentObject var appRootManager: AppRootManager
    @State private var searchText = ""
    
    @State private var localSelectedVehicle: String = ""
    @State private var localVehicleID: Int = 0
    
    @StateObject private var vehicleVM = VehicleInfoViewModel(networkManager: NetworkManager())

    // MARK: - Filtered List
    var filteredVehicles: [VehicleResult] {
        if searchText.isEmpty {
            return vehicleVM.vehicles
        } else {
            return vehicleVM.vehicles.filter {
                $0.vehicleNo.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 5) {
            
            header
            searchBar
            
            // Vehicle List
            List {
                ForEach(filteredVehicles, id: \.vehicleId) { vehicle in
                    Button {
                        // Update local + bindings together
                        let vehicleNo = vehicle.vehicleNo.trimmingCharacters(in: .whitespaces)
                        localSelectedVehicle = vehicleNo
                        localVehicleID = vehicle.vehicleId
                        
                        selectedVehicleNumber = vehicleNo
                        VechicleID = vehicle.vehicleId

                        AppStorageHandler.shared.vehicleNo = vehicleNo
                        AppStorageHandler.shared.vehicleId = vehicle.vehicleId
                        
                        print("Selected: \(vehicleNo) [ID: \(vehicle.vehicleId)]")
                        
                    } label: {
                        HStack {
                            Text(vehicle.vehicleNo)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            if vehicle.vehicleId == localVehicleID {
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
                if localSelectedVehicle.isEmpty {
                    print("No vehicle selected")
                } else {
                    // Sync one more time before navigating back
                    selectedVehicleNumber = localSelectedVehicle
                    VechicleID = localVehicleID
                    print(" Submitted: \(selectedVehicleNumber) [ID: \(VechicleID)]")
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
            localSelectedVehicle = selectedVehicleNumber
            localVehicleID = VechicleID
            print("onAppear → Restored selection: \(localSelectedVehicle), ID: \(localVehicleID)")
            vehicleVM.appRootManager = appRootManager
        }
        .task {
            print(" AddVehicleForDvir - Starting vehicle list API call...")
            let success = await vehicleVM.fetchVehicleInfo()
            
            // If session expired, do not process further
            if vehicleVM.isSessionExpired {
                print(" Session expired detected in AddVehicleForDvir - staying on SessionExpireUIView")
                return
            }
            
            if success {
                print(" AddVehicleForDvir - Vehicles from API: \(vehicleVM.vehicles.map { $0.vehicleNo })")
                print(" AddVehicleForDvir - Total vehicles: \(vehicleVM.vehicles.count)")
            }
            
            if let error = vehicleVM.errorMessage {
                print(" AddVehicleForDvir - Error: \(error)")
            }
        }
    }
}

// MARK: - Subviews
private extension AddVehicleForDvir {
    
    var header: some View {
        VStack(spacing: 0) {
            Color(uiColor: .wine)
                .frame(height: 30)
                .edgesIgnoringSafeArea(.top)
            
            HStack {
                Button(action: { navmanager.goBack() }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                
                Spacer()
                
                Text("Add Vehicle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.left")
                    .opacity(0)
                    .imageScale(.large)
            }
            .frame(height: 56)
            .padding(.horizontal)
            .background(Color(uiColor: .wine))
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(uiColor: .wine))
            TextField("Search vehicle", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}




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
                ForEach(filteredVehicles) { vehicle in
                    HStack {
                        Text(vehicle.vehicleNo)   //
                        Spacer()
                        if vehicle.vehicleNo == selectedVehicleNumber {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(uiColor: .wine))
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedVehicleNumber = vehicle.vehicleNo
                        VechicleID = vehicle.vehicleId
                        print("Vehicle selected: \(selectedVehicleNumber)")
                        print("Vehicle ID: \(VechicleID)")
                    }
                }
            }
            .listStyle(PlainListStyle())
            // Submit Button
            Button {
                navmanager.goBack()
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
        
        
        .task {
            await vehicleVM.fetchVehicleInfo()
            print("API se aaye vehicles: \(vehicleVM.vehicles.map{$0.vehicleNo})")
            print("API se aaye vehicles ID Number : \(vehicleVM.vehicles.map{$0.vehicleId})")
        }
        
    }
}





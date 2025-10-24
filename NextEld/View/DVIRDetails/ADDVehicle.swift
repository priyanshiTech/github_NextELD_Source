//
//  ADDVehicle.swift
//  NextEld
//
//  Created by Priyanshi on 24/05/25.
//

import SwiftUI


struct ADDVehicle: View {
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













































/*struct ADDVehicle: View {
   

    @Binding var selectedVehicleNumber: String

    @EnvironmentObject var  navmanager: NavigationManager
    @State private var searchText = ""
    @State private var tempSelection: String? // Temporary selection
    @StateObject private var vehicleVM = VehicleInfoViewModel(networkManager: NetworkManager())

    let vehicles = ["1462", "1894", "PB76A7446", "PB29JI556", "1234", "4567", "MP09MP4013"]
    
    var filteredVehicles: [String] {
        if searchText.isEmpty {
            return vehicles
        } else {
            return vehicles.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // Header
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 50)

            
            HStack{
                Text("Add Vehicle")
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .background(Color(uiColor: .wine))
                
            }
            // Search Bar
            HStack {
            
             
                Image(systemName: "envelope.fill")
                    .foregroundColor( Color(uiColor: .wine))
                    .bold()
                TextField("Search vehicle", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // List
            List {
                    ForEach(filteredVehicles, id: \.self) { vehicle in
                        HStack {
                            Text(vehicle)
                            Spacer()
                            if vehicle == selectedVehicleNumber {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor( Color(uiColor: .wine))
                            } else {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedVehicleNumber = vehicle
                            print("vichle selected by user \(String(describing: selectedVehicleNumber))")
                    
                        }
                    }
                }
                
            .listStyle(PlainListStyle())
            
            // MARK: - Submit Button
            Button(action: {
                
                                    navmanager.goBack()
               // print("Submit tapped with: \(selectedVehicle ?? "None")")
                
            }) {
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
        .task {
            //  Call API when view appears
            await vehicleVM.fetchVehicleInfo(vehicleId: 3, clientId: 1)
        }
        .edgesIgnoringSafeArea(.top)
    }
  
}*/

//#Preview {
//    ADDVehicle(selectedVehicle: .constant("1894"))
//}

//
//  ADDVehicle.swift
//  NextEld
//
//  Created by Priyanshi on 24/05/25.
//

import SwiftUI

struct ADDVehicle: View {
   

    @Binding var selectedVehicleNumber: String

    @EnvironmentObject var  navmanager: NavigationManager
    @State private var searchText = ""
    @State private var tempSelection: String? // Temporary selection

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
        .edgesIgnoringSafeArea(.top)
    }
}

//#Preview {
//    ADDVehicle(selectedVehicle: .constant("1894"))
//}

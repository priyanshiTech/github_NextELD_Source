//
//  AddVichleMode.swift
//  NextEld
//
//  Created by Priyanshi on 27/05/25.
//

import SwiftUI


struct AddVichleMode: View {

    @EnvironmentObject var navmanager: NavigationManager
    @Binding var selectedVehicle: String
    
    //  use AddMacAddressViewModel here
    @StateObject private var viewModel = AddMacAddressViewModel(
        networkManager: NetworkManager()
    )
    
    var tittle: String = "Add Vehicle"

    var body: some View {
        VStack(spacing:0){

            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 1)
            
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                        .imageScale(.large)
                }

                Text(tittle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)

                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine).shadow(radius: 1))

            //MARK: -  Vehicle selection
            CardContainer {
                Button(action: {
                    navmanager.navigate(to: .ADDVehicle)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Vehicle")
                                .font(.headline)
                                .foregroundColor(.black)

                            Text("\(selectedVehicle)") // show selected data
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image("pencil").foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(20)

            Button(action: {
                Task {
                    await viewModel.addMacAddress(
                        macAddress: "E0:09:DC:C3:7F:4B", // example values
                        modelNo: "ModelX",
                        version: "1.0",
                        serialNo: "123456"
                    )
                    
                    if viewModel.responseMessage != nil {
                        // Navigate only on success
                        navmanager.navigate(to: .Scanner)
                    }
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: 150)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(10)
                } else {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 150)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            //  Show error or success
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            if let success = viewModel.responseMessage {
                Text(success)
                    .foregroundColor(.green)
                    .padding()
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}
































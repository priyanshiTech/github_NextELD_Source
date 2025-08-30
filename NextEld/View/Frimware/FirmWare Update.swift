//
//  FirmWare Update.swift
//  NextEld
//
//  Created by Priyanshi on 31/05/25.
//

import SwiftUI


struct FirmWare_Update: View {
    
    @EnvironmentObject var navmanager: NavigationManager
    @State var title = "Firmware Update"
    @StateObject var viewModel = FirmwareUpdateViewModel(networkManager: NetworkManager()) // FIXED
    @StateObject private var bleVM = BetteryViewModel()

    
    var body: some View {
        VStack(spacing: 0) {
            
            // Top Bar
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .wine))
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Image("eld_device_img")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .padding(.top, 20)
                    
                    Text("Checking update")
                        .font(.headline)
                        .foregroundColor(Color(uiColor: .wine))
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack {
                            Text("Current Version :").bold()
                            Spacer()
                            Text(viewModel.firmwareInfo?.firmwareVersion ?? "-")
                        }
                        
                        HStack {
                            Text("Available Version :").bold()
                            Spacer()
                            Text(viewModel.firmwareInfo?.firmwareVersion ?? "-")
                        }
                        
                        HStack {
                            Text("Hardware Version :").bold()
                            Spacer()
                            Text(viewModel.firmwareInfo?.hardwareVersion ?? "-")
                        }
                        
//                        HStack {
//                            Text("Battery Charge :").bold()
//                            Spacer()
//                            Text("-") // You don’t have batteryCharge in API
//                        }
                        
                        HStack {
                                     Text("Battery Charge :").bold()
                                     Spacer()
                                     if let battery = bleVM.batteryLevel {
                                         Text("\(battery)%")
                                     } else {
                                         Text("—") // fallback while loading
                                     }
                                 }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    
                    Text("Note: If you want to update eld device, mobile battery should be charge atleast 30% or plugin charger.")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                    Spacer(minLength: 60) // bottom spacing
                
                }
               

            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchFirmwareUpdate()
            }
        }
        .onChange(of: viewModel.firmwareInfo)
        { newValue in
            print("UI saw firmwareInfo update:", newValue as Any)
        }
        Spacer()
    }
}


#Preview {
    FirmWare_Update()
        .environmentObject(NavigationManager())
}



















/*struct FirmWare_Update: View {
    @EnvironmentObject var navmanager: NavigationManager
    @State var tittle = "FirmWare Update"
    @ObservedObject var viewModel = FirmwareUpdateViewModel()
    var body: some View {
        
        VStack(spacing:0){
            
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:2)
                       
            }
            
            HStack {
                Button(action: {
                    navmanager.goBack()
                    
                }) {
                    Image(systemName: "arrow.left")
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
            .frame(height: 40, alignment: .topLeading)
            Spacer(minLength: 20)
            VStack(spacing: 20) {
                           Text(viewModel.infoText)
                               .font(.headline)
                               .multilineTextAlignment(.center)
                               .padding(.top)
                           
                           if viewModel.isUpdateButtonVisible {
                               Button("Update Firmware") {
                                   viewModel.startFirmwareUpdate()
                               }
                               .buttonStyle(.borderedProminent)
                           }
                           
                           if viewModel.isProgressVisible {
                               VStack(spacing: 8) {
                                   ProgressView()
                                   Text("Updating... Please wait")
                                       .font(.subheadline)
                                       .foregroundColor(.gray)
                               }
                               .padding(.top)
                           }
                           
                           Spacer()
                       }
                       .padding()
                       .toolbar {
                           ToolbarItem(placement: .cancellationAction) {
                               Button("Close") {
                                   navmanager.goBack()
                               }
                               .disabled(viewModel.updateInProgress)
                           }
                       }
                   }.navigationBarBackButtonHidden()
                   .onAppear {
                       viewModel.checkForFirmwareUpdate()
                   }
            
        }
    }*/


#Preview {
    FirmWare_Update()
}

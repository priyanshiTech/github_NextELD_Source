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
    @StateObject private var phoneBatteryVM = PhoneBatteryViewModel()

    
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

                        
                        HStack {
                            Text("Battery Charge :").bold()
                            Spacer()
                            Text("\(phoneBatteryVM.batteryLevel)%")
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

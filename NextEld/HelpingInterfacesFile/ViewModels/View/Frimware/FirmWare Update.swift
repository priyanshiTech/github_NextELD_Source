//
//  FirmWare Update.swift
//  NextEld
//
//  Created by Priyanshi on 31/05/25.
//

import SwiftUI

struct FirmWare_Update: View {
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
    }


#Preview {
    FirmWare_Update()
}

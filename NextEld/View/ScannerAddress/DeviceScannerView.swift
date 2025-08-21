//
//  DeviceScannerView.swift
//  NextEld
//
//  Created by Priyanshi on 06/05/25.
//

import SwiftUI

struct DeviceScannerView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    @State private var showScanner = false
    @State private var scannedCode: String?
    @State var tittle:String
    @State var checkboxClick : Bool
    @State var macaddress: String
    
    @StateObject private var deviceStatusVM = DeviceStatusViewModel(
         networkManager: NetworkManager()
     )
    var body: some View {
        
        VStack (spacing: 0) {
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:20)
            }
            HStack {
                Button(action: {
                    navManager.goBack()
                }) {
                    Image(systemName: "arrow.right.arrow.left")
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
            
            
            
            Spacer()
            VStack(alignment:.leading){
                
                Text("Select your Device Type and Enter The ELD Mac address Listed On The Device")
                    .lineLimit(nil)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding()
                
                HStack {
                    CheckboxButton()
                    Text("PT - 30")
                    
                }
                .padding()
                HStack {
                    CheckboxButton()
                    Text("NT - 11")
                    Spacer()
                    
                    Button(action: {showScanner = true}, label: {
                        Image("qr-scan")
                            .padding()
                    })
                }
                .padding()
                HStack{
                    Image("")
                        .foregroundColor(Color(uiColor: .wine))
                    TextField("Type Mac address Here", text: $macaddress)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                Spacer()
            }
            VStack(alignment: .center){
                
                Button("Connect") { }
                    .bold()
                    .frame(width: 300 , height: 40)
                    .buttonStyle(.bordered)
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                
                
//                
//                Button("Continue Disconnect") { navManager.navigate(to: .Home) }
//                    .bold()
//                    .frame(width: 300, height: 40)
//                    .buttonStyle(.bordered)
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//                Spacer()
                
                Button {
                                   Task {
                                       await deviceStatusVM.updateDeviceStatus(status: "Disconnected")
                                       
                                       if deviceStatusVM.responseMessage != nil {
                                           navManager.navigate(to: .Home)
                                       }
                                   }
                               } label: {
                                   if deviceStatusVM.isLoading {
                                       ProgressView()
                                           .frame(width: 300, height: 40)
                                           .background(Color.black)
                                           .cornerRadius(10)
                                           .padding()
                                   } else {
                                       Text("Continue Disconnect")
                                           .bold()
                                           .frame(width: 300, height: 40)
                                           .buttonStyle(.bordered)
                                           .background(Color.black)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                           .padding()
                                   }
                               }
                               
                               //  Show API response/error feedback
                               if let error = deviceStatusVM.errorMessage {
                                   Text(error)
                                       .foregroundColor(.red)
                                       .padding()
                               }
                               if let success = deviceStatusVM.responseMessage {
                                   Text(success)
                                       .foregroundColor(.green)
                                       .padding()
                               }
                   Spacer()
            }
            Spacer()
            
        }.navigationBarBackButtonHidden()
          //MARK:  to Show a Mac Address
            .fullScreenCover(isPresented: $showScanner) {
                _ScannerQR(macaddress: $macaddress)
                    .environmentObject(navManager)
            }

    }
    
}

#Preview {
    DeviceScannerView(tittle: "(Vichle) 1894", checkboxClick: true, macaddress: "")
    
       .environmentObject(NavigationManager())
}

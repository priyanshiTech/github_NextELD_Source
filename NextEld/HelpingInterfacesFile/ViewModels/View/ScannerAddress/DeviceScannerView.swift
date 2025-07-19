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
    var body: some View {
        
        VStack (spacing: 0) {
            ZStack(alignment: .topLeading){
                Color.blue
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
            .background(Color.blue.shadow(radius: 1))
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
                        .foregroundColor(.blue)
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
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                
                
                
                Button("Continue Disconnect") { navManager.navigate(to: .Home) }
                    .bold()
                    .frame(width: 300, height: 40)
                    .buttonStyle(.bordered)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
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

//
//  InformationPacket.swift
//  NextEld
//
//  Created by Priyanshi  on 27/05/25.
//

import SwiftUI

struct InformationPacket: View {

    @State private var showPDF = false

    @EnvironmentObject var navmanager: NavigationManager
    var tittle: String = "Information Packet"
    
    var body: some View {
        
        
        VStack(spacing:0){
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 0)
            
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
            Spacer()
            
            VStack{
                Text("User Manual")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("  The user is Manual  , instruction sheet, and malfunction instruction Sheet can be in electronic form. this is accordance with fedral register titled Regulatory Guidance Concerning Electronic Signature and Documents (76 FR 411)")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                
                Button(action: {
                 //   navmanager.goBack()
                     showPDF = true
                    //MARK:  addiga a new view

                }) {
                    Text("View User Manual")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
                
                Text("Instruction")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text(" In additional the above the above , a supply of blank  driver's records of duty status (RODS) graph - grids sufficient  to records the driver's duty status and other related information for a minimum of 8 days must be Onboard the commercisl motor Vechicle (CMV)")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                
                Button(action: {
                    showPDF = true
                    //MARK:  addiga a new view
                }) {
                    Text("View User Manual")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                Spacer()
                              
            }
            .sheet(isPresented: $showPDF) {
                
                PDFViewerWithHeader(fileName: "eld_instruction", title: "Informtion Packet")
            }

        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    InformationPacket()
}

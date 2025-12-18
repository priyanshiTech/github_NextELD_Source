//
//  InformationPacket.swift
//  NextEld
//
//  Created by Priyanshi  on 27/05/25.
//


import SwiftUI

struct InformationPacket: View {
    @EnvironmentObject var navmanager: NavigationManager
    @State private var selectedPDF: String? = nil
    
    var tittle: String = "Information Packet"
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Color(uiColor: .wine)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 0)
                      
            HStack {
         
                
                Button(action: { navmanager.goBack() }) {
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
            
            VStack {
                // --- User Manual section
                Text("User Manual")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text(" The user manual, instruction sheet, and malfunction instructions can be in electronic form. This is in accordance with the Federal Register titled Regulatory Guidance Concerning Electronic Signatures and Documents (76 FR 411).")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                NavigationLink(
                    destination: PDFViewerWithHeader(
                        fileName: "all_star_manual",
                        title: "Information Packet"
                    )
                ) {
                    Text("View User Manual")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(10)
                }
                .padding()
                
           
                // --- Instruction section
                Text("Instruction")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("In addition to the above, a supply of blank driver’s Records of Duty Status (RODS) graph grids, sufficient to record the driver’s duty status and other related information for a minimum of 8 days, must be onboard the commercial motor vehicle (CMV).")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                NavigationLink(
                    destination: PDFViewerWithHeader(
                        fileName: "all_star_instruction",
                        title: "Information Packet"
                    )
                ) {
                    Text("View Instruction")
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
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationView {
        InformationPacket()
    }
}

#Preview {
    InformationPacket()
}














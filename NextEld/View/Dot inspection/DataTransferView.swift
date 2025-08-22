//
//  DataTransferView.swift
//  NextEld
//
//  Created by priyanshi on 22/08/25.
//

import Foundation
import SwiftUI

struct DataTransferInspectionView: View {
    @State private var officerCode: String = ""
    @EnvironmentObject var navmanager : NavigationManager
    
    var body: some View {
        
        
        VStack (spacing:0){
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:0)
                
            }
            
            HStack {
                Button(action: {
                    navmanager.goBack()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
                Text("Road Side inspection")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            .padding()
            .background( Color(uiColor: .wine).shadow(radius: 1))
            .frame(height: 40, alignment: .topLeading)
            Spacer(minLength: 20)
              
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(Color(uiColor: .wine))
                    Text("Send 8 daily logs via FMCSA data transfer")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                
                // Officer Code Input
                TextField("Enter Officer Code", text: $officerCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Reminder text
                Text("Please remember this will send 8 days of daily logs via FMCSA Data Transfer.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Spacer()
                
                // Send Button
                Button(action: {
                    // Handle data transfer
                    print("Sending data for officer code: \(officerCode)")
                }) {
                    Text("Send Data Transfer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .wine))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden()
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    DataTransferInspectionView()
}

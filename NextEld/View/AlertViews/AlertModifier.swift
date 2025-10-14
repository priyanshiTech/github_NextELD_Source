//
//  AlertModifier.swift
//  NextEld
//
//  Created by Priyanshi on 09/05/25.
//

import Foundation
import SwiftUI

struct CustomPopupAlert: View {
    var title: String
    var message: String
    var onOK: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)

            Text(message)
                .multilineTextAlignment(.center)

            HStack {
                Button("Cancel", action: onCancel)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Button("OK", action: onOK)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background( Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .frame(width: 300)
    }
}
//MARK: -  StatusView for Sleep & Off Duty

struct StatusDetailsPopup: View {
    var statusTitle: String
    var onClose: () -> Void
    var onSubmit: (_ note: String) -> Void
   @StateObject var DVClocationManager = DeviceLocationManager()

    @State private var note: String = ""

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .center){
                    HStack {
                        Text(statusTitle)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: onClose) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(8)
                        }
                    }
                }
                
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Current Location:")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    
                    if let address = DVClocationManager.fullAddress {
                        Text(address)
                            .foregroundColor(Color(uiColor: .wine))
                            .font(.body)
                    } else {
                        Text("Fetching location...")
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Odometer:")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("0.00")
                        .foregroundColor( Color(uiColor: .wine))
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note")
                        .font(.title3)
                        .bold()
                    // .padding()
                    
                    TextField("Enter note", text: $note)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border( Color(uiColor: .wine),width: 1)
                        .frame(height: 40)
                        .cornerRadius(5)
                        .padding()
                    
                    
                }
                
                Button(action: {
                    onSubmit(note)
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background( Color(uiColor: .wine))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
            .padding()
            .frame(width: 330)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
}

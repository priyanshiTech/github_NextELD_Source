//
//  BluetothPopupView.swift
//  NextEld
//
//  Created by priyanshi   on 13/10/25.
//

import Foundation
import SwiftUI


struct BluetothPopupview: View {
    
     @State private var isPopupVisible = false
     @State private var isConnected = false
     @State private var isChecked1 = false
     @State private var isChecked2 = false
    
    
    var body: some View {
        VStack {
            Button(action: {
                self.isPopupVisible.toggle()
            }) {
                Text("Select Device")
                    .padding()
                    .background( Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isPopupVisible) {
                VStack(spacing: 20) {
                    Text("Device Connection")
                        .font(.headline)
                    
                    HStack {
                        Text("Device 1")
                        Spacer()
                        Image(systemName: self.isChecked1 ? "circle.fill" : "circle")
                            .onTapGesture {
                                self.isChecked1.toggle()
                            }
                    }
                    
                    HStack {
                        Text("Device 2")
                        Spacer()
                        Image(systemName: self.isChecked2 ? "circle.fill" : "circle")
                            .onTapGesture {
                                self.isChecked2.toggle()
                            }
                    }
                    
                    Button(action: {
                        self.isConnected.toggle()
                    }) {
                        Text(self.isConnected ? "Connected Now" : "Connect Now")
                            .padding()
                            .background(self.isConnected ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

//MARK: -  bluetoth connected popup

import SwiftUI

struct DeviceSelectionPopup: View {
    @Binding var isPopupVisible: Bool
    @State private var isChecked1 = false
    @State private var isChecked2 = false
    @State private var isConnected = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Selected Device")
                .font(.headline)
                .padding(.bottom, 10)
            
            // Device 1 Checkmark
            HStack {
                Text("PT30")
                Spacer()
                 CheckboxButton()
                    .onTapGesture {
                        self.isChecked1.toggle()
                    }
            }
            
            // Device 2 Checkmark
            HStack {
                Text("NT - 11")
                Spacer()
                Image(systemName: self.isChecked2 ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        self.isChecked2.toggle()
                    }
            }
            
            // Connect Button
            Button(action: {
                self.isConnected.toggle()
            }) {
                Text(self.isConnected ? "Connected Now" : "Connect Now")
                    .padding()
                    .background(self.isConnected ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Close Button
            Button("Close") {
                isPopupVisible = false
            }
            .padding()
        }
        .padding()
    }
}


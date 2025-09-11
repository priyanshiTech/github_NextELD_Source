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
    @EnvironmentObject var DVClocationManager: DeviceLocationManager

    @State private var note: String = ""

    var body: some View {
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
                
//                Text("390, vijay Nagar , Scheme 54 PU4, indore,Madhya Pradesh 452010, india")
//                    .foregroundColor( Color(uiColor: .wine))
//                    .font(.body)
                
//                if let lat = DVClocationManager.latitude,
//                            let lon = DVClocationManager.longitude,
//                            let city = DVClocationManager.cityName {
//                             Text("\(city) (\(lat), \(lon))")
//                                 .foregroundColor(Color(uiColor: .wine))
//                                 .font(.body)
//                         } else {
//                             Text("Fetching location...")
//                                 .foregroundColor(.gray)
//                                 .font(.body)
//                         }
                
                
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


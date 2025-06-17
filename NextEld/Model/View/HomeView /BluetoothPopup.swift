//
//  BluetoothPopup.swift
//  NextEld
//
//  Created by Priyanshi  on 31/05/25.
//

import Foundation
import SwiftUI

//struct DeviceSelectorView: View {
//    @Binding var selectedBtnDevice: String?
//    @Binding var isPresentedDevices: Bool
//
//    var DivSelect: [String] = ["PT30", "NT-11"]
//
//    var body: some View {
//        VStack(spacing: 10) {
//            Text("Select a Device")
//                .font(.headline)
//                .padding(.top)
//
//            Divider()
//
//            VStack(spacing: 12) {
//                ForEach(DivSelect, id: \.self) { device in
//                    HStack {
//                        Text(device)
//                            .foregroundColor(.black)
//
//                        Spacer()
//
//                        Image(systemName: selectedBtnDevice == device ? "checkmark.circle.fill" : "checkmark.circle")
//                            .foregroundColor(.blue)
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selectedBtnDevice = device
//                    }
//                    Divider()
//                }
//            }
//            .padding(.horizontal)
//
//            Button(action: {
//                isPresentedDevices = false
//            }) {
//                Text("Ok")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(radius: 10)
//        .frame(maxWidth: 300)
//    }
//}

import SwiftUI

struct DeviceSelectorPopup: View {
    @Binding var selectedDevice: String?
    @Binding var isPresented: Bool
    var onConnect: () -> Void

    let devices = ["PT30", "NT-11"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Select a device")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            ForEach(devices, id: \.self) { device in
                HStack {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .background(Circle().fill(selectedDevice == device ? Color.blue : Color.white))
                        .frame(width: 20, height: 20)
                    Text(device)
                        .foregroundColor(.black)
                    Spacer()
                }
                .onTapGesture {
                    selectedDevice = device
                }
            }

            Button(action: {
                onConnect()
            }) {
                Text("Connect Now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}


//#Preview {
//    DeviceSelectorView()
//}

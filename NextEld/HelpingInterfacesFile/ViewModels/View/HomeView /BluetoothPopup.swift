//
//  BluetoothPopup.swift
//  NextEld
//
//  Created by Priyanshi  on 31/05/25.
//

import Foundation
import SwiftUI



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
                    .foregroundColor(Color(uiColor: .wine))
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
                        .background(Circle().fill(selectedDevice == device ?Color(uiColor: .wine) : Color.white))
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
                    .background(Color(uiColor: .wine))
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

//
//  BluetoothPopup.swift
//  NextEld
//
//  Created by Priyanshi  on 31/05/25.
//

import Foundation
import SwiftUI

struct DeviceSelectorView:View {
    
    @Binding var selectedBtnDevice: String?
    @Binding var isPresentedDevices: Bool
    
    var DivSelect: [String] = ["PT30" , "NT-11" ]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Selected a Device")
                .font(.headline)
                .padding(.top)

            Divider()
                VStack(spacing: 12) {
                    ForEach(DivSelect, id: \.self) { Device in
                        HStack {
                            Text(Device)
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: selectedBtnDevice == Device ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(.blue)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedBtnDevice = Device
                        }
                        Divider()
                    }
                }
                .padding(.horizontal)
      

            Button(action: {
                isPresentedDevices = false
            }) {
                Text("Ok")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//#Preview {
//    DeviceSelectorView()
//}

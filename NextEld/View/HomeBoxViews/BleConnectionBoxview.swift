//
//  BleConnectionBoxview.swift
//  NextEld
//
//  Created by priyanshi   on 06/01/26.
//

import Foundation
import SwiftUI

struct BleConnectionBoxview: View {
    
    let deviceName: String
    let macAddress: String
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            // Bluetooth Icon
            Image("Ble_Device")
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(deviceName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(macAddress)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
   
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color(UIColor.lightWine))
        .cornerRadius(5)
        .padding(.horizontal)
        .shadow(radius: 2)
    }
}


//  ToggleRow.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI

struct ToggleRow: View {
    let title: String
    let value: String
    var isMiles: Bool? = nil
    var isCelsius: Bool? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            if let isMiles = isMiles {
                Text("\(value) \(isMiles ? "mph" : "km/h")")
                    .font(.subheadline)
                    .bold()
            } else if let isCelsius = isCelsius {
                Text("\(value)°\(isCelsius ? "C" : "F")")
                    .font(.subheadline)
                    .bold()
            } else {
                Text(value)
                    .font(.subheadline)
                    .bold()
            }
        }
    }
} 
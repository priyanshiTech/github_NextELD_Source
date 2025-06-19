//  DataRow.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI

struct DataRow: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text("\(value)\(unit)")
                .font(.subheadline)
                .bold()
        }
    }
} 
//
//  CheckBoxView.swift
//  NextEld
//
//  Created by AroGeek11 on 07/05/25.
//

import Foundation
import SwiftUI
struct CheckboxButton: View {
    
    @State private var isChecked: Bool = false

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isChecked ? .blue : .gray)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusCheckBox: View {
    var isClick: Bool
    var labelText: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isClick ? .green : .white)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 4)

                Text(labelText)
                    .foregroundColor(isClick ? .white : .blue)
                    .font(.headline)
            }
        }
    }
}

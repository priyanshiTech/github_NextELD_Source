//
//  CheckBoxView.swift
//  NextEld
//
//  Created by priyanshi on 07/05/25.
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
                .foregroundColor(isChecked ?  Color(uiColor: .wine) : .gray)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusCheckBox: View {
    
    
    var isClick: Bool
    var labelText: String
    var onTap: () -> Void

    var body: some View {
        HStack {
            Button(action: onTap) {
                ZStack {
                    Circle()
                        .fill(isClick ? .green : .white)
                        .shadow(radius: 4)

                    Text(labelText)
                        .foregroundColor(isClick ? .white :  Color(uiColor: .wine))
                        .font(.headline)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

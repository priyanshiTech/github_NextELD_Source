//
//  StatusBox&StatusButton.swift
//  NextEld
//
//  Created by priyanshi   on 06/10/25.
//

import Foundation
import SwiftUI


struct StatusBox: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .foregroundColor(.gray)
                .font(.callout)
                .bold()
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Label(time, systemImage: "")
                .foregroundColor(Color(uiColor: .wine))
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color(UIColor.lightWine))
        .cornerRadius(5)
    }
}

struct StatusButton: View {
    let title: String
    let action: () -> Void
    let isSelected: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(isSelected ? .white : Color(uiColor: .wine))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.green : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.green : Color(uiColor: .wine), lineWidth: 2)
                )
        }
    }
}

//
//  VoilationBox.swift
//  NextEld
//
//  Created by priyanshi  on 24/07/25.
//

import Foundation
import SwiftUI

enum ViolationBoxType {
    case warning
    case violation
    
    var color: Color {
        switch self {
        case .warning:
            return .yellow
        case .violation:
            return .red
        }
    }
    
    var title: String {
        switch self {
        case .warning:
            return "Warning"
        case .violation:
            return "Violation"
        }
    }
}

struct ViolationBox: View {
    let text: String
    let date: String
    let time: String
    let type: ViolationBoxType

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(type.title): \(text)")
                .font(.headline)
                .foregroundColor(type.color)

            Text("Date: \(date)")
                .font(.subheadline)
                .foregroundColor(.primary)

            Text("Time: \(time)")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(type.color, lineWidth: 2)
        )
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding()
    }
}

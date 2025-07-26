//
//  VoilationBox.swift
//  NextEld
//
//  Created by priyanshi  on 24/07/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct ViolationBox: View {
    let text: String
    let date: String
    let time: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Violation: \(text)")
                .font(.headline)
                .foregroundColor(.red)

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
                .stroke(Color.red, lineWidth: 2)
        )
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding()
    }
}

//
//  Extension + View.swift
//  NextEld
//
//  Created by priyanshi   on 09/10/25.
//

import Foundation
import SwiftUI

extension View {
    func inputBoxStyle(
        width: CGFloat = 320,
        height: CGFloat = 56,
        isValid: Bool = true
    ) -> some View {
        self
            .padding(.horizontal)
            .frame(width: width, height: height)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isValid
                        ? Color(UIColor.separator)
                        : Color(UIColor.systemRed),
                        lineWidth: 1.5
                    )
            )
    }
}


// MARK: - Helper for Rounded Corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

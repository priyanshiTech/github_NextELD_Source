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
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.gray.opacity(0.5) : Color.red, lineWidth: 1.5)
            )
    }
}



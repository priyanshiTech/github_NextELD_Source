//
//  DvirField.swift
//  NextEld
//
//  Created by Inurum   on 21/05/25.
//

import Foundation
import SwiftUI
struct DvirField: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 100, alignment: .leading)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.5)))
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//
//  DvirEditField.swift
//  NextEld
//
//  Created by Inurum   on 21/05/25.
//

import Foundation
import SwiftUI

struct DvirEditField: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text(value)
                    .font(.body)
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
        }
    }
}

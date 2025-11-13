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
            Spacer()
            Text("\(value) \(unit)")
                .bold()
        }
    }
}

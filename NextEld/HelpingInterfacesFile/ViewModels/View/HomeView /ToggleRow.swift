//  ToggleRow.swift
//  NextEld
//  Created by priyanshi on 04/06/25.

import SwiftUI

struct ToggleRow: View {
    var title: String
    var value: String
    @Binding var toggleValue: Bool

    var body: some View {
        let numericValue = Double(value) ?? 0.0

        let isTemperature = title.lowercased().contains("cool")
            || title.lowercased().contains("fuel")
            || title.lowercased().contains("oil")

        let displayValue: String
        let unitLabel: String

        if isTemperature {
            displayValue = toggleValue
                ? String(format: "%.1f", numericValue)
                : String(format: "%.1f", numericValue * 9 / 5 + 32)
            unitLabel = toggleValue ? "°C" : "°F"
        } else {
            displayValue = toggleValue
                ? String(format: "%.1f", numericValue)
                : String(format: "%.1f", numericValue * 1.60934)
            unitLabel = toggleValue ? "Miles" : "Kilometers"
        }

        return HStack {
            Text(title)
                .font(.subheadline)
                .frame(width: 120, alignment: .leading)

            Text(unitLabel)
                .font(.subheadline)
                .foregroundColor(.gray)

            Toggle("", isOn: $toggleValue)
                .labelsHidden()
                .tint(Color(uiColor: .wine))

            Spacer()

            Text(displayValue)
                .font(.subheadline)
                .foregroundColor(Color(uiColor: .wine))
                .frame(width: 60, alignment: .trailing)
        }
    }

}

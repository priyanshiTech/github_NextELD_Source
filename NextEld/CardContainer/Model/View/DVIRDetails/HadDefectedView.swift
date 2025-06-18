//
//  HadDefectedView.swift
//  NextEld
//
//  Created by Priyanshi   on 24/05/25.
//

import Foundation
import SwiftUI

struct DefectPopupView: View {
    @Binding var isPresented: Bool
    @State private var selected: Set<String> = []

    let defects = [
        "Brake Connections", "Breaks", "Coupling Devices",
        "Coupling Pin", "Doors", "Hitch",
        "Landing Gear", "Lights", "Other"
    ]

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Text("Select Defect")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            ForEach(defects, id: \.self) { defect in
                HStack {
                    Text(defect)
                    Spacer()
                    Button(action: { toggle(defect) }) {
                        Image(systemName: selected.contains(defect) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
            }

            Button(action: {
                isPresented = false
            }) {
                Text("Submit Defects")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }

    private func toggle(_ defect: String) {
        if selected.contains(defect) {
            selected.remove(defect)
        } else {
            selected.insert(defect)
        }
    }
}

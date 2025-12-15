//
//  Defect Section.swift
//  NextEld
//
//  Created by priyanshi   on 15/12/25.
//

import Foundation
import SwiftUI
//MARK: -   ADdd a validation  for input fields
//struct DefectsSection: View
struct DefectsSection: View {
    let title: String
    @Binding var selection: String?
    var onSelectNoDefect: (() -> Void)? = nil
    let onSelectDefect: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                selection = "no"
                onSelectNoDefect?()
            }) {
                defectButton(label: "No Defects", isSelected: selection == "no")
            }
            Button(action: onSelectDefect) {
                defectButton(
                    label: "Has Defects",
                    isSelected: selection != nil && selection != "no"
                )
            }
        }
    }
    
    private func defectButton(label: String, isSelected: Bool) -> some View {
        Text(label)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color(UIColor.wine) : Color.white)
            .foregroundColor(isSelected ? .white : Color(UIColor.wine))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.wine), lineWidth: 1))
            .cornerRadius(8)
    }
}

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
                    .foregroundColor(Color(uiColor: .wine))
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
                            .foregroundColor(Color(uiColor: .wine))
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
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.clear)  //  Only one background
        .cornerRadius(20)
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







//MARK: -  show's in Vechicle condition

struct VehicleConditionPopupView: View {
    @Binding var isPresented: Bool
    @State private var selected: Set<String> = []
    @EnvironmentObject var vehicleVM: VehicleConditionViewModel
    let Condition = [
        "vehicle Condition Satisfactory" , "Vechicle Condition Unsatisfactory"
    ]

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer()
                Text("Select Vechicle Condition")
                    .font(.headline)
                    .foregroundColor(Color(uiColor: .wine))
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            ForEach(Condition, id: \.self) { defect in
                HStack {
                    Text(defect)
                    Spacer()
                    Button(action: { toggle(defect) }) {
                        Image(systemName: selected.contains(defect) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(Color(uiColor: .wine))
                    }
                }
                .padding(.horizontal)
            }

            Button(action: {
                vehicleVM.selectedCondition = selected.first
                isPresented = false
                
            }) {
                Text("Add Condition")
                    .frame(maxWidth: 250)
                    .padding()
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)  //  Only one background
        .cornerRadius(20)
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






























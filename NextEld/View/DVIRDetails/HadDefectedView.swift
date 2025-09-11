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
    var popupType: String
    @Binding var truckDefectSelection: String?
    @Binding var trailerDefectSelection: String?
    
    @State private var selected: Set<String> = [] // multiple selection store
    @StateObject private var viewModel = DefectAPIViewModel(networkManager: NetworkManager())
    
    var body: some View {
        VStack(spacing: 10) {
            
            // --- Header ---
            HStack {
                Spacer()
                Text("Select \(popupType) Defect")
                    .font(.headline)
                    .foregroundColor(Color(uiColor: .wine))
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            
            // --- Content ---
            if viewModel.isLoading {
                ProgressView("Loading defects...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                UniversalScrollView {
                    ForEach(viewModel.defects.filter { $0.defectType == popupType }) { defect in
                        let name = defect.defectName ?? "Unknown Defect"
                        
                        Button(action: {
                            toggle(name)
                        }) {
                            HStack {
                                Text(name)
                                Spacer()
                                Image(systemName: selected.contains(name)
                                      ? "checkmark.square.fill"
                                      : "square")
                                    .foregroundColor(Color(uiColor: .wine))
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                }
            }
            
            // --- Submit Button ---
            Button(action: {
                let result = selected.joined(separator: ", ")
                if popupType == "Truck" {
                    truckDefectSelection = result
                } else {
                    trailerDefectSelection = result
                }
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
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 300, height: 400)
        .task {
            await viewModel.fetchDefects()
        }
    }
    
    private func toggle(_ name: String) {
        if selected.contains(name) {
            selected.remove(name)
        } else {
            selected.insert(name)
        }
    }
}


extension ResultDefect: Identifiable {
    // Build a stable Hashable id even when defectId can be nil
    var ids: String {
        let idPart = defectId.map(String.init) ?? "nil"
        let namePart = defectName ?? ""
        let tsPart = updatedTimestamp.map(String.init) ?? "0"
        return "\(idPart)|\(namePart)|\(tsPart)"
    }
}




//MARK: -  show's in Vechicle condition

struct VehicleConditionPopupView: View {
    @Binding var isPresented: Bool
    @State private var selected: String? = nil   // single selection
    @EnvironmentObject var vehicleVM: VehicleConditionViewModel
    
    let conditions = [
        "Vehicle Condition Satisfactory",
        "Vehicle Condition Unsatisfactory"
    ]

    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Spacer()
                Text("Select Vehicle Condition")
                    .font(.headline)
                    .foregroundColor(Color(uiColor: .wine))
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }

            // Options
            ForEach(conditions, id: \.self) { condition in
                HStack {
                    Text(condition)
                    Spacer()
                    Image(systemName: selected == condition ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(Color(uiColor: .wine))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .contentShape(Rectangle()) // Make whole row tappable
                .onTapGesture {
                    selected = condition
                }
            }

            // Submit
            Button(action: {
                vehicleVM.selectedCondition = selected
                isPresented = false
            }) {
                Text("Add Condition")
                    .frame(maxWidth: 250)
                    .padding()
                    .background(Color(uiColor: .wine))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selected == nil) // disable until selection made
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}



















































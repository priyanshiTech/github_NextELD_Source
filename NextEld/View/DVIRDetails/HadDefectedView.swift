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
    @EnvironmentObject var appRootManager: AppRootManager
    
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
                        let rawName = defect.defectName ?? "Unknown Defect"
                        let name = normalizedName(from: rawName)
                        
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
        .onAppear {
            syncSelectedWithExistingSelection()
        }
        .onChange(of: popupType) { _ in
            syncSelectedWithExistingSelection()
        }
        .onChange(of: truckDefectSelection) { _ in
            guard popupType == "Truck" else { return }
            syncSelectedWithExistingSelection()
        }
        .onChange(of: trailerDefectSelection) { _ in
            guard popupType == "Trailer" else { return }
            syncSelectedWithExistingSelection()
        }
        .task {
            viewModel.appRootManager = appRootManager
            let success = await viewModel.fetchDefects()
            
            if viewModel.isSessionExpired {
                // print(" Session expired detected in DefectPopupView - staying on SessionExpireUIView")
                isPresented = false
                return
            }
            
            if !success, let error = viewModel.errorMessage {
                // print(" Defect API error: \(error)")
            }
        }
    }
    
    private func toggle(_ name: String) {
        let normalized = normalizedName(from: name)
        if selected.contains(normalized) {
            selected.remove(normalized)
        } else {
            selected.insert(normalized)
        }
    }
    
    private func syncSelectedWithExistingSelection() {
        let currentValue: String?
        if popupType == "Truck" {
            currentValue = truckDefectSelection
        } else {
            currentValue = trailerDefectSelection
        }
        
        guard let currentValue else {
            selected = []
            return
        }
        
        let trimmed = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            selected = []
            return
        }
        
        let normalized = trimmed.lowercased()
        if normalized == "yes" || normalized == "no" {
            selected = []
            return
        }
        
        let names = trimmed
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        selected = Set(names)
    }
    
    private func normalizedName(from value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Unknown Defect" : trimmed
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





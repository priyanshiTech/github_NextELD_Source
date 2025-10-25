//
//  AddDvirPopupHome.swift
//  NextEld
//
//  Created by priyanshi on 24/10/25.
//

import Foundation
import SwiftUI


struct AddDvirPopup: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle()) // keeps tap detection area
                .onTapGesture {
                    isPresented = false
                }

            
            // Main popup card
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Text("Add Dvir")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(uiColor:.wine))
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
                
                Divider()
                // Information fields
                Group {
                    
                    InfoRow(label: "Driver", value: AppStorageHandler.shared.driverName ?? "")
                    InfoRow(label: "Time", value: DateTimeHelper.currentTime())
                    InfoRow(label: "Date", value: DateTimeHelper.currentDate())
                    InfoRow(label: "Odometer", value: "0")
                    InfoRow(label: "Company", value: "Indian Eld")
                    InfoRow(label: "Location", value: "389, Vijay Nagar, Scheme 54, Indore")
                }
                
                Divider()
                
                Group {
                    
                    InfoRow(label: "Vehicle", value: AppStorageHandler.shared.vehicleNo ?? "")
                    InfoRow(label: "Trailer", value: "None")
                    InfoRow(label: "Truck Defect", value: "None")
                    InfoRow(label: "Trailer Defect", value: "None")
                    InfoRow(label: "Notes", value: "Not Available")
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Vehicle Condition")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Vehicle Condition Satisfactory")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                // Add button
                Button(action: {
                    isPresented = false
                }) {
                    Text("Add Dvir")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background((Color(uiColor:.wine)))
                        .cornerRadius(10)
                }
                .padding(.top, 8)
                
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .frame(width: 300, height: 400)
            .shadow(radius: 10)
        }
    }
}

// MARK: - Helper Row View
struct InfoRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview
struct AddDvirPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddDvirPopup(isPresented: .constant(true))
    }
}


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
    var dvirRecord: DvirRecord?
    @State private var currentRecord: DvirRecord?
    
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
                    
                    InfoRow(label: "Driver", value: currentRecord?.UserName ?? "")
                    InfoRow(label: "Time", value: DateTimeHelper.currentTime())
                    InfoRow(label: "Date", value: DateTimeHelper.currentDate())
                    InfoRow(label: "Odometer", value: currentRecord?.odometer.map { String(format: "%.0f", $0) } ?? "")
                    InfoRow(label: "Company", value: AppStorageHandler.shared.company ?? "Not Found")
                    InfoRow(label: "Location", value: currentRecord?.location ?? "")
                    
                }
                
                Divider()
                
                Group {
                    
                    InfoRow(label: "Vehicle", value: AppStorageHandler.shared.vehicleNo ?? "")
                    InfoRow(label: "Trailer", value: currentRecord?.Trailer ?? "")
                    InfoRow(label: "Truck Defect", value: currentRecord?.truckDefect ?? "")
                    InfoRow(label: "Trailer Defect", value: currentRecord?.trailerDefect ?? "")
                    InfoRow(label: "Notes", value: currentRecord?.notes ?? "")
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
        .onAppear {
            // If dvirRecord is provided, use it; otherwise fetch the last record from database
            if let providedRecord = dvirRecord {
                currentRecord = providedRecord
            } else {
                // Fetch the last DVIR record from database
                let records = DvirDatabaseManager.shared.fetchAllRecords(limit: 1)
                currentRecord = records.first
            }
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
        Group {
            AddDvirPopup(
                isPresented: .constant(true),
                dvirRecord: DvirRecord(
                    id: 1,
                    UserID: "123",
                    UserName: "John Doe",
                    startTime: Date(),
                    DAY: 1,
                    Shift: 1,
                    DvirTime: "10:00 AM",
                    odometer: 12345.0,
                    location: "New York",
                    truckDefect: "None",
                    trailerDefect: "None",
                    vehicleCondition: "Satisfactory",
                    notes: "Test notes",
                    vehicleName: "Vehicle 1",
                    vechicleID: "V001",
                    Sync: 0,
                    timestamp: "1234567890",
                    Server_ID: "",
                    Trailer: "Trailer 1",
                    signature: nil
                )
            )
            // Also test without providing dvirRecord
            AddDvirPopup(isPresented: .constant(true))
        }
    }
}


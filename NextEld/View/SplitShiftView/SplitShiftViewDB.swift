//
//  SplitShiftViewDB.swift
//  NextEld
//
//  Created by priyanshi on 26/12/25.
//

import Foundation
import SwiftUI
            
// MARK: - Extension for Identifiable
extension SplitShiftLog: Identifiable {}

// MARK: - MAIN VIEW
struct SplitShiftDBView: View {
    @State private var records: [SplitShiftLog] = []

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Header with title
                HStack {
                    Text("Split Sleep Logs")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("Total: \(records.count)")
                        .foregroundColor(.gray)
                }
                .padding()
                
                // MARK: - Table Section
                UniversalScrollView(axis: .horizontal, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // MARK: - Header
                        SplitShiftTableHeader()
                            .background(Color.gray.opacity(0.2))
                            .padding(.vertical, 0)

                        // MARK: - Rows (same scroll view for alignment)
                        UniversalScrollView(axis: .vertical, showsIndicators: true) {
                            LazyVStack(spacing: 0) {
                                if records.isEmpty {
                                    VStack {
                                        Spacer()
                                        Text("No split shift logs found")
                                            .foregroundColor(.gray)
                                            .font(.title3)
                                        Text("Split shift logs will appear here")
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .frame(height: 200)
                                } else {
                                    ForEach(records) { record in
                                        SplitShiftTableRow(record: record)
                                            .background(Color.white)
                                        Divider().background(Color.gray.opacity(0.5))
                                    }
                                }
                            }
                        }
                    }
                    .padding(0)
                }

                Divider()
            }
            .navigationTitle("Split Sleep Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            records = DatabaseManager.shared.getfetchAllSplitShiftLog()
              
        }
    }
}

// Alias for backward compatibility
typealias SplitShiftTableView = SplitShiftDBView

// MARK: - Table Header
struct SplitShiftTableHeader: View {
    var body: some View {
        HStack(spacing: 5) {
            TableCell(text: "ID", width: 80, isHeader: true)
            TableCell(text: "Status", width: 150, isHeader: true)
            TableCell(text: "Split Time", width: 150, isHeader: true)
            TableCell(text: "Day", width: 100, isHeader: true)
            TableCell(text: "Shift", width: 100, isHeader: true)
            TableCell(text: "User ID", width: 120, isHeader: true)
        }
        .padding()
    }
}

// MARK: - Table Row
struct SplitShiftTableRow: View {
    let record: SplitShiftLog

    var body: some View {
        HStack(spacing: 5) {
            TableCell(text: "\(record.id)", width: 80)
            TableCell(text: record.status, width: 150)
            TableCell(text: formatTime(record.splitTime), width: 150)
            TableCell(text: "\(record.day)", width: 100)
            TableCell(text: "\(record.shift)", width: 100)
            TableCell(text: "\(record.userId)", width: 120)
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        let hrs = Int(seconds) / 3600
        let mins = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}

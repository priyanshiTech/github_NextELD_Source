//
//  CertifyViewDB.swift
//  NextEld
//
//  Created by priyanshi   on 13/08/25.
//

import SwiftUI

struct DatabaseCertifyView: View {
    @State private var records: [CertifyRecord] = []
    @State private var currentPage = 0
    private let recordsPerPage = 10
    
    var paginatedRecords: [CertifyRecord] {
        let start = currentPage * recordsPerPage
        let end = min(start + recordsPerPage, records.count)
        return Array(records[start..<end])
    }
    
    var totalPages: Int {
        max(1, (records.count + recordsPerPage - 1) / recordsPerPage)
    }
    
    var body: some View {
        VStack {
            // MARK: - Table
            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 0) {
                    CertifyTableHeader()
                        .background(Color.gray.opacity(0.2))
                    
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(paginatedRecords.indices, id: \.self) { index in
                                let record = paginatedRecords[index]
                                CertifyTableRow(record: record)
                                    .background(Color.white)
                                Divider()
                            }
                        }
                    }
                }
            }
            Divider()
            
            // MARK: - Pagination Controls
            HStack {
                Button("Previous") {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                Text("Page \(currentPage + 1) of \(totalPages)")
                    .bold()
                
                Spacer()
                
                Button("Next") {
                    if (currentPage + 1) * recordsPerPage < records.count {
                        currentPage += 1
                    }
                }
                .disabled((currentPage + 1) * recordsPerPage >= records.count)
            }
            .padding()
            
            // MARK: - Delete All Button
                     Button(role: .destructive) {
                         CertifyDatabaseManager.shared.deleteAllRecords()
                         loadRecords()
                         currentPage = 0
                     } label: {
                         Text("Delete All Records")
                             .frame(maxWidth: .infinity)
                             .padding()
                             .background(Color.red.opacity(0.9))
                             .foregroundColor(.white)
                             .cornerRadius(8)
                     }
                     .padding(.top, 10)
        }
        .navigationTitle("Certify Records")
        .onAppear {
            loadRecords()
        }
       
        .onReceive(NotificationCenter.default.publisher(for: .certifyUpdated)) { notification in
            if let date = notification.object as? String {
                print(" Certified updated for date: \(date)")
            }
            loadRecords() // Refresh table
        }

        .padding()
    }
    
    func loadRecords() {
        records = CertifyDatabaseManager.shared.fetchAllRecords()
        print("All certify Records here :\(records)")
    }
  

}

// MARK: - Table Header
struct CertifyTableHeader: View {
    
    var body: some View {
        HStack(spacing: 5) {
            TableCellCertify(text: "User ID", width: 120, isHeader: true)
            TableCellCertify(text: "User Name", width: 150, isHeader: true)
            TableCellCertify(text: "Start Time", width: 150, isHeader: true)
            TableCellCertify(text: "Date", width: 120, isHeader: true)
            TableCellCertify(text: "Shift", width: 100, isHeader: true)
            TableCellCertify(text: "Vehicle", width: 150, isHeader: true)
            TableCellCertify(text: "Trailer", width: 150, isHeader: true)
            TableCellCertify(text: "Shipping Doc", width: 200, isHeader: true)
            TableCellCertify(text: "Co-Driver", width: 150, isHeader: true)
            TableCellCertify(text: "Vehicle ID", width: 150, isHeader: true)
            TableCellCertify(text: "CoDriver ID", width: 150, isHeader: true)
            TableCellCertify(text: "isSynced", width: 150, isHeader: true)
            TableCellCertify(text: "IsLogCertified", width: 150, isHeader: true)


        }
    }
    
}

// MARK: - Table Row
struct CertifyTableRow: View {
    let record: CertifyRecord
    
    var body: some View {
        HStack(spacing: 5) {
            TableCellCertify(text: record.userID, width: 120)
            TableCellCertify(text: record.userName, width: 150)
            TableCellCertify(text: record.startTime, width: 150)
            TableCellCertify(text: record.date, width: 120)
            TableCellCertify(text: record.shift, width: 100)
            TableCellCertify(text: record.selectedVehicle, width: 150)
            TableCellCertify(text: record.selectedTrailer, width: 150)
            TableCellCertify(text: record.selectedShippingDoc, width: 200)
            TableCellCertify(text: record.selectedCoDriver, width: 150)
            TableCellCertify(text: String(record.vehicleID ?? 00), width: 150)
            TableCellCertify(text: String(record.coDriverID ?? 00), width: 150)
            TableCellCertify(text: String(record.syncStatus) , width: 150)
            TableCellCertify(text: record.isCertify, width: 150)

        }
    }
}

// MARK: - Reusable Cell
struct TableCellCertify: View {
    let text: String
    let width: CGFloat
    var isHeader: Bool = false
    
    var body: some View {
        Text(text)
            .font(isHeader ? .headline : .body)
            .frame(width: width, height: 40)
            .background(isHeader ? Color.gray.opacity(0.15) : Color.white)
            .border(Color.gray, width: 0.5)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
}

//
//  DVIRDataTableView.swift
//  NextEld
//
//  Created by priyanshi on 26/07/25.
//

import Foundation
import SwiftUI


struct DvirListView: View {
    @State private var records: [DvirRecord] = []
    @State private var currentPage = 0
    private let recordsPerPage = 10
 
    var paginatedRecords: [DvirRecord] {
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
                    DvirTableHeader()
                        .background(Color.gray.opacity(0.2))

                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(paginatedRecords, id: \.id) { record in
                                DvirTableRow(record: record)
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
        }
        .navigationTitle("DVIR Records")
        .onAppear {
            loadRecords()
        }
        .padding()
    }

//   func loadRecords() {
//        records = DvirDatabaseManager.shared.fetchAllRecords()
//    }


    func loadRecords() {
        let allRecords = DvirDatabaseManager.shared.fetchAllRecords()

        var seenKeys = Set<String>()
        records = allRecords.filter { record in
            let key = "\(record.UserID)-\(record.vechicleID)-\(record.Trailer)"
            if seenKeys.contains(key) {
                return false
            } else {
                seenKeys.insert(key)
                return true
            }
        }
    }
}

//MARK: - Table Header
struct DvirTableHeader: View {
    
    var body: some View {
        
        HStack(spacing: 5) {
            
            TableCellDvirList(text: "ID", width: 50, isHeader: true)
            TableCellDvirList(text: "Driver ID", width: 100, isHeader: true)
            TableCellDvirList(text: "Driver Name", width: 150, isHeader: true)
            TableCellDvirList(text: "Vehicle Name", width: 150, isHeader: true)
            TableCellDvirList(text: "Vehicle ID", width: 100, isHeader: true)
            TableCellDvirList(text: "Trailer", width: 150, isHeader: true)
            TableCellDvirList(text: "Truck Defect", width: 200, isHeader: true)
            TableCellDvirList(text: "Trailer Defect", width: 200, isHeader: true)
            TableCellDvirList(text: "Vehicle Condition", width: 350, isHeader: true)
            TableCellDvirList(text: "StartTime", width: 200, isHeader: true)
            TableCellDvirList(text: "Day", width: 100, isHeader: true)
            TableCellDvirList(text: "Shift", width: 60, isHeader: true)
            TableCellDvirList(text: "Notes", width: 250, isHeader: true)
            TableCellDvirList(text: "Signature", width: 250, isHeader: true)
        }
    }
}
struct DvirTableRow: View {
    let record: DvirRecord

    var body: some View {
        HStack(spacing: 5) {
            TableCellDvirList(text: "\(record.id ?? 0)", width: 50)
            TableCellDvirList(text: "\(DriverInfo.driverId ?? 0)", width: 100)
            TableCellDvirList(text: record.UserName, width: 150)
            TableCellDvirList(text: record.vehicleName, width: 150)
            TableCellDvirList(text: record.vechicleID, width: 100)
            TableCellDvirList(text: record.Trailer, width: 150)
            TableCellDvirList(text: record.truckDefect, width: 200)
            TableCellDvirList(text: record.trailerDefect, width: 200)
            TableCellDvirList(text: record.vehicleCondition, width: 350)
            TableCellDvirList(text: "\(DateTimeHelper.currentDate()) \(DateTimeHelper.currentTime())", width: 200)
            TableCellDvirList(text: "\(DriverInfo.Days)", width: 100)
            TableCellDvirList(text: "\(DriverInfo.shift)", width: 60)
            TableCellDvirList(text: record.notes, width: 250)

            if let signatureData = record.signature,
               let uiImage = UIImage(data: signatureData) {
                TableCellImageDvirList(imageData: uiImage, width: 250)
            } else {
                TableCellDvirList(text: "No Signature", width: 250)
            }
        }
        .frame(height: 50)
    }
}

// Text Cell
struct TableCellDvirList: View {
    let text: String
    let width: CGFloat
    var isHeader: Bool = false

    var body: some View {
        Text(text)
            .font(isHeader ? .headline : .body)
            .frame(width: width, height: 50)
            .background(isHeader ? Color.gray.opacity(0.2) : Color.white)
            .border(Color.gray, width: 0.5)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
    }
}

// Image Cell for Signature
struct TableCellImageDvirList: View {
    let imageData: UIImage
    let width: CGFloat

    var body: some View {
        Image(uiImage: imageData)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: 50)
            .border(Color.gray, width: 0.5)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}






















































                    
                
            

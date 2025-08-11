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
            let key = "\(record.driver)-\(record.vehicle)-\(record.trailer)"
            if seenKeys.contains(key) {
                return false
            } else {
                seenKeys.insert(key)
                return true
            }
        }
    }

}

// MARK: - Table Header
struct DvirTableHeader: View {
    var body: some View {
        HStack(spacing: 5) {
            TableCell(text: "Driver", width: 150, isHeader: true)
            TableCell(text: "Vehicle", width: 150, isHeader: true)
            TableCell(text: "Trailer", width: 150, isHeader: true)
            TableCell(text: "Truck Defect", width: 200, isHeader: true)
            TableCell(text: "Trailer Defect", width: 200, isHeader: true)
            TableCell(text: "Date", width: 150, isHeader: true)
            TableCell(text: "Time", width: 100, isHeader: true)
            TableCell(text: "Notes", width: 250, isHeader: true)
            TableCell(text: "Signature", width: 150, isHeader: true)
            TableCell(text: "Vechicle Condition" , width: 250 ,  isHeader: true)
        }
    }
}

// MARK: - Table Row
struct DvirTableRow: View {
    let record: DvirRecord

    var body: some View {
        HStack(spacing: 5) {
            TableCellDvirList(text: record.driver, width: 150)
            TableCellDvirList(text: record.vehicle, width: 150)
            TableCellDvirList(text: record.trailer, width: 150)
            TableCellDvirList(text: record.truckDefect, width: 200)
            TableCellDvirList(text: record.trailerDefect, width: 200)
             TableCellDvirList(text: record.date, width: 150)
            TableCellDvirList(text: record.time, width: 100)
            TableCellDvirList(text: record.notes, width: 250)
            TableCellImageDvirList(width: 150) {
                
                if let imageData = record.signature,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: 100, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 1)
                } else {
                    Text("No Signature")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }


            TableCellDvirList(text: record.vehicleCondition, width: 250)

        }
    }
}

// MARK: - Reusable Cell View
struct TableCellDvirList: View {
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

//MARK: -  for image
struct TableCellImageDvirList<Content: View>: View {
    var width: CGFloat
    let content: () -> Content

    init(width: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.width = width
        self.content = content
    }

    var body: some View {
        VStack {
            content()
        }
        .frame(width: width, alignment: .leading)
        .padding(4)
        .background(Color.white)
        .border(Color.gray.opacity(0.2), width: 1)
    }
}


// MARK: - Preview
struct DvirListView_Previews: PreviewProvider {
    static var previews: some View {
        DvirListView()
    }
}


























































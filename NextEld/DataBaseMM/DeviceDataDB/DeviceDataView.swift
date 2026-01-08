//
//  DeviceDataView.swift
//  NextEld
//
//  Created by priyanshi on 08/01/26.
//

import Foundation
import SwiftUI

struct DeviceDataTableView: View {

    @State private var records: [DeviceDataModel] = []
    @State private var currentPage = 0
    private let recordsPerPage = 10

    var paginatedRecords: [DeviceDataModel] {
        let start = currentPage * recordsPerPage
        let end = min(start + recordsPerPage, records.count)
        return Array(records[start..<end])
    }

    var totalPages: Int {
        max(1, (records.count + recordsPerPage - 1) / recordsPerPage)
    }

    var body: some View {
        VStack {

            ScrollView(.horizontal) {
                VStack(spacing: 0) {

                    DeviceDataTableHeader()
                        .background(Color.gray.opacity(0.2))

                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(paginatedRecords) { record in
                                DeviceDataTableRow(record: record)
                                Divider()
                            }
                        }
                    }
                }
            }

            Divider()

            // Pagination
            HStack {
                Button("Previous") {
                    if currentPage > 0 { currentPage -= 1 }
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
        .navigationTitle("Device Data")
        .onAppear(perform: loadRecords)
        .padding()
    }

    func loadRecords() {
        records = DeviceDataDbManager.shared.fetchAllDeviceData()
    }
}
struct DeviceDataTableHeader: View {
    var body: some View {
        HStack(spacing: 5) {
            TableCellDvirList(text: "ID", width: 60, isHeader: true)
            TableCellDvirList(text: "Driver ID", width: 100, isHeader: true)
            TableCellDvirList(text: "Vehicle ID", width: 100, isHeader: true)
            TableCellDvirList(text: "DateTime", width: 180, isHeader: true)
            TableCellDvirList(text: "Odometer", width: 120, isHeader: true)
            TableCellDvirList(text: "Engine Hrs", width: 120, isHeader: true)
            TableCellDvirList(text: "Model", width: 120, isHeader: true)
            TableCellDvirList(text: "Serial No", width: 150, isHeader: true)
            TableCellDvirList(text: "MAC", width: 180, isHeader: true)
            TableCellDvirList(text: "VIN", width: 180, isHeader: true)
            TableCellDvirList(text: "Speed", width: 100, isHeader: true)
            TableCellDvirList(text: "RPM", width: 80, isHeader: true)
            TableCellDvirList(text: "Oil Temp", width: 100, isHeader: true)
            TableCellDvirList(text: "Coolant", width: 100, isHeader: true)
            TableCellDvirList(text: "Fuel Temp", width: 100, isHeader: true)
        }
    }
}
struct DeviceDataTableRow: View {

    let record: DeviceDataModel

    var body: some View {
        HStack(spacing: 5) {
            TableCellDvirList(text: "\(record.id ?? 0)", width: 60)
            TableCellDvirList(text: "\(record.driverId)", width: 100)
            TableCellDvirList(text: "\(record.vehicleId)", width: 100)
            TableCellDvirList(
                text: record.dateTime.toLocalString(format: .defaultDateTime),
                width: 180
            )
            TableCellDvirList(text: "\(record.odometer)", width: 120)
            TableCellDvirList(text: "\(record.engineHours)", width: 120)
            TableCellDvirList(text: record.model, width: 120)
            TableCellDvirList(text: record.serialNo, width: 150)
            TableCellDvirList(text: record.macAddress, width: 180)
            TableCellDvirList(text: record.vin, width: 180)
            TableCellDvirList(text: "\(record.speed)", width: 100)
            TableCellDvirList(text: "\(record.rpm)", width: 80)
            TableCellDvirList(text: "\(record.oilTemp)", width: 100)
            TableCellDvirList(text: "\(record.coolantTemp)", width: 100)
            TableCellDvirList(text: "\(record.fuelTankTemp)", width: 100)
        }
        .frame(height: 50)
    }
}

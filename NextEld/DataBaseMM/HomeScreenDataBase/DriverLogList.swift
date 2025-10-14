//
//  DriverLogList.swift
//  NextEld
//
//  Created by priyanshi on 26/06/25.
//

import SwiftUI

// MARK: - MAIN VIEW
struct DriverLogListView: View {
    @StateObject private var viewModel = DriverLogViewModel()
    @State private var currentPage = 0
    private let logsPerPage = 10
    @State private var showConfirmation = false

    // MARK: - Pagination Logic
    var paginatedLogs: [DriverLogModel] {
        let start = currentPage * logsPerPage
        let end = min(start + logsPerPage, viewModel.logs.count)
        return Array(viewModel.logs[start..<end])
    }

    var totalPages: Int {
        max(1, (viewModel.logs.count + logsPerPage - 1) / logsPerPage)
    }

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Header with title
                HStack {
                    Text("Driver Logs")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("Total: \(viewModel.logs.count)")
                        .foregroundColor(.gray)
                }
                .padding()
                
                // MARK: - Table Section
                UniversalScrollView(axis: .horizontal, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // MARK: -  Header
                        DriverLogHeader()
                            .background(Color.gray.opacity(0.2))
                            .padding(.vertical, 0) // No extra padding

                        // MARK: - Rows (same scroll view for alignment)
                        UniversalScrollView(axis: .vertical, showsIndicators: true) {
                            LazyVStack(spacing: 0) {
                                if viewModel.logs.isEmpty {
                                    VStack {
                                        Spacer()
                                        Text("No logs found")
                                            .foregroundColor(.gray)
                                            .font(.title3)
                                        Text("Start using the app to see logs here")
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .frame(height: 200)
                                } else {
                                    ForEach(paginatedLogs) { log in
                                        DriverLogRow(log: log)
                                            .background(Color.white)
                                        Divider().background(Color.gray.opacity(0.5))
                                    }
                                }
                            }
                        }
                    }
                    .padding(0) // Remove padding, keeps column widths exact
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
                        if (currentPage + 1) * logsPerPage < viewModel.logs.count {
                            currentPage += 1
                        }
                    }
                    .disabled((currentPage + 1) * logsPerPage >= viewModel.logs.count)

                }
                .padding()
            }
            .navigationTitle("Driver Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            print("🔄 DriverLogListView appeared - loading logs...")
            viewModel.loadLogs()
            print("📊 Loaded \(viewModel.logs.count) logs")
        }
    }
}


struct DriverLogHeader: View {

    var body: some View {
        
        HStack(spacing: 5) {
            
            TableCell(text: "ID", width: 50,isHeader: true)
            TableCell(text: "Status", width: 180,isHeader: true)
            TableCell(text: "Start Time", width: 260,isHeader: true)
            TableCell(text: "UserID", width: 100,isHeader: true)
            TableCell(text: "Day", width: 100,isHeader: true)
            TableCell(text: "isVoilation", width: 100,isHeader: true)
            TableCell(text: "DutyType", width: 350,isHeader: true)
            TableCell(text: "Shift", width: 100,isHeader: true)
            TableCell(text: "Location", width: 600,isHeader: true)
            TableCell(text: "Lat", width: 100,isHeader: true)
            TableCell(text: "Long", width: 100,isHeader: true)
            TableCell(text: "Vehicle", width: 100,isHeader: true)
            TableCell(text: "Odometer", width: 100,isHeader: true)
            TableCell(text: "Engine Hrs", width: 100,isHeader: true)
            TableCell(text: "Origin", width: 100,isHeader: true)
            TableCell(text: "Sync", width: 100,isHeader: true)
            TableCell(text: "VehicleID", width: 100,isHeader: true)
            TableCell(text: "Trailers", width: 100,isHeader: true)
            TableCell(text: "Notes", width: 100,isHeader: true)
            TableCell(text: "ServerId", width: 300,isHeader: true)
            TableCell(text: "Timestamp", width: 250,isHeader: true)
            TableCell(text: "Identifier", width: 100,isHeader: true)
            TableCell(text: "RemainingWeeklyTime", width: 220,isHeader: true)
            TableCell(text: "RemainingDriveTime", width: 220,isHeader: true)
            TableCell(text: "RemainingDutyTime", width: 220,isHeader: true)
            TableCell(text: "RemainingSleepTime", width: 220,isHeader: true)
            TableCell(text: "isSplit", width: 80,isHeader: true)
            TableCell(text: "EngineStatus", width: 120,isHeader: true)
        }
        .padding()
       // .background(Color.gray.opacity(0.2))
    }
}
struct DriverLogRow: View {
    let log: DriverLogModel
    @StateObject private var locationManager = DeviceLocationManager()

    var body: some View {

        HStack(spacing: 5) {
            TableCell(text: "\(log.id ?? -1)", width: 50)
            TableCell(text: log.status, width: 180)
            TableCell(text: log.startTime, width: 260)
            TableCell(text: "\(DriverInfo.driverId ?? 0)", width: 100)
            TableCell(text: "\(log.day)", width: 100)
            TableCell(text: "\(log.isVoilations)", width: 100)
            TableCell(text: log.dutyType, width: 350)
            TableCell(text: "\(log.shift)", width: 100)
            TableCell(text: log.location.isEmpty ? "Not Available" : log.location, width: 600)
            TableCell(text: "\(log.lat)", width: 100)
            TableCell(text: "\(log.long)", width: 100)
            TableCell(text: log.vehicle, width: 100)
            TableCell(text: String(format: "%.1f", log.odometer), width: 100)
            TableCell(text: log.engineHours, width: 100)
            TableCell(text: log.origin, width: 100)
            TableCell(text: log.isSynced ? "Yes" : "No", width: 100)
            TableCell(text: "\(DriverInfo.vehicleId ?? 3)", width: 100)
            TableCell(text: log.trailers, width: 100)
            TableCell(text: log.notes, width: 100)
            TableCell(text: log.serverId.map { String($0) } ?? "-", width: 300)
            TableCell(text: "\(log.timestamp)", width: 250)
            TableCell(text: "\(log.identifier)", width: 100)
            TableCell(text: log.remainingWeeklyTime ?? "N/A", width: 220)
            TableCell(text: log.remainingDriveTime ?? "N/A", width: 220)
            TableCell(text: log.remainingDutyTime ?? "N/A", width: 220)
            TableCell(text: log.remainingSleepTime ?? "N/A", width: 220)
            TableCell(text: "\(log.isSplit)", width: 80)
            TableCell(text: log.engineStatus, width: 120)
        }
     
        
    }
}

struct TableCell: View {
    var text: String
    var width: CGFloat
    var isHeader: Bool = false

    var body: some View {
        
        Text(text)
            .frame(width: width, height: 40)
            .background(Color.white)
            .border(Color.gray, width: 0.5)
            .lineLimit(1)
    }

}

func convertToSeconds(_ value: String?) -> Int {
    guard let timeString = value, !timeString.isEmpty else { return 0 }
    
    if let seconds = Int(timeString) {
        return seconds
    }
    let components = timeString.split(separator: ":").map { Int($0) ?? 0 }
    switch components.count {
    case 3: // HH:mm:ss
        return components[0] * 3600 + components[1] * 60 + components[2]
    case 2: // HH:mm
        return components[0] * 3600 + components[1] * 60
    default:
        return 0
    }
}



//#Preview {
//    DriverLogListView()
//}





























































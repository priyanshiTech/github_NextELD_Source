//
//  DriverLogList.swift
//  NextEld
//
//  Created by priyanshi on 26/06/25.
//

import SwiftUI


//MARK: ----  Without Compilation errror



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
        VStack {
            // MARK: - Table Section
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    DriverLogHeader() //  Clean header
                        .padding(.vertical, 5)

                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 0) {
                            ForEach(paginatedLogs) { log in
                                DriverLogRow(log: log) // Clean rows
                                Divider().background(Color.white)
                            }
                        }
                    }
                }
                .padding()
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

                Button("Clear All Logs") {
                    showConfirmation = true
                }
                .alert("Are you sure?", isPresented: $showConfirmation) {
                    Button("Delete All", role: .destructive) {
                       // DatabaseManager.shared.deleteDatabaseFile()
                        DatabaseManager.shared.deleteAllLogs()
                         viewModel.logs.removeAll()
                         currentPage = 0
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadLogs()
        }

    }
    
   
}


struct DriverLogHeader: View {
    var body: some View {
        HStack(spacing: 5) {
            TableCell(text: "ID", width: 50)
            TableCell(text: "Status", width: 100)
            TableCell(text: "Start Time", width: 150)
            TableCell(text: "UserID", width: 100)
            TableCell(text: "Day", width: 100)
            TableCell(text: "isVoilation", width: 100)
            TableCell(text: "DutyType", width: 100)
            TableCell(text: "Shift", width: 100)
            TableCell(text: "Location", width: 250)
            TableCell(text: "Lat", width: 100)
            TableCell(text: "Long", width: 100)
            TableCell(text: "Vehicle", width: 100)
            TableCell(text: "Odometer", width: 100)
            TableCell(text: "Engine Hrs", width: 100)
            TableCell(text: "Origin", width: 100)
            TableCell(text: "Sync", width: 100)
            TableCell(text: "VehicleID", width: 100)
            TableCell(text: "Trailers", width: 100)
            TableCell(text: "Notes", width: 100)
            TableCell(text: "ServerId", width: 100)
            TableCell(text: "Timestamp", width: 100)
            TableCell(text: "Identifier", width: 100)
            TableCell(text: "RemainingWeeklyTime", width: 120)
            TableCell(text: "RemainingDriveTime", width: 120)
            TableCell(text: "RemainingDutyTime", width: 120)
            TableCell(text: "RemainingSleepTime", width: 120)
            TableCell(text: "isSplit", width: 80)
            TableCell(text: "EngineStatus", width: 120)
        }
        .background(Color.gray.opacity(0.2))
    }
}
struct DriverLogRow: View {
    let log: DriverLogModel

    var body: some View {
        HStack(spacing: 5) {
            TableCell(text: "\(log.id ?? -1)", width: 50)
            TableCell(text: log.status, width: 100)
            TableCell(text: log.startTime, width: 150)
            TableCell(text: String(describing: log.userId), width: 100)
            TableCell(text: "\(log.day)", width: 100)
            TableCell(text: "\(log.isVoilations)", width: 100)
            TableCell(text: log.dutyType, width: 100)
            TableCell(text: "\(log.shift)", width: 100)
            TableCell(text: log.location, width: 250)
            TableCell(text: "\(log.lat)", width: 100)
            TableCell(text: "\(log.long)", width: 100)
            TableCell(text: log.vehicle, width: 100)
            TableCell(text: String(format: "%.1f", log.odometer), width: 100)
            TableCell(text: log.engineHours, width: 100)
            TableCell(text: log.origin, width: 100)
            TableCell(text: log.isSynced ? "Yes" : "No", width: 100)
            TableCell(text: String(describing: log.vehicleId), width: 100)
            TableCell(text: log.trailers, width: 100)
            TableCell(text: log.notes, width: 100)
            TableCell(text: String(describing: log.serverId), width: 100)
            TableCell(text: "\(log.timestamp)", width: 100)
            TableCell(text: "\(log.identifier)", width: 100)
            TableCell(text: log.remainingWeeklyTime ?? "", width: 120)
            TableCell(text: log.remainingDriveTime ?? "", width: 120)
            TableCell(text: log.remainingDutyTime ?? "", width: 120)
            TableCell(text: log.remainingSleepTime ?? "", width: 120)
            TableCell(text: "\(log.isSplit)", width: 80)
            TableCell(text: log.engineStatus, width: 120)
        }
    }
}
struct TableCell: View {
    var text: String
    var width: CGFloat

    var body: some View {
        Text(text)
            .frame(width: width, height: 40)
            .background(Color.white)
            .border(Color.gray, width: 0.5)
            .lineLimit(1)
    }
}



#Preview {
    DriverLogListView()
}






























































//struct DriverLogListView: View {
//    @StateObject private var viewModel = DriverLogViewModel()
//    @State private var currentPage = 0
//    private let logsPerPage = 10
//    @State private var showConfirmation = false
//
//    var paginatedLogs: [DriverLogModel] {
//        let start = currentPage * logsPerPage
//        let end = min(start + logsPerPage, viewModel.logs.count)
//        return Array(viewModel.logs[start..<end])
//    }
//
//    var body: some View {
//        VStack {
//            ScrollView(.horizontal, showsIndicators: true) {
//                VStack(alignment: .leading, spacing: 0) {
//                    // MARK: Table Header
//                    HStack(spacing: 5) {
//                        Text("ID").bold().frame(width: 50)
//                        Text("Status").bold().frame(width: 100)
//                        Text("Start Time").bold().frame(width: 150)
//                        Text("UserID").bold().frame(width: 100)
//                        Text("Day").bold().frame(width: 100)
//                        Text("isVoilation").bold().frame(width: 100)
//                        Text("DutyType").bold().frame(width: 100)
//                        Text("Shift").bold().frame(width: 100)
//                        Text("Location").bold().frame(width: 250)
//                        Text("Lat").bold().frame(width: 100)
//                        Text("Long").bold().frame(width: 100)
//                        Text("Vechicle").bold().frame(width: 100)
//                        Text("Odometer").bold().frame(width: 100)
//                        Text("Engine Hrs").bold().frame(width: 100)
//                        Text("Origin").bold().frame(width: 100)
//                        Text("Sync").bold().frame(width: 100)
//                        Text("VechicleID").bold().frame(width: 100)
//                        Text("Trailers").bold().frame(width: 100)
//                        Text("Notes").bold().frame(width: 100)
//                        Text("ServerId").bold().frame(width: 100)
//                        Text("TimesTamp").bold().frame(width: 100)
//                        Text("identifier").bold().frame(width: 100)
//                        Text("RemaningWeeklyTime").bold().frame(width: 120)
//                        Text("remainingDriveTime").bold().frame(width: 120)
//                        Text("remainingDutyTime").bold().frame(width: 120)
//                        Text("remainingSleepTime").bold().frame(width: 120)
//                        Text("isSplit").bold().frame(width: 80)
//                        Text("engineStatus").bold().frame(width: 120)
//                    }
//                    .background(Color.gray.opacity(0.2))
//                    .padding(.vertical, 5)
//
//                    // MARK: Table Rows
//                    ScrollView(.vertical, showsIndicators: true) {
//                        VStack(spacing: 0) {
//                            ForEach(paginatedLogs) { log in
//                                HStack(spacing: 1) {
//                                    Text("\(log.id ?? -1)").frame(width: 50)
//                                    Divider()
//                                    Text(log.status).frame(width: 100)
//                                    Divider()
//                                    Text(log.startTime).frame(width: 150)
//                                    Divider()
//                                    Text(String(describing: log.userId)).frame(width: 100)
//                                    Divider()
//                                    Text("\(log.day)").frame(width: 100)
//                                    Divider()
//                                    Text("\(log.isVoilation)").frame(width: 100)
//                                    Divider()
//                                    Text(log.dutyType).frame(width: 100)
//                                    Divider()
//                                    Text("\(log.shift)").frame(width: 100)
//                                    Divider()
//                                    Text(log.location).frame(width: 250)
//                                    Divider()
//                                    Text("\(log.lat)").frame(width: 100)
//                                    Divider()
//                                    Text("\(log.long)").frame(width: 100)
//                                    Divider()
//                                    Text(log.vehicle).frame(width: 100)
//                                    Divider()
//                                    Text(String(format: "%.1f", log.odometer)).frame(width: 100)
//                                    Divider()
//                                    Text(log.engineHours).frame(width: 100)
//                                    Divider()
//                                    Text(log.origin).frame(width: 100)
//                                    Divider()
//                                    Text(log.isSynced ? "Yes" : "No").frame(width: 100)
//                                    Divider()
//                                    Text(String(describing: log.vehicleId)).frame(width: 100)
//                                    Divider()
//                                    Text(log.trailers).frame(width: 100)
//                                    Divider()
//                                    Text(log.notes).frame(width: 100)
//                                    Divider()
//                                    Text(String(describing: log.serverId)).frame(width: 100)
//                                    Divider()
//                                    Text("\(log.timestamp)").frame(width: 100)
//                                    Divider()
//                                    Text("\(log.identifier)").frame(width: 100)
//                                    Divider()
//                                    Text(log.remainingWeeklyTime ?? "").frame(width: 120)
//                                    Divider()
//                                    Text(log.remainingDriveTime ?? "").frame(width: 120)
//                                    Divider()
//                                    Text(log.remainingDutyTime ?? "").frame(width: 120)
//                                    Divider()
//                                    Text(log.remainingSleepTime ?? "").frame(width: 120)
//                                    Divider()
//                                    Text("\(log.isSplit)").frame(width: 80)
//                                    Divider()
//                                    Text(log.engineStatus).frame(width: 100)
//                                }
//                                Divider()
//                                    .background(Color.white)
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            Divider()
//
//            // Pagination Controls
//            HStack {
//                Button("Previous") {
//                    if currentPage > 0 {
//                        currentPage -= 1
//                    }
//                }
//                .disabled(currentPage == 0)
//
//                Spacer()
//
//                Text("Page \(currentPage + 1) of \((viewModel.logs.count + logsPerPage - 1) / logsPerPage)")
//                    .bold()
//
//                Spacer()
//
//                Button("Next") {
//                    if (currentPage + 1) * logsPerPage < viewModel.logs.count {
//                        currentPage += 1
//                    }
//                }
//                .disabled((currentPage + 1) * logsPerPage >= viewModel.logs.count)
//
//                Button("Clear All Logs") {
//                    showConfirmation = true
//                }
//                .alert("Are you sure?", isPresented: $showConfirmation) {
//                    Button("Delete All", role: .destructive) {
//                        DatabaseManager.shared.deleteAllTimerLogs()
//                    }
//                    Button("Cancel", role: .cancel) {}
//                }
//
//            }
//            .padding()
//        }
//        .onAppear {
//            viewModel.loadLogs()
//        }
//    }
//}

//struct TableCell: View {
//    var text: String
//    var width: CGFloat
//
//    var body: some View {
//        Text(text)
//            .frame(width: width, height: 40)
//            .background(Color.white)
//            .border(Color.gray, width: 0.5)
//    }
//}

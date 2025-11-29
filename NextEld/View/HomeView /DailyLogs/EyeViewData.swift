//
//  EyeViewData.swift
//  NextEld
//
//  Created by Priyanshi   on 23/05/25.
//

import SwiftUI

struct EyeViewData: View {
    
   // @State var tittle: String
    @EnvironmentObject var navManager: NavigationManager
    @StateObject var viewModel = DriverStatusViewModel(networkManager: NetworkManager.shared)
    @StateObject private var homeVM : HomeViewModel = .init()
    var title: String
    let entry: WorkEntry
    @State private var selectedDate: Date
  
    init(title: String, entry: WorkEntry) {
        self.title = title
        self.entry = entry
        self._selectedDate = State(initialValue: entry.date)
    }


    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 2)
            }
            
            ZStack(alignment: .top) {
                Color(uiColor: .wine)
                    .frame(height: 50)
                    .shadow(color:  Color(uiColor:.black).opacity(0.2), radius: 4, x: 0, y: 4)
                HStack {
                    Button(action: {
                        navManager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor( Color(uiColor:.white))
                            .imageScale(.large)
                    }
                    Spacer()
                    //MARK: - previous page click date show
                    // Text(DateUtils.formatDate(entry.date, format: "dd-MM-yyyy"))
                    Text(title)
                        .font(.headline)
                        .foregroundColor( Color(uiColor:.white))
                        .fontWeight(.semibold)
                    Spacer()

                }
                .padding(.horizontal)
                .frame(height: 50)
                .alignmentGuide(.top) { _ in 0 }
            }
            
            //MARK: -  show a date Format
            HStack {
                DateStepperView(currentDate: $selectedDate)
            }
            .background(Color.white.shadow(radius: 5))
            // ScrollView content - takes remaining space
            
            Group {
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Loading...")
                        Text("Fetching data...")
                            .font(.caption)
                            .foregroundColor( Color(uiColor:.gray))
                            .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let d = viewModel.data?.result?.first {
                    UniversalScrollView {
                        // Section 1: Driver Info
                        sectionGrid(
                            headers: ["Driver Name", "Driver ID", "Driver License", "Driver License State"],
                            values: [
                                d.driverName ?? "NA",
                                d.email ?? "NA",
                                d.cdlNo ?? "NA",
                                d.stateName ?? "NA"
                            ]
                        )

                        sectionGrid(
                            headers: ["Exempt Driver Status", "Unidentified Driving Records", "Co-Driver", "Co-Driver ID"],
                            values: [
                                d.exempt ?? "NA",
                                "\(d.isSystemGenerated ?? 0)",
                                d.coDriverName ?? "NA",
                                d.companyCoDriverId ?? "NA"
                            ]
                        )
                        
                        let todayString: String = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            return formatter.string(from: Date()) // system date
                        }()

                        let selectedDateString: String = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "dd-MM-yyyy"
                            return formatter.string(from: selectedDate) // your date stepper's selected date
                        }()
                        
                        // Section 2: Log Info
                        sectionGrid(
                            headers: ["Log Date", "Display Date", "Display Location", "Driver Certified"],
                            values: [
                                selectedDateString, //MARK:  Always the date stepper's selected date
                                todayString,        //MARK: -  Always today's date
                                d.customLocation ?? "NA",
                                d.certifiedSignatureName ?? "No"
                            ]
                        )
                        // Section 3: ELD Info
                        sectionGrid(
                            headers: ["Eld Registration ID", "ELD Identifier", "Provider"],
                            values: [
                                d.eldRegistrationId ?? "NA",
                                d.eldIdentifier ?? "NA",
                                d.eldProvider ?? "NA"
                            ]
                        )
                        sectionGrid(
                            headers: ["24 Period Starting Time", "Data Dig. Indicators", "Device Malfn. Indicators"],
                            values: [
                                d.periodStartingTime ?? "00:00",
                                d.diagnosticIndicator ?? "NA",
                                d.malfunctionIndicator ?? "NA"
                            ]
                        )
                        sectionGrid(
                            headers: ["Vehicle", "VIN", "Odometer", "Distance"],
                            values: [
                                d.truckNo ?? "NA",
                                d.vin ?? "",
                                "\(d.odometer ?? 0)",
                                "\(d.distance ?? 0)"
                            ]
                        )
                        sectionGrid(
                            headers: ["Trailer", "Shipping Docs", "Carrier", "Main Office"],
                            values: [
                                d.trailers?.joined(separator: ", ") ?? "",
                                d.shippingDocs?.joined(separator: ", ") ?? "",
                                d.carrier ?? "NA",
                                d.mainOffice ?? "NA"
                            ]
                        )

                        sectionGrid(
                            headers: ["Engine Hours", "Home Terminal"],
                            values: [
                                d.engineHour ?? "0",
                                d.mainTerminalName ?? "NA"
                            ]
                        )

                        VStack {
                            HOSEventsChartScreen(events: homeVM.graphEvents)
                        }

                        VStack(alignment: .leading) {
                            Text("Version - \(d.version ?? "NA")")
                        }

                        sectionSmallGrid(
                            smallheaders: ["Time", "Status","Location","Origin","OdoMeter","Engine Hours","Engine","Notes"],
                            smallvalues: [
                                d.dateTime ?? "NA",
                                d.status ?? "NA",
                                d.customLocation ?? "NA",
                                d.origin ?? "NA",
                                "\(d.odometer ?? 0)",
                                d.engineHour ?? "0",
                                d.engineStatus ?? "NA",
                                d.note ?? ""
                            ]
                        )
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor( Color(uiColor:.orange))
                        Text(error)
                            .foregroundColor( Color(uiColor:.gray))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(spacing: 12) {
                        
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundColor( Color(uiColor:.gray))
                        Text("No data available")
                            .foregroundColor( Color(uiColor:.gray))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        
        .task {
            print(" EyeViewData: Starting to fetch driver data...")
            await fetchDriverData()
            print(" EyeViewData: Fetch completed")
            print("   isLoading: \(viewModel.isLoading)")
            print("   hasData: \(viewModel.data != nil)")
            print("   resultCount: \(viewModel.data?.result?.count ?? 0)")
            if let first = viewModel.data?.result?.first {
                print("   First record - Driver: \(first.driverName ?? "nil")")
            }
        }
        .onChange(of: selectedDate) { newDate in
            let today = Calendar.current.startOfDay(for: Date())
            let picked = Calendar.current.startOfDay(for: newDate)

            if picked > today {
                // Prevent going beyond today
                selectedDate = today
            } else {
                Task {
                    await fetchDriverData()
                }
            }
        }
    }
    
    private func fetchDriverData() async {
        await viewModel.fetch(
            driverId: String(AppStorageHandler.shared.driverId ?? 0),
            date: selectedDate,
            token: AppStorageHandler.shared.authToken ?? ""
        
        )

    }

    private func loadGraphEventsFromDatabase(for date: Date) -> [HOSEvent] {
        let startOfDay = DateTimeHelper.startOfDay(for: date)
        let endOfDay = DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

        let dutyLogs = DatabaseManager.shared.fetchDutyEvents(for: date)
        guard !dutyLogs.isEmpty else {
            return []
        }

        let events = dutyLogs.enumerated().map { index, log -> HOSEvent in
            let nextStart = index == dutyLogs.count - 1 ? endOfDay : dutyLogs[index + 1].startTime
            let status = DriverStatusType(fromName: log.status) ?? .offDuty
            return HOSEvent(
                id: log.id,
                x: max(log.startTime, startOfDay),
                event_end_time: min(nextStart, endOfDay),
                dutyType: status
            )
        }

        return events
    }

    private func buildEvents(from records: [DriverStatus], for date: Date) -> [HOSEvent] {
        let startOfDay = DateTimeHelper.startOfDay(for: date)
        let endOfDay = DateTimeHelper.calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let sortedRecords = records.compactMap { record -> (DriverStatus, Date)? in
            if let utc = record.utcDateTime {
                let date = Date(timeIntervalSince1970: TimeInterval(utc) / 1000)
                return (record, date)
            } else if let dateString = record.dateTime, let parsed = formatter.date(from: dateString) {
                return (record, parsed)
            }
            return nil
        }
        .sorted { $0.1 < $1.1 }

        guard !sortedRecords.isEmpty else {
            return loadGraphEventsFromDatabase(for: date)
        }

        let events: [HOSEvent] = sortedRecords.enumerated().map { index, element in
            let record = element.0
            let startTime = max(element.1, startOfDay)
            let nextTime = index == sortedRecords.count - 1 ? endOfDay : sortedRecords[index + 1].1
            let endTime = min(nextTime, endOfDay)
            let dutyType = DriverStatusType(fromName: record.status ?? "") ?? .offDuty
            let identifier = record.statusId ?? record.driverId ?? index
            return HOSEvent(
                id: identifier,
                x: startTime,
                event_end_time: endTime,
                dutyType: dutyType
            )
        }

        return events
    }

    }

        //MARK: -  Reusable Section Grid
        @ViewBuilder
        func sectionGrid(headers: [String], values: [String]) -> some View {
            VStack(spacing: 0) {
                // Header row with single background
                HStack {
                    ForEach(headers, id: \.self) { header in
                        Text(header)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                .background(Color.gray.opacity(0.2)) // <-- Apply to entire header row
                
                // Values row
                HStack(alignment: .top) {
                    ForEach(values, id: \.self) { value in
                        Text(value)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                
                Divider()
            }
        }
        
        //MARK: - For samll Details
        
        func sectionSmallGrid(smallheaders: [String], smallvalues: [String]) -> some View {
            VStack(spacing: 0) {
                // Header row with single background
                HStack {
                    ForEach(smallheaders, id: \.self) { header in
                        Text(header)
                            .font(.caption)
                        // .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
        .background(Color.gray.opacity(0.2)) // <-- Apply to entire header row
        
        // Values row
        HStack(alignment: .top) {
            ForEach(smallvalues, id: \.self) { value in
                Text(value)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6)
            }
        }
        Divider()
    }
}

// MARK: - Preview
#Preview {
    let sampleEntry = WorkEntry(date: Date(), hoursWorked: 8.5)
    let navManager = NavigationManager()
    
    return EyeViewData(title: "Daily Logs", entry: sampleEntry)
        .environmentObject(navManager)
}











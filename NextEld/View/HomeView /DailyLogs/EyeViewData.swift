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
    @State private var selectedDate: Date
    @State private var databaseLogs: [DriverLogModel] = []
    @State private var certifyLogs: [CertifyRecord] = []
  
    init(title: String, date: Date) {
        self.title = title
        self._selectedDate = State(initialValue: date)
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
                                d.companyDriverId ?? "NA",
                                d.cdlNo ?? "NA",
                                d.stateName ?? "NA"
                            ]
                        )

                        sectionGrid(
                            headers: ["Exempt Driver Status", "Unidentified Driving Records", "Co-Driver", "Co-Driver ID"],
                            values: [
                                d.exempt ?? "NA",
                                //"\(d.isSystemGenerated ?? 0)",
                                (d.certifiedSignature?.isEmpty == false) ? "Yes" : "No",
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
                                (d.certifiedSignature?.isEmpty == false) ? "Yes" : "No"
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
                            headers: [/*"24 Period Starting Time"*/ "Data Dig. Indicators", "Device Malfn. Indicators"],
                            values: [
                                //d.periodStartingTime ?? "00:00",
                                d.diagnosticIndicator ?? "NA",
                                d.malfunctionIndicator ?? "NA"
                            ]
                        )
                        sectionGrid(
                            headers: ["Vehicle", "VIN", "Odometer", "Distance"],
                            values: [
                                d.truckNo ?? "NA",
                                d.vin ?? "",
                                String(d.odometer ?? 0),
                                String(d.distance ?? 0)
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
                            headers: ["Engine Hours", "Dot No" ,"Home Terminal"],
                            values: [
                                d.engineHour ?? "0",
                                d.dotNo ?? "NA",
                                d.mainTerminalName ?? "NA"
                            ]
                        )

                        VStack {
                            // Use selected date graph events (same as LogsDetails)
                            HOSEventsChartScreen(events: hoseEventsForSelectedDate)
                            .frame(maxWidth: .infinity)
                            VStack(alignment: .leading) {
                                Text(" Version: \(AppInfo.version)(\(AppInfo.build))")
                            }
                        }

                        //MARK: - Violation Boxes (Part of Main Scroll)
                        if !violationsForToday.isEmpty {
                            ViolationsSectionView(violations: violationsForToday)
                        }
                        

                        // Display header once
//                        sectionSmallGridHeader(
//                            smallheaders: ["Time", "Status","Location","Origin","OdoMeter","Engine Hours","Notes"]
//                        )
                        
                        // Display all entries from database
//                       if !databaseLogs.isEmpty {
//                            ForEach(databaseLogs.indices, id: \.self) { index in
//                                let log = databaseLogs[index]
//                                sectionSmallGridRow(
//                                    smallvalues: [
//                                        DateTimeHelper.formatDatabaseDateTime((log.startTime))   /* formatDateTime*/,
//                                        log.status,
//                                        log.location.isEmpty ? "NA" : log.location,
//                                        log.origin.isEmpty ? "NA" : log.origin,
//                                        "\(log.odometer)",
//                                        log.engineHours.isEmpty ? "0" : log.engineHours,
//                                       // log.engineStatus.isEmpty ? "NA" : log.engineStatus,
//                                        log.notes.isEmpty ? "" : log.notes
//                                    ]
//                                )
//                            }
//                        }
                        
                        
//                        if !certifyLogs.isEmpty {
//
//                       
//                            ForEach(certifyLogs.indices, id: \.self) { index in
//                                let log = certifyLogs[index]
//
//                                sectionSmallGridRow(
//                                    smallvalues: [
//                                        DateTimeHelper.formatDateOnly(log.date),
//                                        log.isCertify
//                                    ]
//                                )
//                            }
//                        }
                        var combinedLogs: [UnifiedLog] {
                            
                            let normalLogs = databaseLogs.map { log in
                                UnifiedLog(
                                    date: log.startTime,
                                    status: log.status,
                                    location: log.location.isEmpty ? "NA" : log.location,
                                    origin: log.origin.isEmpty ? "NA" : log.origin,
                                    odometer: "\(log.odometer)",
                                    engineHours: log.engineHours.isEmpty ? "0.0" : log.engineHours,
                                    notes: log.notes
                                )
                            }
                            
                            let certifiedLogs = certifyLogs.map { log in
                                UnifiedLog(
                                    date: log.date,
                                    status: "Certified",
                                    location: "",
                                    origin: "",
                                    odometer: "",
                                    engineHours: "",
                                    notes: ""
                                )
                            }
                            
                            return (normalLogs + certifiedLogs)
                                .sorted { $0.date > $1.date }   // Latest first
                        }

                        // Header
                        sectionSmallGridHeader(
                            smallheaders: [
                                "Time",
                                "Status",
                                "Location",
                                "Origin",
                                "OdoMeter",
                                "Engine Hours",
                                "Notes"
                            ]
                        )

                        // Rows
                        if !combinedLogs.isEmpty {
                            ForEach(combinedLogs) { log in
                                
                                sectionSmallGridRow(
                                    smallvalues: [
                                        DateTimeHelper.formatDatabaseDateTime(log.date),
                                        log.status,
                                        log.location,
                                        log.origin,
                                        log.odometer,
                                        log.engineHours,
                                        log.notes
                                    ]
                                )
                            }
                        }
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
            // print(" EyeViewData: Starting to fetch driver data...")
            await fetchDriverData()
            loadDatabaseLogs()
            loadOnlyCertifyLogs()
            // print(" EyeViewData: Fetch completed")
            // print("   isLoading: \(viewModel.isLoading)")
            // print("   hasData: \(viewModel.data != nil)")
            // print("   resultCount: \(viewModel.data?.result?.count ?? 0)")
            if let first = viewModel.data?.result?.first {
                // print("   First record - Driver: \(first.driverName ?? "nil")")
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
                loadDatabaseLogs()
            }
        }
    }
    //MARK:  to showing voilation box
    private var violationsForToday: [DriverLogModel] {
        let today = selectedDate
        let startOfDay = DateTimeHelper.startOfDay(for: today)
        let endOfDay = DateTimeHelper.endOfDay(for: today) ?? today
        
        let logs = DatabaseManager.shared.fetchLogs(
            filterTypes: [.betweenDates(startDate: startOfDay, endDate: endOfDay)],
            addWarningAndViolation: true
        )
        
        // Filter only violations (status contains "violation" or "warning")
        return logs.filter { log in
            let status = log.status
            return status.contains(AppConstants.violation) || status.contains(AppConstants.warning)
        }.sorted { $0.startTime < $1.startTime }
    }
    
    //MARK: -  fetch vertify Logs
    private func loadOnlyCertifyLogs() {
        let calendar = Calendar.current

        certifyLogs = CertifyDatabaseManager.shared
            .fetchAllRecords()
            .filter {
                calendar.isDate($0.date, inSameDayAs: selectedDate)
            }
            .sorted { $0.date < $1.date }
    }

  


    
    private var logsForSelectedDate: [DriverLogModel] {
        let startDate = DateTimeHelper.startOfDay(for: selectedDate)
        let endDate = DateTimeHelper.endOfDay(for: selectedDate) ?? selectedDate
        let logs = DatabaseManager.shared.fetchLogs(filterTypes: [.betweenDates(startDate: startDate, endDate: endDate)],addWarningAndViolation: true).sorted { $0.startTime < $1.startTime }
        return logs

    }
    private func fetchDriverData() async {
        await viewModel.fetch(
            driverId: String(AppStorageHandler.shared.driverId ?? 0),
            date: selectedDate,
            token: AppStorageHandler.shared.authToken ?? ""
        
        )

    }
    
    private func loadDatabaseLogs() {
        let startOfDay =  DateTimeHelper.startOfDay(for: selectedDate)
        let endOfDay = DateTimeHelper.endOfDay(for: selectedDate) ?? startOfDay
        
        // Fetch logs from database for the selected date
        databaseLogs = DatabaseManager.shared.fetchLogs(
            filterTypes: [.betweenDates(startDate: startOfDay, endDate: endOfDay)],
            addWarningAndViolation: true
        )
        
        // Sort by startTime (oldest first)
        databaseLogs.sort { $0.startTime < $1.startTime }
        
        // print("Loaded \(databaseLogs.count) logs from database for date: \(selectedDate)")
    }
    
    
    
    private var hoseEventsForSelectedDate: [HOSEvent] {
        
        let logs = DatabaseManager.shared.fetchDutyEventsForToday(currentDate: selectedDate)
       // logs.sort { $0.startTime < $1.startTime }
        let events = logs.enumerated().map { index, log in
            let status = DriverStatusType(fromName: log.status) ?? .offDuty
            var endDate = nextLogCalculation()
            if !(index == logs.count-1) {
                let nextIndexLog = logs[index+1]
                endDate = nextIndexLog.startTime
            }
            
            return HOSEvent(
                id: log.id,
                x: log.startTime,
                event_end_time: endDate,
                dutyType: status
            )
        }
        return events
    }
    
    //MARK: -  to show  certifyLogView
    func nextLogCalculation() -> Date {
        let selectedDateIsInTodaysDate = DateTimeHelper.currentCalendar.isDateInToday(selectedDate)
        if selectedDateIsInTodaysDate {
            return DateTimeHelper.currentDateTime()
        } else {
            return DateTimeHelper.endOfDay(for: selectedDate)?.addingTimeInterval(-1) ?? DateTimeHelper.currentDateTime()
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
        //MARK: - Small Grid Header Only
        func sectionSmallGridHeader(smallheaders: [String]) -> some View {
            VStack(spacing: 0) {
                HStack {
                    ForEach(smallheaders, id: \.self) { header in
                        Text(header)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                    }
                }
                .background(Color.gray.opacity(0.2))
            }
        }
        //MARK: - Small Grid Row Only
        func sectionSmallGridRow(smallvalues: [String]) -> some View {
            VStack(spacing: 0) {
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
}

// MARK: - Preview
#Preview {
    let navManager = NavigationManager()
    EyeViewData(title: "Daily Logs", date: Date())
        .environmentObject(navManager)
}



struct UnifiedLog: Identifiable {
    let id = UUID()
    let date: Date
    let status: String
    let location: String
    let origin: String
    let odometer: String
    let engineHours: String
    let notes: String
}





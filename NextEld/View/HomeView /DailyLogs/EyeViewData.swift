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
 
    var title: String
    let entry: WorkEntry
    @State private var selectedDate: Date
    
    init(title: String, entry: WorkEntry) {
        self.title = title
        self.entry = entry
        self._selectedDate = State(initialValue: entry.date)
    }


    var body: some View {
        
        VStack(spacing:0){
            ZStack(alignment: .topLeading){
                Color(uiColor: .wine)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height:2)
                
            }
           

            ZStack(alignment: .top) {
                Color(uiColor: .wine)
                    .frame(height: 50)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                HStack {
                    Button(action: {
                        navManager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    Spacer()
                    //MARK: - previous page click date show
                    // Text(DateUtils.formatDate(entry.date, format: "dd-MM-yyyy"))
                    Text(title)
                    
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack(spacing: 5) {
                        CustomIconButton(iconName: "eye_fill_icon", title: "", action: { navManager.navigate(to: .EyeViewData(tittle: "daily Logs", entry: entry))})
                    }
                }
                .padding(.horizontal) // or even remove entirely to test
                .frame(height: 50)
                .alignmentGuide(.top) { _ in 0 } // optional, helps align precisely


//                .padding()
            }
            //MARK: -  show a date Format
            HStack{
                DateStepperView(currentDate: $selectedDate)
            }  .background(Color.white.shadow(radius: 5))
            Spacer()
            
            
            if viewModel.isLoading {
                            ProgressView("Loading...")
                                .padding()
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
                                        selectedDateString, //MARK:  Always the date stepper’s selected date
                                        todayString,        //MARK: -  Always today's date
                                        d.customLocation ?? "NA",
                                        d.certifiedSignatureName ?? "No"
                                    ]
                                )
                                
                                
//                                sectionGrid(
//                                    headers: ["Log Date", "Display Date", "Display Location", "Driver Certified"],
//                                    values: [
//                                        d.dateTime ?? "NA",
//                                        DateUtils.formatDate(Date(), format: "dd-MM-yyyy"), // Always today's date
//                                        d.customLocation ?? "NA",
//                                        d.certifiedSignatureName ?? "No"
//                                    ]
//                                )


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
                                    HOSEventsChartScreen(currentStatus: nil)
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
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                        }
                    }.navigationBarBackButtonHidden()

        
            .task {
               
                await fetchDriverData()
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
            driverId: String(DriverInfo.driverId ?? 0),
            date: selectedDate,
            token: DriverInfo.authToken
        
        )
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














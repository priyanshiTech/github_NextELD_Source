//
//  EmailDvir.swift
//  NextEld
//
//  Created by Inurum   on 21/05/25.
//

import SwiftUI

struct EmailDvir: View {
    @EnvironmentObject var navmanager: NavigationManager
    @State var tittle: String
    @State private var records: [DvirRecord] = []
    let updateRecords: [DvirRecord]
    var onSelect: (DvirRecord) -> Void
    @State private var selectedVehicle: String = ""
    
    //MARK: - remove placeholder multiple value  filteredRecords
    
    var filteredRecords: [DvirRecord] {
        updateRecords.filter { record in
            !(record.date == "Current Date" || record.time == "Current Time")
        }
    }

    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading){
                    Color(UIColor.wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height:40)
                }
                // MARK: - Header
                HStack {
                    Button(action: {
                        navmanager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    
                    Spacer()
                    
                    Text("Email DVIR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            selectedVehicle = ""
                            navmanager.navigate(to: .AddDvirScreenView(
                                selectedVehicle: selectedVehicle,
                                selectedRecord: emptyDvirRecord

                            ))
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Button(action: {
                            navmanager.navigate(to: .DvirHostory(tittle: "Dvir History"))
                        }) {
                            Image("email_icon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.wine))
                .shadow(radius: 2)
                
                Divider()
                
                // MARK: - Main Content
                if filteredRecords.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.4))
                        
                        Text("No DVIR Records Available.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredRecords, id: \.id) { record in
                            NavigationLink(
                                destination:AddDvirScreenView(
                                    selectedVehicle: $selectedVehicle,
                                    selectedVehicleupdated: $selectedVehicle,
                                    selectedRecord: record
                                )
                            ) {
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(UIColor.wine))
                                        .padding(.top, 2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(record.date) \(record.time)")
                                            .fontWeight(.semibold)
                                        
                                        Text(record.vehicleCondition)
                                            .foregroundColor(.green)
                                            .font(.subheadline)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    selectedVehicle = record.vehicle
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                records = DvirDatabaseManager.shared.fetchAllRecords()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .navigationViewStyle(StackNavigationViewStyle()) // iPhone/iPad friendly
    }
    
    
    private var emptyDvirRecord: DvirRecord {
        DvirRecord(
            id: nil,
            driver: "",
            time: DateTimeHelper.currentTime(),
            date: DateTimeHelper.currentDate(),
            odometer: "",
            company: "",
            location: "",
            vehicle: "",
            trailer: "",
            truckDefect: "",
            trailerDefect: "",
            vehicleCondition: "",
            notes: "",
            signature: nil
        )
    }
    
}


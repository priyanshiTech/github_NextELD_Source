//
//  EmailDvir.swift
//  NextEld
//
//  Created by priyanshi on 21/05/25.
//
import Foundation
import SwiftUI


struct EmailDvir: View {
    @EnvironmentObject var navmanager: NavigationManager
    @State var tittle: String
    @State private var records: [DvirRecord] = []
    let updateRecords: [DvirRecord]
    var onSelect: (DvirRecord) -> Void
    @State private var selectedDvirRecord:DvirRecord?  = nil
    
    //MARK: - remove placeholder multiple value  filteredRecords
    var filteredRecords: [DvirRecord] {
        updateRecords.filter { record in
            !(record.DAY == "Current Date" || record.DvirTime == "Current Time")
        }
    }
    
    
    
    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                ZStack(alignment: .topLeading){
//                    Color(UIColor.wine)
//                        .edgesIgnoringSafeArea(.top)
//                        .frame(height:40)
//                }
//                // MARK: - Header
//                HStack {
//                    Button(action: {
//                        navmanager.goBack()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.white)
//                            .imageScale(.large)
//                    }
//                    
//                    Spacer()
//                    
//                    Text("Email DVIR")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .bold()
//                    
//                    Spacer()
//                    
//                    HStack(spacing: 16) {
//                        
//                        Button(action: {
//                            selectedVehicle = ""
//                            navmanager.navigate(to: .AddDvirScreenView(
//                                selectedVehicle: "",
//                                selectedRecord: emptyDvirRecord, isFromHome: false   // new record
//                            ))
//                        })
//                        {
//                            
//                            
//                            Image(systemName: "plus")
//                                .foregroundColor(.white)
//                                .imageScale(.large)
//                        }
//                        
//                        Button(action: {
//                            navmanager.navigate(to: .DvirHostory(tittle: "Dvir History"))
//                        }) {
//                            Image("email_icon")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                        }
//                    }
//                }
//                .padding()
//                .background(Color(UIColor.wine))
//                .shadow(radius: 2)
//                
//                Divider()
//                
//                // MARK: - Main Content
//                if filteredRecords.isEmpty {
//                    Spacer()
//                    VStack(spacing: 12) {
//                        Image(systemName: "doc.text.magnifyingglass")
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .foregroundColor(.gray.opacity(0.4))
//                        
//                        Text("No DVIR Records Available.")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    Spacer()
//                } else {
//                    List {
//                        ForEach(filteredRecords, id: \.self) { record in
//                            Button(action: {
//                                selectedVehicle = record.vechicleID
//                                navmanager.navigate(to: .AddDvirScreenView(
//                                    selectedVehicle: selectedVehicle,
//                                    selectedRecord: record,
//                                    isFromHome: false
//                                ))
//                            }) {
//                                HStack(alignment: .top, spacing: 10) {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(Color(UIColor.wine))
//                                        .padding(.top, 2)
//                                    
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("\(record.DAY) \(record.DvirTime)")
//                                            .fontWeight(.semibold)
//                                        
//                                        Text(record.vehicleCondition)
//                                            .foregroundColor(.green)
//                                            .font(.subheadline)
//                                    }
//                                }
//                                .padding(.vertical, 6)
//                            }
//                        }
//
//                        .listStyle(PlainListStyle())
//                    }
//                    .edgesIgnoringSafeArea(.top)
//                }
//                   
//                    .onAppear {
//                        records = DvirDatabaseManager.shared.fetchAllRecords()
//                    }
//            }
//            .navigationBarHidden(true)
//            .navigationBarBackButtonHidden()
//            .navigationViewStyle(StackNavigationViewStyle()) // iPhone/iPad friendly
//        }
            
            
            VStack(spacing: 0) {
                //                ZStack(alignment: .topLeading) {
                //                    Color(UIColor.wine)
                //                        .edgesIgnoringSafeArea(.top)
                //                        .frame(height: 40)
                //                }
                
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
                            
                            navmanager.path.append(AppRoute.DvirFlow.AddDvirScreenView)
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Button(action: {
               
                            navmanager.path.append(AppRoute.DvirFlow.DvirHostory(tittle: AppConstants.dvirHostoryTittle))
                          
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
                    List(filteredRecords, id: \.self) { record in
                        Button(action: {
                            selectedDvirRecord = record
                            navmanager.path.append(AppRoute.DvirFlow.AddDvirScreenView)
                            //                            navmanager.navigate(to: AppRoute.HomeFlow.AddDvirScreenView(
                            //                                selectedVehicle: selectedVehicle,
                            //                                selectedRecord: record,
                            //                                isFromHome: false
                            //                            ))
                            
                            
                            //                            navmanager.navigate(to: .vehicleFlow(.AddDvirScreenView(
                            //                                                                       selectedVehicle: selectedVehicle,
                            //                                                                       selectedRecord: record,
                            //                                                                       isFromHome: false
                            //                                                                   )))
                        }) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(UIColor.wine))
                                    .padding(.top, 2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(record.DAY) \(record.DvirTime)")
                                        .fontWeight(.semibold)
                                    
                                    Text(record.vehicleCondition)
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .edgesIgnoringSafeArea(.top)
                }
            }
           
            .onAppear {
                records = DvirDatabaseManager.shared.fetchAllRecords()
            }
        .navigationBarHidden(true)

        .navigationDestination(for: AppRoute.DvirFlow.self, destination: { type in
            switch type {
            case .AddDvirScreenView:
                AddDvirScreenView( selectedRecord:$selectedDvirRecord,isFromHome:false)
                
            case .DvirHostory(tittle: AppConstants.dvirHostoryTittle):
                  DVIRHistory(title: AppConstants.dvirHostoryTittle)
                 
            default:
                EmptyView()
            }
            
        })
        
        var emptyDvirRecord: DvirRecord {
            DvirRecord(
                id: nil,
                UserID: "",
                UserName: "",
                startTime: "\(DateTimeHelper.currentDate()) \(DateTimeHelper.currentTime())",
                DAY: DateTimeHelper.currentDate(),
                Shift: "1",
                DvirTime: DateTimeHelper.currentTime(),
                odometer: 0.0,
                location: "",
                truckDefect: "",
                trailerDefect: "",
                vehicleCondition: "",
                notes: "",
                vehicleName: "",
                vechicleID: "",
                Sync: 0,
                timestamp: "\(Int(Date().timeIntervalSince1970 * 1000))",
                Server_ID: "",
                Trailer: "",
                signature: nil
                
            )
        }
        
        
    }
}

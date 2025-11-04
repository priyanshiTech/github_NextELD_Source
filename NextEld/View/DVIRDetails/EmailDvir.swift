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
    @StateObject var trailerVM: TrailerViewModel = .init()
    
    //MARK: - remove placeholder multiple value  filteredRecords
    var filteredRecords: [DvirRecord] {
        updateRecords.filter { record in
            !(record.DAY == "Current Date" || record.DvirTime == "Current Time")
        }
    }
    
    
    
    var body: some View {
            
            VStack(spacing: 0) {
           
                
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
                        DvirListItemView(
                            record: record,
                            onTap: {
                                selectedDvirRecord = record
                                navmanager.path.append(AppRoute.DvirFlow.AddDvirScreenView)
                            },
                            onViewDefect: {
                                selectedDvirRecord = record
                                navmanager.path.append(AppRoute.DvirFlow.UploadDefectView)
                            }
                        )
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
                AddDvirScreenView( selectedRecord:$selectedDvirRecord,trailers: $trailerVM.trailers, isFromHome:false)
                
            case .UploadDefectView:
                UploadDefectView(selectedRecord: selectedDvirRecord)
                
            case .DvirHostory(tittle: AppConstants.dvirHostoryTittle):
                  DVIRHistory(title: AppConstants.dvirHostoryTittle)
                
            case .trailerScreen:
                TrailerView(trailerVM: trailerVM, tittle: AppConstants.trailersTittle, trailers: $trailerVM.trailers)
                
            case .ShippingDocment:
                ShippingDocView(tittle: AppConstants.shippingTittle)
                
            case .AddVehicleForDVIR:
             

                AddVehicleForDvir(selectedVehicleNumber: .constant(""), VechicleID: .constant(Int(selectedDvirRecord?.vechicleID ?? "0") ?? 0))
                 
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

// MARK: - DVIR List Item View
struct DvirListItemView: View {
    let record: DvirRecord
    let onTap: () -> Void
    let onViewDefect: () -> Void
    
    // Helper to check if has defects
    private var hasDefects: Bool {
        // Check if truck has defects (comma-separated list, "yes", or defect name)
        let truckDefectValue = record.truckDefect.trimmingCharacters(in: .whitespaces).lowercased()
        let hasTruckDefects = truckDefectValue != "no" && !truckDefectValue.isEmpty && truckDefectCount > 0
        
        // Check if trailer has defects (comma-separated list, "yes", or defect name)
        let trailerDefectValue = record.trailerDefect.trimmingCharacters(in: .whitespaces).lowercased()
        let hasTrailerDefects = trailerDefectValue != "no" && !trailerDefectValue.isEmpty && trailerDefectCount > 0
        
        // Check if vehicleCondition indicates defects (Unsatisfactory)
        let isUnsatisfactory = record.vehicleCondition.lowercased().contains("unsatisfactory")
        
        return hasTruckDefects || hasTrailerDefects || isUnsatisfactory
    }
    
    // Helper to get truck defect count
    private var truckDefectCount: Int {
        let defectValue = record.truckDefect.trimmingCharacters(in: .whitespaces)
        
        // If "no" or empty, no defects
        if defectValue.lowercased() == "no" || defectValue.isEmpty {
            return 0
        }
        
        // If comma-separated list (e.g., "Defect1, Defect2, Defect3"), count the items
        if defectValue.contains(",") {
            let defects = defectValue.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.lowercased() != "yes" && $0.lowercased() != "no" }
            return defects.count
        }
        
        // If "yes" or "y", return 1 (legacy support)
        if defectValue.lowercased() == "yes" || defectValue.lowercased() == "y" {
            return 1
        }
        
        // If it's a single defect name (not "yes" or "no"), count as 1
        if !defectValue.isEmpty {
            return 1
        }
        
        return 0
    }
    
    private var trailerDefectCount: Int {
        let defectValue = record.trailerDefect.trimmingCharacters(in: .whitespaces)
        
        // If "no" or empty, no defects
        if defectValue.lowercased() == "no" || defectValue.isEmpty {
            return 0
        }
        
        // If comma-separated list (e.g., "Defect1, Defect2, Defect3"), count the items
        if defectValue.contains(",") {
            let defects = defectValue.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.lowercased() != "yes" && $0.lowercased() != "no" }
            return defects.count
        }
        
        // If "yes" or "y", return 1 (legacy support)
        if defectValue.lowercased() == "yes" || defectValue.lowercased() == "y" {
            return 1
        }
        
        // If it's a single defect name (not "yes" or "no"), count as 1
        if !defectValue.isEmpty {
            return 1
        }
        
        return 0
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 10) {
                // Icon based on defect status
                Image(systemName: hasDefects ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(hasDefects ? .red : .blue)
                    .font(.title2)
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 6) {
                    // Date and Time
                    Text("\(record.DAY) \(record.DvirTime)")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    // Vehicle Condition Status
                    Text(record.vehicleCondition.isEmpty ? (hasDefects ? "Defects Need Not Be Corrected" : "Vehicle Condition Satisfactory") : record.vehicleCondition)
                        .foregroundColor(hasDefects ? .red : .green)
                        .font(.subheadline)
                        .fontWeight(hasDefects ? .regular : .regular)
                    
                    // Vehicle and Trailer info with defect counts
                    VStack(alignment: .leading, spacing: 4) {
                        // Truck/Vehicle info
                        HStack(spacing: 4) {
                            Text("Vehicle - \(record.vehicleName.isEmpty ? "N/A" : record.vehicleName)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            if truckDefectCount > 0 {
                                Text("\(truckDefectCount) Defects")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .fontWeight(.none)
                            }
                        }
                        
                        // Trailer info
                        HStack(spacing: 4) {
                            let trailerNames = record.Trailer.isEmpty ? "None" : record.Trailer
                            Text("Trailer - \(trailerNames)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            if trailerDefectCount > 0 {
                                Text("\(trailerDefectCount) Defects")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .fontWeight(.none)
                            }
                        }
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
                
                // View Defect button - only show if has defects
                if hasDefects {
                    Button(action: onViewDefect) {
                        Text("View Defects")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                           // .background(Color.red)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 2)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

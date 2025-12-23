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
    var onSelect: (DvirRecord) -> Void
    @State private var selectedDvirRecord:DvirRecord?  = nil
    @StateObject var trailerVM: TrailerViewModel = .init()
    
    //MARK: - remove placeholder multiple value  filteredRecords
    
//    var filteredRecords: [DvirRecord] {
//        let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
//        return allRecords
//    }
    
    var filteredRecords: [DvirRecord] {
        let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
        
        return allRecords.sorted {
            let t1 = Int64($0.timestamp) ?? 0
            let t2 = Int64($1.timestamp) ?? 0
            return t1 > t2
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
                            // Clear selected record to ensure new record with current date/time
                            selectedDvirRecord = nil
                            navmanager.path.append(AppRoute.HomeFlow.AddDvirScreenView(vm: trailerVM, selectedRecord: selectedDvirRecord))
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Button(action: {
               
                            navmanager.path.append(AppRoute.HomeFlow.DvirHostory(tittle: AppConstants.dvirHostoryTittle))
                          
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
                                navmanager.path.append(AppRoute.HomeFlow.AddDvirScreenView(vm: trailerVM, selectedRecord: selectedDvirRecord))
                            },
                            onViewDefect: {
                                // Fetch latest record from database to get updated defects
                                let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
                                
                                // Try to find updated record by ID first
                                if let recordId = record.id,
                                   let updatedRecord = allRecords.first(where: { $0.id == recordId }) {
                                    // print("  Using updated record from database - ID: \(recordId)")
                                    // print("   Truck Defect: '\(updatedRecord.truckDefect)'")
                                    // print("   Trailer Defect: '\(updatedRecord.trailerDefect)'")
                                    selectedDvirRecord = updatedRecord
                                } else {
                                    // If no ID or record not found, use latest record (highest ID)
                                    let sortedRecords = allRecords.sorted { record1, record2 in
                                        let id1 = record1.id ?? 0
                                        let id2 = record2.id ?? 0
                                        return id1 > id2  // Latest first
                                    }
                                    if let latestRecord = sortedRecords.first {
                                        // print("  Using LATEST record from database - ID: \(latestRecord.id ?? -1)")
                                        // print("   Truck Defect: '\(latestRecord.truckDefect)'")
                                        // print("   Trailer Defect: '\(latestRecord.trailerDefect)'")
                                        selectedDvirRecord = latestRecord
                                    } else {
                                        // Fallback to original record
                                        selectedDvirRecord = record
                                    }
                                }
                                if let selectedDvirRecord {
                                    navmanager.path.append(AppRoute.HomeFlow.UploadDefectView(dvirRecord: selectedDvirRecord))
                                }
                               
                            }
                        )
                    }
                    .listStyle(PlainListStyle())
                    .edgesIgnoringSafeArea(.top)
                }
            }
           
            
//            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DVIRRecordUpdated"))) { _ in
//                // Refresh records when DVIR is added/updated
//                records = DvirDatabaseManager.shared.fetchAllRecords()
//                // print(" EmailDvir: Records refreshed after DVIR update - Total: \(records.count)")
//            }
            
        .navigationBarHidden(true)


        
        var emptyDvirRecord: DvirRecord {
            DvirRecord(
                id: nil,
                UserID: "",
                UserName: "",
                startTime: DateTimeHelper.currentDateTime(),
                DAY: AppStorageHandler.shared.days,
                Shift: AppStorageHandler.shared.shift,
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
                   Text("\(record.startTime.toLocalString(format: .dateOnlyFormat)) \(record.DvirTime)")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(Color(uiColor:.black))
                    
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
                                .foregroundColor(Color(uiColor:.black))
                            
                            if truckDefectCount > 0 {
                                Text("\(truckDefectCount) Defects")
                                    .font(.subheadline)
                                    .foregroundColor(Color(uiColor:.red))
                                    .fontWeight(.none)
                            }
                        }
                        
                        // Trailer info
                        HStack(spacing: 4) {
                            let trailerNames = record.Trailer.isEmpty ? "None" : record.Trailer
                            Text("Trailer - \(trailerNames)")
                                .font(.subheadline)
                                .foregroundColor(Color(uiColor:.black))
                            
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
                           //.background(Color.red)
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

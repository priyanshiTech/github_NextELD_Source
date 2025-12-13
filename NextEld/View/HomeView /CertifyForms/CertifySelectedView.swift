//
//  CertifySelectedView.swift
//  NextEld
//
//  Created by priyanshi  on 19/05/25.
//
import SwiftUI
import Foundation
 
struct CertifySelectedView: View {
    
    // MARK: - States
    @State private var selectedTab = "Form"
    @State private var trailer = ""
    @State private var shippingDocs = "docwriting"
    @State private var coDriver = "none"
    @State private var selectedCoDriverName: String? = nil
    @State private var selectedCoID: Int? = nil
    @State private var syncstatus:Int? = nil
    @State private var SelectedTraller: String? = nil
    @State private var SelectedSheeping: String? = nil
    @State private var SelectedVechicle: String? = nil
    @State private var showSignaturePad = false
    @State private var signaturePath = Path()
    @State private var showCoDriverPopup = false
    @Binding var vehiclesc: String
    @Binding var VechicleID: Int?
    @EnvironmentObject var navManager: NavigationManager
    //@EnvironmentObject var trailerVM: TrailerViewModel
    @StateObject private var trailerVM = TrailerViewModel()
    @StateObject var shippingVM = ShippingDocViewModel()
    @State private var selectedCoDriverEmail: String = "" //Hidden Email
    @State private var certifiedDate: Date = Date()
    @State private var isCertified: Bool = false
    @State private var isCertify: String = "No" //Default "No"
    @State private var hasLoadedInitialData = false


    var title: String
    
    private var logsEntry: WorkEntry {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if let date = formatter.date(from: title) {
            return WorkEntry(date: date, hoursWorked: 0)
        }
        return WorkEntry(date: Date(), hoursWorked: 0)
    }
    
    var body: some View {
        ZStack { // Root ZStack to overlay popup
            VStack(spacing: 0) {
                
                // MARK: - Top Bar
                ZStack(alignment: .topLeading){
                    Color(UIColor.wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 30)
                }
                
                ZStack(alignment: .top) {
                    Color(UIColor.wine)
                        .frame(height: 50)
                        .shadow(color: Color(uiColor:.black).opacity(0.2), radius: 4, x: 0, y: 4)
                    
                    HStack {
                        Button(action: { navManager.goBack() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color(uiColor:.white))
                                .imageScale(.large)
                        }.padding()

                      //  Button(action: {
                       //     navManager.navigate(to: .DatabaseCertifyView)
                      //  }) {
                        
                            Text(title)
                                .font(.headline)
                                .foregroundColor(Color(uiColor:.white))
                                .fontWeight(.semibold)
                  //      }

                        
                        Spacer()
                        CustomIconButton(
                            iconName: "alarm_icon",
                            title: "Event",
                            action: {
                                navManager.navigate(
                                    to: AppRoute.HomeFlow.LogsDetails(
                                        title: "Daily Log",
                                        entry: logsEntry
                                    )
                                )
                            }
                        )
                        .padding()
                    }
                }
                
                Spacer(minLength: 20)
                
                // MARK: - Tabs
                HStack(spacing: 0) {
                    Button("Form") {
                        selectedTab = "Form"
                        showSignaturePad = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Form" ? Color(UIColor.wine) : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Form" ? Color(uiColor:.white) : Color(uiColor:.black))
                    
                    Button("Certify") {
                        selectedTab = "Certify"
                        showSignaturePad = true
                        showCoDriverPopup = false // hide popup
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Certify" ? Color(UIColor.wine) : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Certify" ? Color(uiColor:.white) : Color(uiColor:.black))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(5)
                .padding(.horizontal)
                Spacer()
                
                
                // MARK: - Form Tab Content"
                if selectedTab == "Form" {
                    VStack(spacing: 10) {
                        FormField(label: "Driver", value: .constant("\(AppStorageHandler.shared.driverName ?? "not found" )- \(AppStorageHandler.shared.driverId ?? 0)"), editable: false)
                        FormField(
                            label: "Vehicle",
                            value: $vehiclesc , // Direct binding
                            editable: true
                        ) {
                            hasLoadedInitialData = false
                            navManager.path.append(AppRoute.HomeFlow.AddVehicleForDVIR(vehicleID: self.VechicleID ?? 0, vehicleNo: vehiclesc))
                        }



                        FormField(
                            label: "Trailer",
                            value: Binding(
                                get: {
                                    if trailerVM.trailers.isEmpty {
                                        return "None"
                                    } else {
                                        return trailerVM.trailers.prefix(10).joined(separator: ", ")  // crashed
                                    }
                                },
                                set: { newValue in
                                    let values = newValue
                                        .split(separator: ",")
                                        .map { $0.trimmingCharacters(in: .whitespaces) }
                                    
                                    if values.isEmpty {
                                        trailerVM.trailers = []
                                    } else {
                                        trailerVM.trailers = Array(values.prefix(10))
                                    }
                                }
                            ),
                            editable: true
                        )
                         {
                             navManager.path.append(AppRoute.HomeFlow.trailerScreen(trailerVM: self.trailerVM))
                        }
                        FormField(
                            label: "Shipping Docs",
                            value: Binding(
                                get: {
                                    if shippingVM.ShippingDoc.isEmpty {
                                        return "None"
                                    } else {
                                        return shippingVM.ShippingDoc.prefix(10).joined(separator: ", ")
                                    }
                                },
                                set: { newValue in
                                    let values = newValue
                                        .split(separator: ",")
                                        .map { $0.trimmingCharacters(in: .whitespaces) }
                                    
                                    if values.isEmpty {
                                        shippingVM.ShippingDoc = []
                                    } else {
                                        shippingVM.ShippingDoc = Array(values.prefix(10))
                                    }
                                }
                            ),
                            editable: true
                        )
                        {
                            navManager.path.append(AppRoute.HomeFlow.ShippingDocment(shippingVM: shippingVM))
                        }

                        FormField(
                            label: "Co-Driver",
                            value: Binding(
                                get: { selectedCoDriverName ?? coDriver},   // UI me sirf name show hoga
                                set: { newValue in
                                    selectedCoDriverName = newValue
                                    // id update popup se karoge (jab user choose kare)
                                }
                            ),
                            editable: true
                        ) {
                            showCoDriverPopup = true
                        }
 
                        Button(action: {
                
                            let record = CertifyRecord(
                                userID: "\(AppStorageHandler.shared.driverId ?? 0)",
                              //  userName: AppStorageHandler.shared.UserName,
                                userName: AppStorageHandler.shared.driverName ?? "not found",
                                date: certifiedDate,
                                shift: AppStorageHandler.shared.shift,
                                selectedVehicle: vehiclesc,
                                selectedTrailer: trailerVM.trailers.isEmpty
                                    ? "None"
                                    : trailerVM.trailers.prefix(10).joined(separator: ", "),
                                selectedShippingDoc: shippingVM.ShippingDoc.isEmpty
                                     ? "None"
                                     : shippingVM.ShippingDoc.prefix(10).joined(separator: ", "),
                                
                               // selectedTrailer: SelectedTraller,
                                selectedCoDriver: selectedCoDriverName ?? "None",
                                vehicleID: VechicleID,
                                coDriverID: selectedCoID,
                                syncStatus: syncstatus ?? 0,
                                isCertify: "No"
                            )
                            CertifyDatabaseManager.shared.saveRecord(record)

                            // Persist latest selections
                            AppStorageHandler.shared.vehicleNo = vehiclesc.isEmpty ? nil : vehiclesc
                            AppStorageHandler.shared.vehicleId = VechicleID ?? AppStorageHandler.shared.vehicleId

                            hasLoadedInitialData = false
                            loadInitialDataIfNeeded(force: true)

                                
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(uiColor: .wine))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
     
                    .onAppear {
                        loadInitialDataIfNeeded()
                    }

                    .padding(.top)
                }
                
                // MARK: - Signature Tab Content

                if selectedTab == "Certify" {

                    SignatureCertifyView(
                        signaturePath: $signaturePath,
                        selectedVehicle: vehiclesc,
                        selectedTrailer: trailerVM.trailers.last ?? "None",
                        selectedShippingDoc: shippingVM.ShippingDoc.last ?? "None",
                        selectedCoDriver: selectedCoDriverName,
                        selectedCoDriverID: selectedCoID,
                        certifiedDate: certifiedDate
                    ) {
                        // Callback when certification is done
                        self.isCertify = "Yes"
                        
                        // optional: re-fetch to confirm
                        let all = CertifyDatabaseManager.shared.fetchAllRecords()
                        if let match = all.first(where: { $0.date == certifiedDate }) {
                            self.isCertify = match.isCertify
                            // print(" DB updated: \(match.isCertify)")
                        }
                        
                        navManager.goBack()
                    }

                    .environmentObject(trailerVM)
                    .environmentObject(shippingVM)
                    .transition(.slide)
                }


                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            
            .edgesIgnoringSafeArea(.top)
            
            // MARK: - CoDriver Popup Overlay (Centered)
            if showCoDriverPopup && selectedTab == "Form" {
                Color(uiColor:.black).opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showCoDriverPopup = false
                    }
                
                SelectCoDriverPopup(
                    selectedCoDriver: $selectedCoDriverName, selectedCodriverID: $selectedCoID ,
                    isPresented: $showCoDriverPopup, selectedCoDriverEmail: $selectedCoDriverEmail,
                )

                .frame(width: 300, height: 400)
                .cornerRadius(12)
                .shadow(radius: 8)
                .position(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2
                )
                .zIndex(1)
            }
        }
    }

    private func loadInitialDataIfNeeded(force: Bool = false) {
        if !force && hasLoadedInitialData { return }
        certifiedDate = title.asDate(format: .dateOnlyFormat) ?? Date()

        if vehiclesc.isEmpty, let storedVehicle = AppStorageHandler.shared.vehicleNo, !storedVehicle.isEmpty {
            vehiclesc = storedVehicle
        }

        if let storedVehicleId = AppStorageHandler.shared.vehicleId {
            if VechicleID == nil || VechicleID == 0 {
                VechicleID = storedVehicleId
            }
        }

        let records = CertifyDatabaseManager.shared.fetchAllRecords()
        if let record = records.first(where: { $0.date == certifiedDate }) {
            if !record.selectedVehicle.isEmpty {
                vehiclesc = record.selectedVehicle
                SelectedVechicle = record.selectedVehicle
            }
                      
            if record.selectedTrailer != "None" && !record.selectedTrailer.isEmpty {
                trailerVM.trailers = record.selectedTrailer
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                SelectedTraller = record.selectedTrailer
            } else {
                trailerVM.trailers = []
            }

            // Load shipping docs from database - preserve user's current changes if they exist
            if shippingVM.ShippingDoc.isEmpty {
                // Only load from database if shippingVM is empty (preserve user's changes)
                if record.selectedShippingDoc != "None" && !record.selectedShippingDoc.isEmpty {
                    shippingVM.ShippingDoc = record.selectedShippingDoc
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                        .filter { !$0.isEmpty }
                    SelectedSheeping = record.selectedShippingDoc
                } else {
                    shippingVM.ShippingDoc = []
                }
            } else {
                SelectedSheeping = shippingVM.ShippingDoc.joined(separator: ", ")
            }
            selectedCoDriverName = record.selectedCoDriver != "None" ? record.selectedCoDriver : nil
            coDriver = record.selectedCoDriver
            selectedCoID = record.coDriverID
            syncstatus = record.syncStatus

        } else {
            // If no record found, ensure shipping docs are loaded from current state
            // Don't clear if user has added docs but not saved yet
        }

        hasLoadedInitialData = true
    }




}

// MARK: - FormField View
struct FormField: View {
    let label: String
    @Binding var value: String
    var editable: Bool = true
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(label)
                    .bold()
                    .foregroundColor( Color(uiColor:.black))
                Text(value)
                    .foregroundColor( Color(uiColor:.black))
            }
            Spacer()
            if editable {
                Button(action: { onTap?() }) {
                    Image("pencil")
                        .foregroundColor( Color(uiColor:.black))
                        .bold()
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
        Divider()
    }
}


//MARK: -  To Transfer a Exact date  in tittle
extension String {
    func extractDate() -> String {
        // Extract last 10 chars if format is yyyy-MM-dd
        if self.count >= 10 {
            let dateStr = String(self.suffix(10))
            return dateStr
        }
        return self
    }
}




//
//// MARK: - Preview
//#Preview {
//    CertifySelectedView(title: "Certify Form")
//        .environmentObject(NavigationManager())
//}
//

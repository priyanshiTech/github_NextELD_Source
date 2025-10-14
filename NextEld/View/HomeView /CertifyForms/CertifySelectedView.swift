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
    @State private var SelectedTraller: String? = nil
    @State private var SelectedSheeping: String? = nil
    @State private var SelectedVechicle: String? = nil
    @State private var showSignaturePad = false
    @State private var signaturePath = Path()
    @State private var showCoDriverPopup = false
    @Binding var vehiclesc: String
    @Binding var VechicleID: Int
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var trailerVM: TrailerViewModel
  //  @StateObject private var trailerVM = TrailerViewModel()
    @EnvironmentObject var shippingVM: ShippingDocViewModel
    @State private var selectedCoDriverEmail: String = "" //Hidden Email
    @State private var certifiedDate: String = ""
    @State private var isCertified: Bool = false
    @State private var isCertify: String = "No" //Default "No"


    var title: String
    
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
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                    
                    HStack {
                        Button(action: { navManager.goBack() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }.padding()

                      //  Button(action: {
                       //     navManager.navigate(to: .DatabaseCertifyView)
                      //  }) {
                            Text(title)
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                  //      }

                        
                        Spacer()
                        
                        CustomIconButton(
                            iconName: "alarm_icon",
                            title: "Event",
                            action: { navManager.navigate(to: AppRoute.RecapHours(tittle: "Hours Recap")) }
                          //  action: { navManager.navigate(to: AppRoute.logsFlow(.RecapHours(title: "Hours Recap"))) }
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
                    .foregroundColor(selectedTab == "Form" ? .white : .black)
                    
                    Button("Certify") {
                        selectedTab = "Certify"
                        showSignaturePad = true
                        showCoDriverPopup = false // hide popup
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTab == "Certify" ? Color(UIColor.wine) : Color.white.opacity(0.2))
                    .foregroundColor(selectedTab == "Certify" ? .white : .black)
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
                        FormField(label: "Driver", value: .constant("\(DriverInfo.UserName )- \(DriverInfo.driverId ?? 0)"), editable: false)
                        FormField(
                            label: "Vehicle",
                            value: $vehiclesc , // Direct binding
                            editable: true
                        ) {
                            navManager.navigate(to: AppRoute.HomeFlow.ADDVehicle)
                        }



                        FormField(
                            label: "Trailer",
                            value: Binding(
                                get: {
                                    if trailerVM.trailers.isEmpty {
                                        return "None"
                                    } else {
                                        return trailerVM.trailers.prefix(10).joined(separator: ", ")
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
                          //navManager.navigate(to: AppRoute.vehicleFlow(.trailerScreen))
                
                             navManager.path.append(AppRoute.DvirFlow.trailerScreen)
                             
                        }
                        FormField(
                            label: "Shipping Docs",
                            value: Binding(
                                get: {
                                    let docs = Array(shippingVM.ShippingDoc.prefix(10)) // starting se max 10 values
                                    return docs.isEmpty ? "None" : docs.joined(separator: ", ")
                                },
                                set: { newValue in
                                    // Split newValue by comma if user edits it
                                    let values = newValue.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                                    shippingVM.ShippingDoc = Array(values.prefix(10))
                                }
                            ),
                            editable: true
                        )
                       {
                        // navManager.navigate(to: AppRoute.vehicleFlow(.ShippingDocment)) // shipping screen
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
                                userID: String(DriverInfo.driverId ?? 0),
                                userName: DriverInfo.UserName,
                                startTime: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short),
                                date: certifiedDate,
                                shift: DriverInfo.shift ?? 1,
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
                                syncStatus: 0,
                                isCertify: "No"
                            )
                            CertifyDatabaseManager.shared.saveRecord(record)

                                
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
                        certifiedDate = title.extractDate()
                        DriverInfo.setvehicleId(VechicleID)
                        
                        
                        let records = CertifyDatabaseManager.shared.fetchAllRecords()
                        print(records)

                        //  Fetch saved record for this date
                        if let record = CertifyDatabaseManager.shared.fetchAllRecords()
                            .first(where: { $0.date == certifiedDate         }) {
                      
                            print(record.date)
                            print(certifiedDate)
                            print(record.selectedTrailer)
                            print(record.selectedCoDriver)
                            print(record.selectedVehicle)
                            print(record.selectedShippingDoc)
                            

                            self.SelectedTraller = record.selectedTrailer // only if you really need both
                            self.trailer =  record.selectedTrailer
                            
                            self.SelectedSheeping  =  record.selectedShippingDoc
                            self.shippingDocs  = record.selectedShippingDoc
                            
                            self.SelectedVechicle = record.selectedVehicle
                            self.vehiclesc = record.selectedVehicle
                            
                            self.selectedCoDriverName = record.selectedCoDriver != "None" ? record.selectedCoDriver : nil
                            self.selectedCoID = record.coDriverID
                            self.coDriver = record.selectedCoDriver
                            
                        }
                    }

//                    .onAppear {
//                        certifiedDate = title.extractDate()
//                        DriverInfo.setvehicleId(VechicleID)
//
//                        if let record = CertifyDatabaseManager.shared.fetchAllRecords()
//                            .first(where: { $0.date == certifiedDate }) {
//
//                            // Vehicle
//                            if !record.selectedVehicle.isEmpty {
//                                self.vehiclesc = record.selectedVehicle   //  yahi binding update karo
//                            }
//
//                            // Trailer
//                            if record.selectedTrailer != "None" {
//                                trailerVM.trailers = record.selectedTrailer.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//                            } else {
//                                trailerVM.trailers = []
//                            }
//
//                            // Shipping Docs
//                            if record.selectedShippingDoc != "None" {
//                                shippingVM.ShippingDoc = record.selectedShippingDoc.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//                            } else {
//                                shippingVM.ShippingDoc = []
//                            }
//
//                            // Co-Driver
//                            self.selectedCoDriverName = record.selectedCoDriver != "None" ? record.selectedCoDriver : nil
//                            self.selectedCoID = record.coDriverID
//                        }
//
//                    }

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
                            print(" DB updated: \(match.isCertify)")
                        }
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
                Color.black.opacity(0.4)
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
                    .foregroundColor(.black)
                Text(value)
                    .foregroundColor(.black)
            }
            Spacer()
            if editable {
                Button(action: { onTap?() }) {
                    Image("pencil")
                        .foregroundColor(.black)
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

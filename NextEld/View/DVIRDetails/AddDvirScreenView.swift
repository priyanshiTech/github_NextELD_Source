//
//  AddDvirScreenView.swift
//  NextEld
//
//  Created by Priyanshi on 21/05/25.
//

import SwiftUI

struct AddDvirScreenView: View  {
    
    @EnvironmentObject var navmanager: NavigationManager
    @State private var notesText: String = ""
    @State private var showSignaturePopup = false
    @State private var signaturePath = Path()
    //MARK: -  to show a selected data @binding use
    @Binding var selectedVehicle: String
    @Binding var selectedVehicleId: Int   // get vehicle id
    @State private var truckDefectSelection: String? = nil
    @State private var trailerDefectSelection: String? = nil
    
    @State private var Showpopup: Bool = false
    @State private var selectedTab = ""
    @EnvironmentObject var trailerVM: TrailerViewModel
    
    @State private var showPopupVechicle = false
    @EnvironmentObject var vehicleVM: VehicleConditionViewModel
    @EnvironmentObject var DVClocationManager: DeviceLocationManager
    @State private var showValidationAlert = false

    let selectedRecord: DvirRecord

    @State  var driverName:String = ""
    @State  var odometer : Double = 0.0
    @State  var  companyName: String = ""
    @State  var Location: String  = ""
    @State  var  driverID: String  = ""
    @State var driverDVIRId:Int = 0
    @State private var date: String = ""
    @State private var time: String = ""
   // @State private var dateTime:String = ""
    @State private var selectedCoDriver: String? = nil
    @State private var validationMessage: String = ""
    @State private var showSignaturePad = false
    @State private var showCoDriverPopup = false
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var shippingVM: ShippingDocViewModel
  

    @State private var showPopup = false
    @State private var popupType: String = "" // "Truck" or "Trailer"
    @StateObject var defectVM = DefectAPIViewModel(networkManager: NetworkManager())

    @State private var signaturePoints: [CGPoint] = []
    @State private var signatureImage: UIImage? = nil
    var existingRecord: DvirRecord?    // for editiong
    
    var body: some View {
       
        ZStack {
            VStack(spacing: 0) {
                
                // MARK: - Top Strip
                ZStack(alignment: .topLeading) {
                    Color(UIColor.wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 10)
                }
                
                // MARK: - Header
                ZStack(alignment: .top) {
                    Color.white
                        .frame(height: 52)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                    
                    HStack {
                        Button(action: {
                            navmanager.goBack()
                            
                        }) {
                            Image(systemName: "arrow.left")
                                .bold()
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                        
                        Button(action: {
                            navmanager.navigate(to: AppRoute.DvirDataListView)
                        }){
                            
                            
                            Text("Add Dvir")
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.wine).shadow(radius: 1))
                    .frame(height: 40, alignment: .topLeading)
                }
                
                // MARK: - Main Content Scroll
                UniversalScrollView {
                    VStack(spacing: 8) {
                        
                        // Driver Info
                        CardContainer {
                            VStack(alignment: .leading, spacing: 15) {
                                DvirField(label: "Driver", value: driverName)
                                DvirField(label: "Time", value: time)
                                DvirField(label: "Date", value: date)
                                DvirField(label: "Odometer", value: "0")
                                DvirField(label: "Company", value: companyName)
                               // DvirField(label: "Location", value: Location)
                                
                                DvirField(label: "Location", value: DVClocationManager.fullAddress ?? "Not found")
                            }
                        }
                        
                        // Vehicle
                        CardContainer {
                            Button(action: {
                                
                               // navmanager.navigate(to: .ADDVehicle)
                                navmanager.navigate(to: AppRoute.AddVehicleForDVIR)

                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4){
                                        Text("Vehicle")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        //MARK: -  to show a selected data
                                        Text("\(selectedVehicle)")
                                        //Text("Selected Vehicle: \(selectedVehicle.isEmpty ? "None" : selectedVehicle)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                           
                                    }
                                    
                                    Spacer()
                                    Image("pencil").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Trailer
                        CardContainer {
                            Button(action: {
                                navmanager.navigate(to: AppRoute.trailerScreen)   //MARK: -  26 july
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Trailer")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        // Text("None")
                                        Text(trailerVM.trailers.first ?? "None")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Spacer()
                                    Image("pencil").foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        CardContainer {
                            VStack(spacing: 16) {
                                Text("Truck Defects").font(.headline)
                                DefectsSection(title: "Truck", selection: $truckDefectSelection) {
                                    truckDefectSelection = "yes"
                                    popupType = "Truck"
                                    showPopup = true
                                }

                                Text("Trailer Defects").font(.headline)
                                DefectsSection(title: "Trailer", selection: $trailerDefectSelection) {
                                    trailerDefectSelection = "yes"
                                    popupType = "Trailer"
                                    showPopup = true
                                }
                            }
                        }

                        // Notes
                        CardContainer {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $notesText)
                                    .frame(height: 200)
                                    .padding(2)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)
                                
                                if notesText.isEmpty {
                                    Text("Write note here...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 12)
                                }
                            }
                            
                            HStack {
                                Button(action: {
                                    
                                    showPopupVechicle = true
                                    print("Vehicle Condition Added")
                                }) {
                         
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Vehicle Condition")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        //  Show selected condition or default "None"
                                        Text(vehicleVM.selectedCondition ?? "None")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.clear)
                                }
                            }
                          
                        }
                       
                    }
                    
                   //  Signature Button
                    CardContainer {
                        Button(action: {
                           // selectedTab = "Driver Signature"
                           // showSignaturePopup = true
                  showSignaturePopup = true
                        }) {
                            Text("Add Driver Signature")
                                .foregroundColor(.black)
                                .font(.headline)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(10)
                        }
                        .frame(width: .infinity, height: 80)
                    }
         
  

                    .onAppear {
                        loadLoginData()
                        
                        if selectedRecord.id != nil {   // Editing existing record
                            driverName = selectedRecord.driver
                            odometer = odometer
                            companyName = selectedRecord.company
                            Location = selectedRecord.location
                            truckDefectSelection = selectedRecord.truckDefect
                            trailerDefectSelection = selectedRecord.trailerDefect
                            date = selectedRecord.date   //  always keep record date
                            time = selectedRecord.time   //  always keep record time
                            if vehicleVM.selectedCondition == nil || vehicleVM.selectedCondition == "None" {
                                vehicleVM.selectedCondition = selectedRecord.vehicleCondition
                            }
                            selectedVehicle = selectedRecord.vehicleID
                        } else {   // Adding new record
                            date = DateTimeHelper.currentDate()
                            time = DateTimeHelper.currentTime()
                            //selectedVehicle = ""
                        }
                    }


                    
                    Button(action: {
                        if let errorMessage = validateForm() {
                            validationMessage = errorMessage
                            showValidationAlert = true
                        } else {
                            let signatureImage = signatureToImage(points: signaturePoints,
                                                                  size: CGSize(width: 300, height: 150))
                            let signatureData = signatureImage.pngData()

                            var record = DvirRecord(
                                driver: driverName,
                                time: time,
                                date: date,
                                odometer: odometer,
                                company: companyName,
                                location: Location,
                                vehicleID:  "\(selectedVehicleId)",
                                trailer: trailerVM.trailers.first ?? "None",
                                truckDefect: truckDefectSelection ?? "no",
                                trailerDefect: trailerDefectSelection ?? "no",
                                vehicleCondition: vehicleVM.selectedCondition ?? "None",
                                notes: notesText,
                                engineHour: 0,
                                signature: signatureData
                            )
                            
                          let DvirRecord = DvirRecordRequestModel(
                            driverId: driverDVIRId,
                             dateTime:"\(record.date) \(record.time)" ,
                            locationDvir: Location,
                             truckDefect: truckDefectSelection ?? "no",
                             trailerDefect: trailerDefectSelection ?? "no",
                             notes: notesText,
                             vehicleCondition:  vehicleVM.selectedCondition ?? "None",
                            companyName: companyName,
                            odometer: odometer,
                             engineHour: 0,
                             vehicleId: selectedVehicleId,
                            timestampDvir: "\(currentTimestampMillis())",
                            tokenNo: DriverInfo.authToken,
                            clientId: DriverInfo.clientId ?? 0 ,
                            trailer: trailerVM.trailers.first ?? "helo",
                            fileDVir: signatureData,
                            
                          )

                            if let existingId = selectedRecord.id {
                                // Editing existing record
                                record.id = existingId
                                DvirDatabaseManager.shared.updateRecord(record)
                                updateDvirDataUsingCommonService(record: record, dvirLogId: driverID)

                                print(" Record updated with ID: \(existingId)")
                                if let signatureData = signatureData {
                                    print(" Signature updated successfully! Size: \(signatureData.count) bytes")
                                } else {
                                    print(" Signature missing while updating record")
                                }

                            } else {
                   
                                DvirDatabaseManager.shared.insertRecord(record)
                                uploadDvirDataUsingCommonService(record: DvirRecord)

                                print(" New record inserted")
                                if let signatureData = signatureData {
                                    print(" Signature saved successfully! Size: \(signatureData.count) bytes")
                                } else {
                                    print("Signature missing while inserting new record")
                                }

                            }
                        }
                    }) {
                        Text("Add Dvir")
                          //  .frame(width: 350, height: 50)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)// Expand fully in parent
                           // .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)

                            .foregroundColor(.white)
                            .background(Color(UIColor.wine))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }

                    .alert(isPresented: $showValidationAlert) {
                        Alert(
                            title: Text("Missing Information"),
                            message: Text(validationMessage),
                            dismissButton: .default(Text("OK"))
                        )
                   }

                }
                .padding(.horizontal, 5)
            }
            .navigationBarBackButtonHidden()
            
            // MARK: - Signature Popup Overlay

            if showSignaturePopup {
                SignatureAddDvir(
                    isPresented: $showSignaturePopup,
                    points: $signaturePoints
                ) { image in
                    self.signatureImage = image   //parent me image save ho rahi hai
                }
                .transition(.scale)
                .zIndex(1)
            }



            // MARK: - Defect Popup Overlay
            if showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture { showPopup = false }
                
                DefectPopupView(
                    isPresented: $showPopup,
                    popupType: popupType,
                    truckDefectSelection: $truckDefectSelection,
                    trailerDefectSelection: $trailerDefectSelection
                )
                .frame(width: 300, height: 400)
                               .background(Color.white)
                               .cornerRadius(12)
                               .shadow(radius: 10)
                               .zIndex(2)
                               .transition(.scale)
             
            }


            //MARK: - Vehicle popup
            
            if showPopupVechicle {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showPopupVechicle = false }
                
                VehicleConditionPopupView(isPresented: $showPopupVechicle)
                    .environmentObject(vehicleVM)
                    .transition(.scale)
            }
        }
        .onAppear {
            Task {
                await defectVM.fetchDefects()
            }
        }
        .animation(.easeInOut, value: showSignaturePopup)
        .animation(.easeInOut, value: Showpopup)
        .animation(.easeInOut, value: showPopupVechicle)
    }
        //MARK: - load login data into swiftui
    func loadLoginData() {
        driverName = UserDefaults.standard.string(forKey: "driverName") ?? "N/A"
        Location = UserDefaults.standard.string(forKey: "customLocation") ?? "N/A"
        companyName = UserDefaults.standard.string(forKey: "companyName") ?? "N/A"
        driverID = UserDefaults.standard.string(forKey: "userId") ?? "n/a"

   }

    // MARK: - Validation that returns custom error message
    func validateForm() -> String? {
        if driverName.isEmpty { return "Please enter Driver Name" }
        if time.isEmpty { return "Please enter Time" }
        if date.isEmpty { return "Please enter Date" }

        if selectedVehicle.isEmpty { return "Please select a Vehicle" } 
        if (trailerVM.trailers.first ?? "").isEmpty { return "Please select a Trailer" }
        if truckDefectSelection == nil { return "Please select Truck Defect status" }
        if trailerDefectSelection == nil { return "Please select Trailer Defect status" }
        if notesText.isEmpty { return "Please enter Notes" }
        if vehicleVM.selectedCondition?.isEmpty ?? true { return "Please select Vehicle Condition" }
        //if signaturePath.description.count <= 10 { return "Please add Driver Signature" }
        if signatureImage == nil { return "Please add Driver Signature" }
        return nil //  No error
    }



}

//MARK: -   ADdd a validation  for input fields
//struct DefectsSection: View  a


struct DefectsSection: View {
    let title: String
    @Binding var selection: String?
    let onSelectDefect: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: { selection = "no" }) {
                defectButton(label: "No Defects", isSelected: selection == "no")
            }
            
            Button(action: onSelectDefect) {
                defectButton(
                    label: "Has Defects",
                    isSelected: selection != nil && selection != "no"
                )
            }
        }
    }
    
    private func defectButton(label: String, isSelected: Bool) -> some View {
        Text(label)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color(UIColor.wine) : Color.white)
            .foregroundColor(isSelected ? .white : Color(UIColor.wine))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(UIColor.wine), lineWidth: 1))
            .cornerRadius(8)
    }
}

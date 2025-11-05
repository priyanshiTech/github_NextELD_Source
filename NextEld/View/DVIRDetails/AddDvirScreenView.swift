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
   // @Binding var selectedVehicle: String
   // @Binding var selectedVehicleId: Int   // get vehicle id
    @State private var selectedVehicleNumber: String = ""
    @State private var vehicleID: Int = 0
    @State private var truckDefectSelection: String? = nil
    @State private var trailerDefectSelection: String? = nil
    @State private var Showpopup: Bool = false
    @State private var selectedTab = ""
    @StateObject var trailerVM: TrailerViewModel = .init()
    @State private var selectedTrailer = ""
    @State private var showPopupVechicle = false
    @StateObject var vehicleVM: VehicleConditionViewModel = .init()
    @StateObject var DVClocationManager: DeviceLocationManager = .init()
    @State private var showValidationAlert = false
    @State private var showSuccessAlert = false
    @State private var successMessage = ""

    @Binding var selectedRecord: DvirRecord?
    @Binding var trailers: [String]
    var isFromHome: Bool = false    //MARK: -  To handle Home Screen flag

    @State  var driverName:String = ""
    @State  var odometer : Double = 0.0
    @State  var  companyName: String = ""
    @State  var Location: String  = ""
    @State  var  driverID: String  = ""
    @State var driverDVIRId:Int = 0
    @State private var StartTime: String = ""
    @State private var Drivetime: String = ""
   //@State private var dateTime:String = ""
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
                            
                        }){
                            Image(systemName: "arrow.left")
                                .bold()
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }

                            Text("Add DVIR")
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
         
                        
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
                                DvirField(label: "Time", value: DateTimeHelper.currentTime())
                                DvirField(label: "Date", value: DateTimeHelper.currentDate())
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
                                navmanager.navigate(to: AppRoute.DvirFlow.AddVehicleForDVIR)

                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4){
                                        Text("Vehicle")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        //MARK: -  to show a selected data
                                       // Text(displayVehicleNumber())
                                        Text("\(AppStorageHandler.shared.vehicleNo ?? "")")
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
                               // navmanager.navigate(to: AppRoute.vehicleFlow(.trailerScreen))   //MARK: -  26 july
                               
                                navmanager.path.append(AppRoute.DvirFlow.trailerScreen)

                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Trailer")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                       //  Show all trailers comma-separated, or "None" if empty
                                
                                        Text(trailerVM.trailers.isEmpty ? "None" : trailerVM.trailers.joined(separator: ", "))
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
                                DefectsSection(title: "Truck", selection: $truckDefectSelection, onSelectNoDefect: {
                                    alreadycheckAndSetVehicleCondition()
                                }) {
                                    truckDefectSelection = "yes"
                                    popupType = "Truck"
                                    showPopup = true
                                }

                                Text("Trailer Defects").font(.headline)
                                DefectsSection(title: "Trailer", selection: $trailerDefectSelection, onSelectNoDefect: {
                                    alreadycheckAndSetVehicleCondition()
                                }) {
                                    trailerDefectSelection = "yes"
                                    popupType = "Trailer"
                                    showPopup = true
                                }
                            }
                            .onChange(of: truckDefectSelection) { newValue in
                                alreadycheckAndSetVehicleCondition()
                            }
                            .onChange(of: trailerDefectSelection) { newValue in
                                alreadycheckAndSetVehicleCondition()
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
                        guard  let selectedRecord else{
                            return
                        }
                        
                        // Store current vehicle selection before any updates
                        let previousVehicleNumber = selectedVehicleNumber
                        let previousVehicleID = vehicleID
                        print(" onAppear - Before updates:")
                        print("  previousVehicleNumber: '\(previousVehicleNumber)'")
                        print("  previousVehicleID: \(previousVehicleID)")
                        print("  selectedRecord?.vehicleName: '\(selectedRecord.vehicleName ?? "")'")
                        
                        if selectedRecord.id != nil {   // Editing existing record
                            driverName = selectedRecord.UserName
                            odometer = odometer
                            Location = selectedRecord.location
                            truckDefectSelection = selectedRecord.truckDefect
                            trailerDefectSelection = selectedRecord.trailerDefect
                            StartTime = selectedRecord.startTime   //  always keep record date
                            Drivetime = selectedRecord.DvirTime  //  always keep record time
                            if vehicleVM.selectedCondition == nil || vehicleVM.selectedCondition == "None" {
                                vehicleVM.selectedCondition = selectedRecord.vehicleCondition
                            }
                            // Initialize from record if we don't have a selected vehicle
                            // This ensures vehicle name shows immediately on load
                            if previousVehicleNumber.isEmpty {
                                let vehicleName = selectedRecord.vehicleName
                                if !vehicleName.isEmpty {                          
                                    selectedVehicleNumber = vehicleName
                                    vehicleID = Int(selectedRecord.vechicleID) ?? 0
                                    print("  Initialized from record: '\(selectedVehicleNumber)'")
                                }
                            } else {
                                print(" Preserving selected vehicle: '\(previousVehicleNumber)'")
                            }
                        } else {   // Adding new record
                            StartTime = DateTimeHelper.currentDate()
                            Drivetime = DateTimeHelper.currentTime()
                            // If selectedRecord has vehicle name (from navigation), initialize it
                            if selectedVehicleNumber.isEmpty {
                                let vehicleName = selectedRecord.vehicleName
                                if !vehicleName.isEmpty {
                                    selectedVehicleNumber = vehicleName
                                    vehicleID = Int(selectedRecord.vechicleID) ?? 0
                                    print(" New record - Initialized from selectedRecord: '\(selectedVehicleNumber)'")
                                }
                            }
                        }
                        // Always update selectedRecord with current values when view appears
                        // This ensures we sync after coming back from vehicle selection
                        updateSelectedRecordFromVehicle()
                    }
                  

                    
                    Button(action: {
                        
                        print("Add Dvir Button Clicked!")
                        // Handle nil selectedRecord by creating a new record with available data
                        var workingRecord: DvirRecord
                        if var existingRecord = selectedRecord {
                            // If vehicleName is empty, update it from state variables
                            if existingRecord.vehicleName.isEmpty {
                                let vehicleName = selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : selectedVehicleNumber
                                let vehicleId = vehicleID > 0 ? "\(vehicleID)" : (AppStorageHandler.shared.vehicleId.map { "\($0)" } ?? "0")
                                existingRecord.vehicleName = vehicleName
                                existingRecord.vechicleID = vehicleId
                                self.selectedRecord = existingRecord
                                print("Updated selectedRecord with Vehicle: \(vehicleName)")
                            }
                            workingRecord = existingRecord
                            print("Using existing selectedRecord")
                        } else {
                            // Create a new record with available state data
                            print("selectedRecord is nil, creating new record from state data")
                            let vehicleName = selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : selectedVehicleNumber
                            let vehicleId = vehicleID > 0 ? "\(vehicleID)" : (AppStorageHandler.shared.vehicleId.map { "\($0)" } ?? "0")
                            
                            workingRecord = DvirRecord(
                                id: nil,
                                UserID: driverID,
                                UserName: driverName,
                                startTime: "",
                                DAY: "",
                                Shift: "\(AppStorageHandler.shared.shift)",
                                DvirTime: "",
                                odometer: odometer,
                                location: Location,
                                truckDefect: "No",
                                trailerDefect: "No",
                                vehicleCondition: "None",
                                notes: "",
                                vehicleName: vehicleName,
                                vechicleID: vehicleId,
                                Sync: 1,
                                timestamp: "",
                                Server_ID: "",
                                Trailer: "",
                                signature: nil
                            )
                            // Update the binding
                            self.selectedRecord = workingRecord
                            print(" Created new selectedRecord with Vehicle: \(vehicleName)")
                        }
                        
                        // Ensure StartTime and Drivetime are set before validation
                        if StartTime.isEmpty {
                            StartTime = DateTimeHelper.currentDate()
                            print("StartTime was empty, setting to: \(StartTime)")
                        }
                        if Drivetime.isEmpty {
                            Drivetime = DateTimeHelper.currentTime()
                            print("Drivetime was empty, setting to: \(Drivetime)")
                        }
                        
                        if let errorMessage = validateForm() {
                            print(" Validation Failed: \(errorMessage)")
                            validationMessage = errorMessage
                            showValidationAlert = true
                        } else {
                            print("Validation Passed - Starting Database Save")
                            
                            let currentDay = DateTimeHelper.currentDate()
                            let currentTime = DateTimeHelper.currentTime()
                            // Get signature data from signatureImage state variable
                            let signatureData = signatureImage?.pngData()
                            
                            print("Driver Name: \(driverName)")
                            print("Vehicle: \(workingRecord.vehicleName)")
                            print(" Trailer: \(trailerVM.trailers.joined(separator: ", "))")
                            print("Truck Defect: \(truckDefectSelection ?? "No")")
                            print("Trailer Defect: \(trailerDefectSelection ?? "No")")
                            print("Signature Data Size: \(signatureData?.count ?? 0) bytes")

                            var record = DvirRecord(
                                id: existingRecord?.id,
                                UserID: driverID,
                                UserName: driverName,
                                startTime: "\(currentDay) \(currentTime)",
                                DAY: currentDay,
                                Shift: "\(AppStorageHandler.shared.shift)",
                                DvirTime: currentTime,
                                odometer: odometer,
                                location: Location,
                                truckDefect: truckDefectSelection ?? "No",
                                trailerDefect: trailerDefectSelection ?? "No",
                                vehicleCondition: vehicleVM.selectedCondition ?? "None",
                                notes: notesText,
                                vehicleName: workingRecord.vehicleName.isEmpty ? (selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : selectedVehicleNumber) : workingRecord.vehicleName,
                                vechicleID: workingRecord.vechicleID.isEmpty ? "\(vehicleID > 0 ? vehicleID : (AppStorageHandler.shared.vehicleId ?? 0))" : workingRecord.vechicleID,
                                Sync: 1,
                                timestamp: "\(Int(Date().timeIntervalSince1970 * 1000))",
                                Server_ID: existingRecord?.Server_ID ?? "",
                                Trailer: trailerVM.trailers.isEmpty ? (existingRecord?.Trailer ?? "") : trailerVM.trailers.joined(separator: ", "),
                                signature: signatureData  //  Save signature to database
                            )

                            
                          let DvirRecord = DvirRecordRequestModel(
                            driverId: driverDVIRId,
                             dateTime: record.startTime,  // startTime already has "DATE TIME" format
                            locationDvir: Location,
                             truckDefect: truckDefectSelection ?? "no",
                             trailerDefect: trailerDefectSelection ?? "no",
                             notes: notesText,
                             vehicleCondition:  vehicleVM.selectedCondition ?? "None",
                            companyName: companyName,
                            odometer: odometer,
                             engineHour: 0,
                            vehicleId: record.vechicleID,
                            timestampDvir: "\(Int(Date().timeIntervalSince1970 * 1000))",
                            tokenNo: AppStorageHandler.shared.authToken ?? "",
                            clientId: AppStorageHandler.shared.clientId ?? 0 ,
                            trailer: trailerVM.trailers.isEmpty ? "" : trailerVM.trailers.joined(separator: ", "),
                            fileDVir: signatureData,
                            
                          )

                            if let existingId = record.id {
                                // Editing existing record
                                print(" Updating Existing Record with ID: \(existingId)")
                                record.id = existingId
                                DvirDatabaseManager.shared.updateRecord(record)
                                
                                // Verify the record was saved
                                let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
                                let savedRecord = allRecords.first { $0.id == existingId }
                                if savedRecord != nil {
                                    print("  Record Verified in Database - Update Successful!")
                                    successMessage = "DVIR Record Updated Successfully!\n\nDriver: \(driverName)\nVehicle: \(record.vehicleName)\nDate: \(record.DAY)"
                                    showSuccessAlert = true
                                } else {
                                    print(" Warning: Record not found in database after update")
                                }
                                
                                // Call update_dvir_data API
                                print(" Calling update_dvir_data API...")
                                updateDvirDataUsingCommonService(record: record, dvirLogId: driverID)
                                
                                // Post notification to refresh UploadDefectView
                                NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
                                print(" Posted DVIRRecordUpdated notification after update")
                                
                                print("  Record updated with ID: \(existingId)")
                                if let signatureData = signatureData {
                                    print("  Signature updated successfully! Size: \(signatureData.count) bytes")
                                } else {
                                    print("  Signature missing while updating record")
                                }

                            } else {
                                print(" Inserting New Record to Database")
                   
                                DvirDatabaseManager.shared.insertRecord(record)
                                
                                // Verify the record was saved
                                let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
                                if let savedRecord = allRecords.last {
                                    print(" New Record Verified in Database!")
                                    print(" Saved Record ID: \(savedRecord.id ?? -1)")
                                    print(" Saved Record Driver: \(savedRecord.UserName)")
                                    print(" aved Record Vehicle: \(savedRecord.vehicleName)")
                                    successMessage = "DVIR Record Saved Successfully!\n\nDriver: \(driverName)\nVehicle: \(record.vehicleName)\nDate: \(record.DAY)"
                                    showSuccessAlert = true
                                    
                                    // Post notification to refresh UploadDefectView
                                    NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
                                    print("Posted DVIRRecordUpdated notification")
                                } else {
                                    print("Error: Record not found in database after insert")
                                }
                                
                                // Call dispatchadd_dvir_data API for new record
                                print(" ========== CALLING dispatchadd_dvir_data API ==========")
                                print(" Calling dispatchadd_dvir_data API (for new record)...")
                                print(" DvirRecord driverId: \(DvirRecord.driverId)")
                                print(" DvirRecord vehicleId: \(DvirRecord.vehicleId)")
                                print(" DvirRecord dateTime: \(DvirRecord.dateTime)")
                                print("DvirRecord location: \(DvirRecord.locationDvir)")
                                print(" DvirRecord has signature: \(DvirRecord.fileDVir != nil)")
                                print(" DvirRecord tokenNo: \(DvirRecord.tokenNo)")
                                print(" DvirRecord clientId: \(DvirRecord.clientId)")
                                // Ensure DvirRecord is accessible and call API
                                uploadDvirDataUsingCommonService(record: DvirRecord)
                                print(" API call initiated successfully!")
                                print(" =================================================")
                              
                            }
                            
                            // Delay navigation to show success message
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                if isFromHome {
                                    navmanager.navigate(to: AppRoute.HomeFlow.Home)
                                } else {
                                    navmanager.navigate(to: AppRoute.HomeFlow.AddDvirPriTrip)
                                }
                            }
                        }
                    }) {
                        Text("Add Dvir")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)// Expand fully in parent
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
                    .alert(isPresented: $showSuccessAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text(successMessage),
                            dismissButton: .default(Text("OK")) {
                                print(" User acknowledged success message")
                            }
                        )
                   }

                }
                .padding(.horizontal, 5)
                .navigationDestination(for: AppRoute.DvirFlow.self, destination: { type in
                    switch type {
                    case .trailerScreen:
                        TrailerView(trailerVM: trailerVM, tittle: AppConstants.trailersTittle, trailers: $trailerVM.trailers)
                        
                    case .ShippingDocment:
                        ShippingDocView(tittle: AppConstants.shippingTittle)
                        

                    case .AddVehicleForDVIR:
                        AddVehicleForDvir(selectedVehicleNumber: $selectedVehicleNumber, VechicleID: $vehicleID)

                

                    default:
                        EmptyView()
                    }
                    
                })
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                // Sync trailers binding with trailerVM when view appears
                // This ensures latest trailers are shown when navigating back from TrailerView
                if trailers != trailerVM.trailers {
                    trailers = trailerVM.trailers
                }
            }
            .onChange(of: trailerVM.trailers) { newValue in
                // When trailerVM.trailers changes, update the binding
                if trailers != newValue {
                    trailers = newValue
                }
            }
            .onChange(of: trailers) { newValue in
                // When binding changes, sync with trailerVM
                if trailerVM.trailers != newValue {
                    trailerVM.trailers = newValue
                }
            }
            
            
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
        companyName = AppStorageHandler.shared.company ?? ""
        //UserDefaults.standard.string(forKey: "companyName") ?? "N/A"
        driverID = UserDefaults.standard.string(forKey: "userId") ?? "n/a"
        // Set driverDVIRId from AppStorageHandler or UserDefaults
        driverDVIRId = AppStorageHandler.shared.driverId ?? Int(driverID) ?? 0

   }

    // MARK: - Validation that returns custom error message
    func validateForm() -> String? {
        if driverName.isEmpty { return "Please enter Driver Name" }
        if StartTime.isEmpty { return "Please enter Time" }
        if Drivetime.isEmpty { return "Please enter Day" }

        // Check vehicle - use selectedRecord, selectedVehicleNumber, or AppStorageHandler
        let vehicleName: String
        if let recordVehicleName = selectedRecord?.vehicleName, !recordVehicleName.isEmpty {
            vehicleName = recordVehicleName
        } else if !selectedVehicleNumber.isEmpty {
            vehicleName = selectedVehicleNumber
        } else {
            vehicleName = AppStorageHandler.shared.vehicleNo ?? ""
        }
        
        if vehicleName.isEmpty {
            return "Please select a Vehicle"
        }
        
        if (trailerVM.trailers.first ?? "").isEmpty { return "Please select a Trailer" }
        if truckDefectSelection == nil { return "Please select Truck Defect status" }
        if trailerDefectSelection == nil { return "Please select Trailer Defect status" }
        if notesText.isEmpty { return "Please enter Notes" }
        if vehicleVM.selectedCondition?.isEmpty ?? true { return "Please select Vehicle Condition" }
        //if signaturePath.description.count <= 10 { return "Please add Driver Signature" }
        if signatureImage == nil { return "Please add Driver Signature" }
        return nil //  No error
    }
    
    
    
    // MARK: - Update selectedRecord with vehicle information
    func updateSelectedRecordFromVehicle() {
        print("updateSelectedRecordFromVehicle called - selectedVehicleNumber: '\(selectedVehicleNumber)', selectedVechicleID: \(vehicleID)")
        
        guard !selectedVehicleNumber.isEmpty && vehicleID > 0 else {
            print("Cannot update - selectedVehicleNumber is empty or ID is 0")
            return
        }
        
        if var record = selectedRecord {
            record.vehicleName = selectedVehicleNumber
            record.vechicleID = "\(vehicleID)"
            selectedRecord = record
            print(" Updated selectedRecord - vehicleName: '\(selectedVehicleNumber)', vechicleID: \(vehicleID)")
        } else {
            print(" selectedRecord is nil, creating new record")
         
        }
    }
    
    // MARK: - Check and set Vehicle Condition based on defects
    func checkAndSetVehicleCondition() {
        if truckDefectSelection == "no" && trailerDefectSelection == "no" {
            vehicleVM.selectedCondition = "Vehicle Condition Satisfactory"
        }
        else if truckDefectSelection == "yes" || trailerDefectSelection == "yes" {
            vehicleVM.selectedCondition = nil
        }
    }

    // MARK: - Wrapper to satisfy existing call site naming
    func alreadycheckAndSetVehicleCondition() {
        checkAndSetVehicleCondition()
    }
    
    // MARK: - Display Vehicle Number with proper fallback
    func displayVehicleNumber() -> String {
        // Priority 1: selectedVehicleNumber (from user selection - most recent)
        if !selectedVehicleNumber.isEmpty {
            return selectedVehicleNumber
        }
        // Priority 2: selectedRecord?.vehicleName (from existing record)
        if let record = selectedRecord, !record.vehicleName.isEmpty {
            return record.vehicleName
        }
        // Priority 3: Default text
        return "Select Vehicle"
    }


}

//MARK: -   ADdd a validation  for input fields
//struct DefectsSection: View  


struct DefectsSection: View {
    let title: String
    @Binding var selection: String?
    var onSelectNoDefect: (() -> Void)? = nil
    let onSelectDefect: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                selection = "no"
                onSelectNoDefect?()
            }) {
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

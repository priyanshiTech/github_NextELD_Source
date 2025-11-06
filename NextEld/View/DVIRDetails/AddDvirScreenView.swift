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
    @State private var truckDefectSelection: String? = nil
    @State private var trailerDefectSelection: String? = nil
    @State private var Showpopup: Bool = false
    @State private var selectedTab = ""
    @StateObject var trailerVM: TrailerViewModel = .init()
    @State private var selectedTrailer = ""
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
    @State private var selectedCoDriver: String? = nil
    @State private var validationMessage: String = ""
    @State private var showSignaturePad = false
    @State private var showCoDriverPopup = false
    @EnvironmentObject var shippingVM: ShippingDocViewModel
    
  

    @State private var showPopup = false
    @State private var popupType: String = "" // "Truck" or "Trailer"
    @StateObject var defectVM = DefectAPIViewModel(networkManager: NetworkManager())

    @State private var signaturePoints: [CGPoint] = []
    @State private var signatureImage: UIImage? = nil
    var existingRecord: DvirRecord?    // for editiong
    
    // Computed property to determine button text based on whether editing or adding
    private var buttonText: String {
        if let record = selectedRecord, record.id != nil {
            return "Update Dvir"
        } else {
            return "Add Dvir"
        }
    }
    
    // MARK: - Computed Views
    private var topStrip: some View {
                ZStack(alignment: .topLeading) {
                    Color(UIColor.wine)
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 10)
        }
                }
                
    private var headerView: some View {
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
                }
                
    private var mainContent: some View {
                UniversalScrollView {
                    VStack(spacing: 8) {
                driverInfoSection
                vehicleSection
                trailerSection
                defectSection
                notesSection
                signatureButton
            }
            .onAppear(perform: loadRecordData)
        }
        .padding(.horizontal, 5)
    }
    
    private var driverInfoSection: some View {
                        CardContainer {
                            VStack(alignment: .leading, spacing: 15) {
                                DvirField(label: "Driver", value: driverName)
                                DvirField(label: "Time", value: Drivetime.isEmpty ? DateTimeHelper.currentTime() : Drivetime)
                                DvirField(label: "Date", value: StartTime.isEmpty ? DateTimeHelper.currentDate() : StartTime)
                                DvirField(label: "Odometer", value: "0")
                                DvirField(label: "Company", value: companyName)
                                DvirField(label: "Location", value: DVClocationManager.fullAddress ?? "Not found")
            }
                            }
                        }
                        
    private var vehicleSection: some View {
                        CardContainer {
                            Button(action: {
                print(" Navigate to AddVehicleForDvir - Current vehicle: \(vehicleVM.selectedVehicleNumber)")
                                navmanager.navigate(to: AppRoute.DvirFlow.AddVehicleForDVIR)
                            }) {
                                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Vehicle")
                                            .font(.headline)
                                            .foregroundColor(.black)
                        Text(vehicleVM.selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "Select Vehicle") : vehicleVM.selectedVehicleNumber)
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
                        }
                        
    private var trailerSection: some View {
                        CardContainer {
                            Button(action: {
                                navmanager.path.append(AppRoute.DvirFlow.trailerScreen)
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Trailer")
                                            .font(.headline)
                                            .foregroundColor(.black)
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
                        }

    private var defectSection: some View {
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
                        }

    private var notesSection: some View {
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
                    vehicleVM.showPopupVechicle = true
                                    print("Vehicle Condition Added")
                                }) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Vehicle Condition")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
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
                    
    private var signatureButton: some View {
                    CardContainer {
                        Button(action: {
                  showSignaturePopup = true
                        }) {
                HStack {
                    if let signatureImage = signatureImage {
                        Image(uiImage: signatureImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .cornerRadius(8)
                            .padding(.trailing, 8)
                            } else {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                    
                    Text(signatureImage != nil ? "View/Edit Signature" : "Add Driver Signature")
                        .foregroundColor(.black)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .cornerRadius(10)
            }
        }
    }
    
    private var addDvirButton: some View {
        Button(action: handleAddDvirButtonTap) {
            Text(buttonText)
                            .frame(maxWidth: .infinity)
                .frame(height: 50)
                            .foregroundColor(.white)
                            .background(Color(UIColor.wine))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                topStrip
                headerView
                mainContent
                addDvirButton
            }
            .navigationDestination(for: AppRoute.DvirFlow.self, destination: { type in
                switch type {
                case .trailerScreen:
                    TrailerView(trailerVM: trailerVM, tittle: AppConstants.trailersTittle, trailers: $trailerVM.trailers)
                case .ShippingDocment:
                    ShippingDocView(tittle: AppConstants.shippingTittle)
                case .AddVehicleForDVIR:
                    AddVehicleForDvir(selectedVehicleNumber: $vehicleVM.selectedVehicleNumber, VechicleID: $vehicleVM.vehicleID)
                default:
                    EmptyView()
                }
            })
            .navigationBarBackButtonHidden()
            .onAppear {
                print(" AddDvirScreenView - onAppear called")
                loadRecordData()
                
                // Update Location from DVClocationManager if available
                if let currentLocation = DVClocationManager.fullAddress, !currentLocation.isEmpty {
                    Location = currentLocation
                    print(" Location updated from DVClocationManager: \(currentLocation)")
                }
                
                if trailers != trailerVM.trailers {
                    trailers = trailerVM.trailers
                }
            }
            .onChange(of: trailerVM.trailers) { newValue in
                if trailers != newValue {
                    trailers = newValue
                }
            }
            .onChange(of: trailers) { newValue in
                if trailerVM.trailers != newValue {
                    trailerVM.trailers = newValue
                }
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
            
            if vehicleVM.showPopupVechicle {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { vehicleVM.showPopupVechicle = false }
                
                VehicleConditionPopupView(isPresented: $vehicleVM.showPopupVechicle)
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
        .animation(.easeInOut, value: showPopup)
        .animation(.easeInOut, value: vehicleVM.showPopupVechicle)
    }
    // MARK: - Load Record Data
    private func loadRecordData() {
        // Always load login data first
        loadLoginData()
        
        // If no selectedRecord, initialize for new record
        guard let selectedRecord else {
            // For new record, set default values
            StartTime = DateTimeHelper.currentDate()
            Drivetime = DateTimeHelper.currentTime()
            // Initialize vehicle from AppStorage if not already set
            if vehicleVM.selectedVehicleNumber.isEmpty, let vehicleNo = AppStorageHandler.shared.vehicleNo, !vehicleNo.isEmpty {
                vehicleVM.selectedVehicleNumber = vehicleNo
                vehicleVM.vehicleID = AppStorageHandler.shared.vehicleId ?? 0
            }
            return
        }
        
        let previousVehicleNumber = vehicleVM.selectedVehicleNumber
        let previousVehicleID = vehicleVM.vehicleID
        
        if selectedRecord.id != nil {
            driverName = selectedRecord.UserName
            odometer = selectedRecord.odometer ?? 000.0
            Location = selectedRecord.location
            notesText = selectedRecord.notes
            truckDefectSelection = selectedRecord.truckDefect.isEmpty ? "no" : selectedRecord.truckDefect
            trailerDefectSelection = selectedRecord.trailerDefect.isEmpty ? "no" : selectedRecord.trailerDefect
            // Use DAY for date and DvirTime for time (same as shown in EmailDvir list)
            StartTime = selectedRecord.DAY.isEmpty ? DateTimeHelper.currentDate() : selectedRecord.DAY
            Drivetime = selectedRecord.DvirTime.isEmpty ? DateTimeHelper.currentTime() : selectedRecord.DvirTime
            
            if vehicleVM.selectedCondition == nil || vehicleVM.selectedCondition == "None" {
                vehicleVM.selectedCondition = selectedRecord.vehicleCondition.isEmpty ? "None" : selectedRecord.vehicleCondition
            }
            
            if !selectedRecord.Trailer.isEmpty {
                let trailerList = selectedRecord.Trailer.contains(",")
                    ? selectedRecord.Trailer.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    : [selectedRecord.Trailer]
                trailerVM.trailers = trailerList
            } else {
                trailerVM.trailers = []
            }
            
            if let signatureData = selectedRecord.signature,
               let image = UIImage(data: signatureData) {
                signatureImage = image
            } else {
                signatureImage = nil
            }
            
            if previousVehicleNumber.isEmpty {
                let vehicleName = selectedRecord.vehicleName
                if !vehicleName.isEmpty {
                    vehicleVM.selectedVehicleNumber = vehicleName
                    vehicleVM.vehicleID = Int(selectedRecord.vechicleID) ?? 0
                }
            }
        } else {
            StartTime = DateTimeHelper.currentDate()
            Drivetime = DateTimeHelper.currentTime()
            if vehicleVM.selectedVehicleNumber.isEmpty {
                let vehicleName = selectedRecord.vehicleName
                if !vehicleName.isEmpty {
                    vehicleVM.selectedVehicleNumber = vehicleName
                    vehicleVM.vehicleID = Int(selectedRecord.vechicleID) ?? 0
                }
            }
        }
        updateSelectedRecordFromVehicle()
    }
    
    // MARK: - Handle Add DVIR Button Tap
    private func handleAddDvirButtonTap() {
        print(" Add Dvir Button Clicked!")
        print(" Current form values:")
        print("   - Driver: \(driverName)")
        print("   - Vehicle: \(vehicleVM.selectedVehicleNumber)")
        print("   - VehicleID: \(vehicleVM.vehicleID)")
        print("   - Truck Defect: \(truckDefectSelection ?? "nil")")
        print("   - Trailer Defect: \(trailerDefectSelection ?? "nil")")
        print("   - Notes: \(notesText)")
        print("   - Condition: \(vehicleVM.selectedCondition ?? "nil")")
        print("   - Signature: \(signatureImage != nil ? "Present" : "Missing")")
        print("   - Trailers: \(trailerVM.trailers)")
        
        // Ensure login data is loaded
        if driverName.isEmpty || driverID.isEmpty {
            loadLoginData()
        }
        
        // Update Location from DVClocationManager before saving
        if let currentLocation = DVClocationManager.fullAddress, !currentLocation.isEmpty, currentLocation != "Not found" {
            Location = currentLocation
            print(" Location updated before save: \(currentLocation)")
        } else {
            print(" Location from DVClocationManager is not available, using stored Location: \(Location)")
        }
        
        // Set date/time if empty
        if StartTime.isEmpty {
            StartTime = DateTimeHelper.currentDate()
        }
        if Drivetime.isEmpty {
            Drivetime = DateTimeHelper.currentTime()
        }
        
        // Validate form
        if let errorMessage = validateForm() {
            print(" Validation Failed: \(errorMessage)")
            validationMessage = errorMessage
            showValidationAlert = true
            return
        }
        
        print(" Validation Passed - Proceeding to save")
        
        // Create working record with current form values
        let vehicleName = vehicleVM.selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : vehicleVM.selectedVehicleNumber
        let vehicleId = vehicleVM.vehicleID > 0 ? "\(vehicleVM.vehicleID)" : (AppStorageHandler.shared.vehicleId.map { "\($0)" } ?? "0")
        
        var workingRecord: DvirRecord
        if let existingRecord = selectedRecord, let existingId = existingRecord.id {
            // Updating existing record
            print(" Updating existing record with ID: \(existingId)")
            workingRecord = existingRecord
            workingRecord.vehicleName = vehicleName.isEmpty ? existingRecord.vehicleName : vehicleName
            workingRecord.vechicleID = vehicleId
        } else {
            // Creating new record
            print("➕ Creating new record")
            workingRecord = DvirRecord(
                id: nil,
                UserID: driverID,
                UserName: driverName,
                startTime: "\(StartTime) \(Drivetime)",
                DAY: StartTime,
                Shift: "\(AppStorageHandler.shared.shift)",
                DvirTime: Drivetime,
                odometer: odometer,
                location: Location,
                truckDefect: truckDefectSelection ?? "No",
                trailerDefect: trailerDefectSelection ?? "No",
                vehicleCondition: vehicleVM.selectedCondition ?? "None",
                notes: notesText,
                vehicleName: vehicleName,
                vechicleID: vehicleId,
                Sync: 1,
                timestamp: "\(Int(Date().timeIntervalSince1970 * 1000))",
                Server_ID: "",
                Trailer: trailerVM.trailers.joined(separator: ", "),
                signature: signatureImage?.pngData()
            )
        }
        
        saveDvirRecord(workingRecord: workingRecord)
    }
    
    // MARK: - Save DVIR Record
    private func saveDvirRecord(workingRecord: DvirRecord) {
        print(" ========== SAVE DVIR RECORD ==========")
        print(" Validation Passed - Starting Database Save")
        print(" Working Record Vehicle: \(workingRecord.vehicleName)")
        print(" Working Record VehicleID: \(workingRecord.vechicleID)")
        
        let currentDay = StartTime.isEmpty ? DateTimeHelper.currentDate() : StartTime
        let currentTime = Drivetime.isEmpty ? DateTimeHelper.currentTime() : Drivetime
        
        // Convert signature image to JPEG data (better for server)
        var signatureData: Data? = nil
        if let signatureImage = signatureImage {
            print(" Signature image exists, converting to JPEG...")
            // Try JPEG first (better compression, smaller size)
            if let jpegData = signatureImage.jpegData(compressionQuality: 0.8) {
                signatureData = jpegData
                print(" Signature converted to JPEG: \(jpegData.count) bytes")
            } else if let pngData = signatureImage.pngData() {
                // Fallback to PNG if JPEG fails
                signatureData = pngData
                print(" Signature converted to PNG: \(pngData.count) bytes")
            } else {
                print(" Failed to convert signature image to data")
            }
        } else {
            print(" No signature image found")
        }
        
        print(" Final Signature Data Size: \(signatureData?.count ?? 0) bytes")
        print(" Driver: \(driverName)")
        print(" Vehicle: \(vehicleVM.selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : vehicleVM.selectedVehicleNumber)")
        print(" Truck Defect: \(truckDefectSelection ?? "No")")
        print(" Trailer Defect: \(trailerDefectSelection ?? "No")")
        print(" Trailers: \(trailerVM.trailers)")
        print(" Notes: \(notesText)")
        print(" Condition: \(vehicleVM.selectedCondition ?? "None")")
        
        // Get actual location from DVClocationManager (current location)
        let actualLocation = DVClocationManager.fullAddress ?? Location
        print(" Location from DVClocationManager: \(DVClocationManager.fullAddress ?? "nil")")
        print(" Location from UserDefaults: \(Location)")
        print(" Using Location: \(actualLocation)")
        
        // Use workingRecord values if available, otherwise use form values
        let finalVehicleName = workingRecord.vehicleName.isEmpty 
            ? (vehicleVM.selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : vehicleVM.selectedVehicleNumber)
            : workingRecord.vehicleName
        
        let finalVehicleID = workingRecord.vechicleID.isEmpty
            ? "\(vehicleVM.vehicleID > 0 ? vehicleVM.vehicleID : (AppStorageHandler.shared.vehicleId ?? 0))"
            : workingRecord.vechicleID
        
        var record = DvirRecord(
            id: workingRecord.id ?? existingRecord?.id,
            UserID: driverID,
            UserName: driverName,
            startTime: "\(currentDay) \(currentTime)",
            DAY: currentDay,
            Shift: "\(AppStorageHandler.shared.shift)",
            DvirTime: currentTime,
            odometer: odometer,
            location: actualLocation,
            truckDefect: truckDefectSelection ?? "No",
            trailerDefect: trailerDefectSelection ?? "No",
            vehicleCondition: vehicleVM.selectedCondition ?? "None",
            notes: notesText,
            vehicleName: finalVehicleName,
            vechicleID: finalVehicleID,
            Sync: 1,
            timestamp: "\(Int(Date().timeIntervalSince1970 * 1000))",
            Server_ID: existingRecord?.Server_ID ?? "",
            Trailer: trailerVM.trailers.isEmpty ? (existingRecord?.Trailer ?? "") : trailerVM.trailers.joined(separator: ", "),
            signature: signatureData
        )
        
        print(" Final Record - Vehicle: \(record)")

        
        let dvirRecord = DvirRecordRequestModel(
            driverId: driverDVIRId,
            dateTime: record.startTime,
            locationDvir: actualLocation,
            truckDefect: truckDefectSelection ?? "no",
            trailerDefect: trailerDefectSelection ?? "no",
            notes: notesText,
            vehicleCondition: vehicleVM.selectedCondition ?? "None",
            companyName: companyName,
            odometer: odometer,
            engineHour: 0,
            vehicleId: record.vechicleID,
            timestampDvir: "\(Int(Date().timeIntervalSince1970 * 1000))",
            tokenNo: AppStorageHandler.shared.authToken ?? "",
            clientId: AppStorageHandler.shared.clientId ?? 0,
            trailer: trailerVM.trailers.isEmpty ? "" : trailerVM.trailers.joined(separator: ", "),
            fileDVir: signatureData
        )
        
        if let existingId = record.id {
            // Updating existing record
            print(" Updating existing record in database with ID: \(existingId)")
            record.id = existingId
            DvirDatabaseManager.shared.updateRecord(record)
            let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
            if allRecords.first(where: { $0.id == existingId }) != nil {
                print(" Record updated successfully in database!")
                successMessage = "DVIR Record Updated Successfully!\n\nDriver: \(driverName)\nVehicle: \(record.vehicleName)\nDate: \(record.DAY)"
                showSuccessAlert = true
            } else {
                print(" Failed to verify record update in database")
            }
            print(" Calling update API...")
            updateDvirDataUsingCommonService(record: record, dvirLogId: driverID)
            NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
            print(" Update notification posted")
        } else {
            // Inserting new record
            print("➕ Inserting new record to database...")
            DvirDatabaseManager.shared.insertRecord(record)
            let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
            if let savedRecord = allRecords.last {
          
                successMessage = "DVIR Record Saved Successfully!\n\nDriver: \(driverName)\nVehicle: \(record.vehicleName)\nDate: \(record.DAY)"
                showSuccessAlert = true
            } else {
                print(" Failed to verify record insertion in database")
            }
            print(" ========== CALLING dispatchadd_dvir_data API ==========")
            uploadDvirDataUsingCommonService(record: dvirRecord)
            print(" API call initiated successfully!")
       
            NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
            print("Insert notification posted")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if isFromHome {
                navmanager.navigate(to: AppRoute.HomeFlow.Home)
            } else {
                navmanager.navigate(to: AppRoute.HomeFlow.AddDvirPriTrip)
            }
        }
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
        } else if !vehicleVM.selectedVehicleNumber.isEmpty {
            vehicleName = vehicleVM.selectedVehicleNumber
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
        if signatureImage == nil { return "Please add Driver Signature" }
        return nil //  No error
    }
    
    
    
    // MARK: - Update selectedRecord with vehicle information
    func updateSelectedRecordFromVehicle() {
        print("updateSelectedRecordFromVehicle called - selectedVehicleNumber: '\(vehicleVM.selectedVehicleNumber)', selectedVechicleID: \(vehicleVM.vehicleID)")
        
        guard !vehicleVM.selectedVehicleNumber.isEmpty && vehicleVM.vehicleID > 0 else {
            print("Cannot update - selectedVehicleNumber is empty or ID is 0")
            return
        }
        
        if var record = selectedRecord {
            record.vehicleName = vehicleVM.selectedVehicleNumber
            record.vechicleID = "\(vehicleVM.vehicleID)"
            selectedRecord = record
            print(" Updated selectedRecord - vehicleName: '\(vehicleVM.selectedVehicleNumber)', vechicleID: \(vehicleVM.vehicleID)")
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
        if !vehicleVM.selectedVehicleNumber.isEmpty {
            return vehicleVM.selectedVehicleNumber
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

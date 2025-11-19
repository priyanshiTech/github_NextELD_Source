//
//  AddDvirScreenView.swift
//  NextEld
//
//  Created by Priyanshi on 21/05/25.
//

import SwiftUI

struct AddDvirScreenView: View  {
    
    @EnvironmentObject var navmanager: NavigationManager
    @StateObject var trailerVM: TrailerViewModel = .init()
    @StateObject var vehicleVM: VehicleConditionViewModel = .init()
    @StateObject var DVClocationManager: DeviceLocationManager = .init()
    @StateObject var viewModel = AddDvirScreenViewModel()
    // "Truck" or "Trailer"
    @StateObject var defectVM = DefectAPIViewModel(networkManager: NetworkManager())
    @EnvironmentObject var appRootManager: AppRootManager
    @Binding var selectedRecord: DvirRecord?
    @Binding var trailers: [String]
    var isFromHome: Bool = false    //MARK: -  To handle Home Screen flag
    var existingRecord: DvirRecord?
    
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
                        .shadow(color: Color(uiColor:.black).opacity(0.2), radius: 4, x: 0, y: 4)
                    
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
                                DvirField(label: "Driver", value: viewModel.driverName)
                                DvirField(label: "Time", value: viewModel.Drivetime.isEmpty ? DateTimeHelper.currentTime() : viewModel.Drivetime)
                                DvirField(label: "Date", value: viewModel.StartTime.isEmpty ? DateTimeHelper.currentDate() : viewModel.StartTime)
                                DvirField(label: "Odometer", value: "0")
                                DvirField(label: "Company", value: viewModel.companyName)
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
                                            .foregroundColor(Color(uiColor:.black))
                        Text(vehicleVM.selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "Select Vehicle") : vehicleVM.selectedVehicleNumber)
                                            .font(.headline)
                                            .foregroundColor(Color(uiColor:.black))
                                    }
                                    Spacer()
                                    Image("pencil").foregroundColor(Color(uiColor:.gray))
                                }
                                .padding()
                                .background(Color(uiColor:.white))
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
                                            .foregroundColor(Color(uiColor:.black))
                                        Text(trailerVM.trailers.isEmpty ? "None" : trailerVM.trailers.joined(separator: ", "))
                                            .font(.headline)
                                            .foregroundColor(Color(uiColor:.black))
                                    }
                                    Spacer()
                                    Image("pencil").foregroundColor(Color(uiColor:.gray))
                                }
                                .padding()
                                .background(Color(uiColor:.white))
                            }
                            .buttonStyle(PlainButtonStyle())
        }
                        }

    private var defectSection: some View {
                        CardContainer {
                            VStack(spacing: 16) {
                                Text("Truck Defects").font(.headline)
                                DefectsSection(title: "Truck", selection: $trailerVM.truckDefectSelection, onSelectNoDefect: {
                                    alreadycheckAndSetVehicleCondition()
                                }) {
                                    trailerVM.truckDefectSelection = "yes"
                                    viewModel.popupType = "Truck"
                                    viewModel.showPopup = true
                                }

                                Text("Trailer Defects").font(.headline)
                                DefectsSection(title: "Trailer", selection: $trailerVM.trailerDefectSelection, onSelectNoDefect: {
                                    alreadycheckAndSetVehicleCondition()
                                }) {
                                    trailerVM.trailerDefectSelection = "yes"
                                    viewModel.popupType = "Trailer"
                                    viewModel.showPopup = true
                                }
                            }
                            .onChange(of: trailerVM.truckDefectSelection) { newValue in
                                alreadycheckAndSetVehicleCondition()
                            }
                            .onChange(of: trailerVM.trailerDefectSelection) { newValue in
                                alreadycheckAndSetVehicleCondition()
            }
                            }
                        }

    private var notesSection: some View {
                        CardContainer {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(Color(uiColor:.black))
                                .padding()
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $viewModel.notesText)
                                    .frame(height: 200)
                                    .padding(2)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)
                                
                                if viewModel.notesText.isEmpty {
                                    Text("Write note here...")
                                        .foregroundColor(Color(uiColor:.gray))
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
                                            .foregroundColor(Color(uiColor:.black))
                                        Text(vehicleVM.selectedCondition ?? "None")
                                            .font(.subheadline)
                                            .foregroundColor(Color(uiColor:.gray))
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
                  viewModel.showSignaturePopup = true
                        }) {
                HStack {
                    if let signatureImage = viewModel.signatureImage {
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
                    
                    Text(viewModel.signatureImage != nil ? "View/Edit Signature" : "Add Driver Signature")
                        .foregroundColor(Color(uiColor:.black))
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
                            .foregroundColor(Color(uiColor:.black))
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
                    viewModel.Location = currentLocation
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
                    .alert(isPresented: $viewModel.showValidationAlert) {
                        Alert(
                            title: Text("Missing Information"),
                            message: Text(viewModel.validationMessage),
                            dismissButton: .default(Text("OK"))
                        )
                   }
                    .alert(isPresented: $viewModel.showSuccessAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text(viewModel.successMessage),
                            dismissButton: .default(Text("OK")) {
                                print(" User acknowledged success message")
                            }
                        )
                   }
            
            
            // MARK: - Signature Popup Overlay

            if viewModel.showSignaturePopup {
                SignatureAddDvir(
                    isPresented: $viewModel.showSignaturePopup,
                    points: $viewModel.signaturePoints
                ) { image in
                    self.viewModel.signatureImage = image   //parent me image save ho rahi hai
                }
                .transition(.scale)
                .zIndex(1)
            }



            // MARK: - Defect Popup Overlay
            if viewModel.showPopup {
                Color(uiColor:.black).opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture { viewModel.showPopup = false }
                
                DefectPopupView(
                    isPresented: $viewModel.showPopup,
                    popupType: viewModel.popupType,
                    truckDefectSelection: $trailerVM.truckDefectSelection,
                    trailerDefectSelection: $trailerVM.trailerDefectSelection
                )
                .environmentObject(appRootManager)
                .frame(width: 300, height: 400)
                               .background(Color(uiColor:.white))
                               .cornerRadius(12)
                               .shadow(radius: 10)
                               .zIndex(2)
                               .transition(.scale)
             
            }


            //MARK: - Vehicle popup
            
            if vehicleVM.showPopupVechicle {
                Color(uiColor:.black).opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { vehicleVM.showPopupVechicle = false }
                
                VehicleConditionPopupView(isPresented: $vehicleVM.showPopupVechicle)
                    .environmentObject(vehicleVM)
                    .transition(.scale)
            }
        }
        .onAppear {
            defectVM.appRootManager = appRootManager
            Task {
                let success = await defectVM.fetchDefects()
                
                if defectVM.isSessionExpired {
                    print(" Session expired detected in AddDvirScreenView - staying on SessionExpireUIView")
                    return
                }
                
                if !success, let error = defectVM.errorMessage {
                    print(" Defect API error: \(error)")
                }
            }
        }
        .animation(.easeInOut, value: viewModel.showSignaturePopup)
        .animation(.easeInOut, value: viewModel.showPopup)
        .animation(.easeInOut, value: vehicleVM.showPopupVechicle)
    }
    // MARK: - Load Record Data
    private func loadRecordData() {
        // Always load login data first
        loadLoginData()
        
        // If no selectedRecord, initialize for new record
        guard let selectedRecord else {
            // For new record, set default values
            viewModel.StartTime = DateTimeHelper.currentDate()
            viewModel.Drivetime = DateTimeHelper.currentTime()
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
            viewModel.driverName = selectedRecord.UserName
            viewModel.odometer = selectedRecord.odometer ?? 000.0
            viewModel.Location = selectedRecord.location
            viewModel.notesText = selectedRecord.notes
            trailerVM.truckDefectSelection = selectedRecord.truckDefect.isEmpty ? "no" : selectedRecord.truckDefect
            trailerVM.trailerDefectSelection = selectedRecord.trailerDefect.isEmpty ? "no" : selectedRecord.trailerDefect
            // Use DAY for date and DvirTime for time (same as shown in EmailDvir list)
            viewModel.StartTime = selectedRecord.DAY.isEmpty ? DateTimeHelper.currentDate() : selectedRecord.DAY
            viewModel.Drivetime = selectedRecord.DvirTime.isEmpty ? DateTimeHelper.currentTime() : selectedRecord.DvirTime
            
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
                viewModel.signatureImage = image
            } else {
                viewModel.signatureImage = nil
            }
            
            if previousVehicleNumber.isEmpty {
                let vehicleName = selectedRecord.vehicleName
                if !vehicleName.isEmpty {
                    vehicleVM.selectedVehicleNumber = vehicleName
                    vehicleVM.vehicleID = Int(selectedRecord.vechicleID) ?? 0
                }
            }
        } else {
            viewModel.StartTime = DateTimeHelper.currentDate()
            viewModel.Drivetime = DateTimeHelper.currentTime()
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
        print("   - Driver: \(viewModel.driverName)")
        print("   - Vehicle: \(vehicleVM.selectedVehicleNumber)")
        print("   - VehicleID: \(vehicleVM.vehicleID)")
        print("   - Truck Defect: \(trailerVM.truckDefectSelection ?? "nil")")
        print("   - Trailer Defect: \(trailerVM.trailerDefectSelection ?? "nil")")
        print("   - Notes: \(viewModel.notesText)")
        print("   - Condition: \(vehicleVM.selectedCondition ?? "nil")")
        print("   - Signature: \(viewModel.signatureImage != nil ? "Present" : "Missing")")
        print("   - Trailers: \(trailerVM.trailers)")
        
        // Ensure login data is loaded
        if viewModel.driverName.isEmpty || viewModel.driverID.isEmpty {
            loadLoginData()
        }
        
        // Update Location from DVClocationManager before saving
        if let currentLocation = DVClocationManager.fullAddress, !currentLocation.isEmpty, currentLocation != "Not found" {
            viewModel.Location = currentLocation
            print(" Location updated before save: \(currentLocation)")
        } else {
            print(" Location from DVClocationManager is not available, using stored Location: \(viewModel.Location)")
        }
        
        // Set date/time if empty
        if viewModel.StartTime.isEmpty {
            viewModel.StartTime = DateTimeHelper.currentDate()
        }
        if viewModel.Drivetime.isEmpty {
            viewModel.Drivetime = DateTimeHelper.currentTime()
        }
        
        // Validate form
        if let errorMessage = validateForm() {
            print(" Validation Failed: \(errorMessage)")
            viewModel.validationMessage = errorMessage
            viewModel.showValidationAlert = true
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
                UserID: viewModel.driverID,
                UserName: viewModel.driverName,
                startTime: "\(viewModel.StartTime) \(viewModel.Drivetime)",
                DAY: viewModel.StartTime,
                Shift: "\(AppStorageHandler.shared.shift)",
                DvirTime: viewModel.Drivetime,
                odometer: viewModel.odometer,
                location: viewModel.Location,
                truckDefect: trailerVM.truckDefectSelection ?? "No",
                trailerDefect: trailerVM.trailerDefectSelection ?? "No",
                vehicleCondition: vehicleVM.selectedCondition ?? "None",
                notes: viewModel.notesText,
                vehicleName: vehicleName,
                vechicleID: vehicleId,
                Sync: 1,
                timestamp: "\(Int(Date().timeIntervalSince1970 * 1000))",
                Server_ID: "",
                Trailer: trailerVM.trailers.joined(separator: ", "),
                signature: viewModel.signatureImage?.pngData()
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
        
        let currentDay = viewModel.StartTime.isEmpty ? DateTimeHelper.currentDate() : viewModel.StartTime
        let currentTime = viewModel.Drivetime.isEmpty ? DateTimeHelper.currentTime() : viewModel.Drivetime
        
        // Convert signature image to JPEG data (better for server)
        var signatureData: Data? = nil
        if let signatureImage = viewModel.signatureImage {
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
        print(" Driver: \(viewModel.driverName)")
        print(" Vehicle: \(vehicleVM.selectedVehicleNumber.isEmpty ? (AppStorageHandler.shared.vehicleNo ?? "") : vehicleVM.selectedVehicleNumber)")
        print(" Truck Defect: \(trailerVM.truckDefectSelection ?? "No")")
        print(" Trailer Defect: \(trailerVM.trailerDefectSelection ?? "No")")
        print(" Trailers: \(trailerVM.trailers)")
        print(" Notes: \(viewModel.notesText)")
        print(" Condition: \(vehicleVM.selectedCondition ?? "None")")
        
        // Get actual location from DVClocationManager (current location)
        let actualLocation = DVClocationManager.fullAddress ?? viewModel.Location
        print(" Location from DVClocationManager: \(DVClocationManager.fullAddress ?? "nil")")
        print(" Location from UserDefaults: \(viewModel.Location)")
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
            UserID: viewModel.driverID,
            UserName: viewModel.driverName,
            startTime: "\(currentDay) \(currentTime)",
            DAY: currentDay,
            Shift: "\(AppStorageHandler.shared.shift)",
            DvirTime: currentTime,
            odometer: viewModel.odometer,
            location: actualLocation,
            truckDefect: trailerVM.truckDefectSelection ?? "No",
            trailerDefect: trailerVM.trailerDefectSelection ?? "No",
            vehicleCondition: vehicleVM.selectedCondition ?? "None",
            notes: viewModel.notesText,
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
            driverId: viewModel.driverDVIRId,
            dateTime: record.startTime,
            locationDvir: actualLocation,
            truckDefect: trailerVM.truckDefectSelection ?? "no",
            trailerDefect: trailerVM.trailerDefectSelection ?? "no",
            notes: viewModel.notesText,
            vehicleCondition: vehicleVM.selectedCondition ?? "None",
            companyName: viewModel.companyName,
            odometer: viewModel.odometer,
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
                viewModel.successMessage = "DVIR Record Updated Successfully!\n\nDriver: \(viewModel.driverName)\nVehicle: \(record.vehicleName)\nDate: \(record.DAY)"
                viewModel.showSuccessAlert = true
            } else {
                print(" Failed to verify record update in database")
            }
            print(" Calling update API...")
            updateDvirDataUsingCommonService(record: record, dvirLogId: viewModel.driverID, appRootManager: appRootManager)
            NotificationCenter.default.post(name: NSNotification.Name("DVIRRecordUpdated"), object: nil)
            print(" Update notification posted")
        } else {
            // Inserting new record
            print("➕ Inserting new record to database...")
            DvirDatabaseManager.shared.insertRecord(record)
            let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
            if let savedRecord = allRecords.last {
          
                viewModel.successMessage = "DVIR Record Saved Successfully!\n\nDriver: \(viewModel.driverName)\nVehicle: \(record.vehicleName)\nDate: \(record.DAY)"
                viewModel.showSuccessAlert = true
            } else {
                print(" Failed to verify record insertion in database")
            }
            print(" ========== CALLING dispatchadd_dvir_data API ==========")
            uploadDvirDataUsingCommonService(record: dvirRecord, appRootManager: appRootManager)
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
        viewModel.driverName = UserDefaults.standard.string(forKey: "driverName") ?? "N/A"
        viewModel.Location = UserDefaults.standard.string(forKey: "customLocation") ?? "N/A"
        viewModel.companyName = AppStorageHandler.shared.company ?? ""
        //UserDefaults.standard.string(forKey: "companyName") ?? "N/A"
        viewModel.driverID = UserDefaults.standard.string(forKey: "userId") ?? "n/a"
        // Set driverDVIRId from AppStorageHandler or UserDefaults
        viewModel.driverDVIRId = AppStorageHandler.shared.driverId ?? Int(viewModel.driverID) ?? 0

   }

    // MARK: - Validation that returns custom error message
    func validateForm() -> String? {
        if viewModel.driverName.isEmpty { return "Please enter Driver Name" }
        if viewModel.StartTime.isEmpty { return "Please enter Time" }
        if viewModel.Drivetime.isEmpty { return "Please enter Day" }

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
        if trailerVM.truckDefectSelection == nil { return "Please select Truck Defect status" }
        if trailerVM.trailerDefectSelection == nil { return "Please select Trailer Defect status" }
        if viewModel.notesText.isEmpty { return "Please enter Notes" }
        if vehicleVM.selectedCondition?.isEmpty ?? true { return "Please select Vehicle Condition" }
        if viewModel.signatureImage == nil { return "Please add Driver Signature" }
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
        if trailerVM.truckDefectSelection == "no" && trailerVM.trailerDefectSelection == "no" {
            vehicleVM.selectedCondition = "Vehicle Condition Satisfactory"
        }
        else if trailerVM.truckDefectSelection == "yes" || trailerVM.trailerDefectSelection == "yes" {
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

//
//  AddDvirPopupHome.swift
//  NextEld
//
//  Created by priyanshi on 31/10/25.
//
import SwiftUI
import UIKit
import AVFoundation



// MARK: - Defect Model
struct DefectItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String // "Truck" or "Trailer"
    var isUploaded: Bool = false
    var isUploading: Bool = false
}

// MARK: - UploadDefectView
struct UploadDefectView: View {
    
    var selectedRecord: DvirRecord?
    @EnvironmentObject var navmanager: NavigationManager
    @StateObject private var viewModel = AddDefectViewModel()
    
    @State private var showUploadPopup = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var showImagePreview = false
    @State private var selectedDefectType = ""
    @State private var selectedDefectItem: DefectItem?
    @State private var defectItems: [DefectItem] = []
    @State private var currentRecord: DvirRecord? = nil
    @State private var showCameraUnavailableAlert = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            mainContent
            
            if showUploadPopup {
                uploadOptionPopup
            }
            
            if showImagePreview, let image = selectedImage {
                imagePreviewPopup(image)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
                .ignoresSafeArea()
        }
        .alert("Camera Not Available", isPresented: $showCameraUnavailableAlert) {
            Button("Use Photo Library") {
                fallbackToPhotoLibrary()
            }
            Button("Cancel", role: .cancel) {
                showUploadPopup = false
            }
        } message: {
            Text("Camera is not available on this device. Would you like to use the photo library instead?")
        }
        .onAppear(perform: initializeData)
        .onChange(of: selectedImage) { _, newValue in
            handleImageSelection(newValue)
        }
        .onChange(of: selectedRecord) { _ in
            reloadDefectsFromRecord()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DVIRRecordUpdated"))) { _ in
            reloadDefectsFromRecord()
        }
    }
}

// MARK: - Main UI
extension UploadDefectView {
    private var mainContent: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    defectSection(title: "Truck Defect", defects: truckDefects)
                    defectSection(title: "Trailer Defect", defects: trailerDefects)
                }
                .padding()
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: { navmanager.goBack() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
            
            Text("Upload Defects")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(Color(uiColor: .wine))
        .shadow(radius: 2)
    }
    
    private func defectSection(title: String, defects: [DefectItem]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            if defects.isEmpty {
                DefectRowView(defectText: "None", isUploaded: false, onUpload: {})
            } else {
                ForEach(defects) { defect in
                    if let index = defectItems.firstIndex(where: { $0.id == defect.id }) {
                        DefectRowView(
                            defectText: defect.name,
                            isUploaded: defectItems[index].isUploaded,
                            isUploading: defectItems[index].isUploading,
                            onUpload: {
                                selectedDefectItem = defectItems[index]
                                selectedDefectType = defectItems[index].type
                                withAnimation(.easeInOut) { showUploadPopup = true }
                            }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Popups
extension UploadDefectView {
    private var uploadOptionPopup: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { showUploadPopup = false } }
            
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                
                Text("Select Option")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                
                HStack(spacing: 150) {
                    uploadOptionButton(image: "camera", label: "Camera") {
                        openCamera()
                    }
                    uploadOptionButton(image: "apple", label: "Gallery") {
                        openGallery()
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            .transition(.move(edge: .bottom))
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    private func uploadOptionButton(image: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(image)
                    .resizable()
                    .frame(width: 40, height: 35)
                Text(label)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func imagePreviewPopup(_ image: UIImage) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Document")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: { showImagePreview = false }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .font(.title2)
                        .bold()
                }
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .background(Color.gray.opacity(0.1))
            
            Button(action: { uploadSelectedImage(image) }) {
                Text(viewModel.isUploading ? "Uploading..." : "Upload")
                    .font(.headline)
                    .foregroundColor(.white)
                   // .frame(maxWidth: .infinity, height: 50)
                    .frame(width: .infinity , height: 50)
                    .background(viewModel.isUploading ? Color.gray : Color(UIColor.wine))
                    .cornerRadius(8)
                    .padding()
            }
            .disabled(viewModel.isUploading)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9,
               height: UIScreen.main.bounds.height * 0.7)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

// MARK: - Logic
extension UploadDefectView {
    private var truckDefects: [DefectItem] {
        defectItems.filter { $0.type == "Truck" }
    }
    private var trailerDefects: [DefectItem] {
        defectItems.filter { $0.type == "Trailer" }
    }
    
    private func initializeData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            refreshRecordFromDatabase()
            defectItems = getAllDefectItems()
        }
    }
    
    private func reloadDefectsFromRecord() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            refreshRecordFromDatabase()
            defectItems = getAllDefectItems()
        }
    }
    
    private func handleImageSelection(_ newValue: UIImage?) {
        if newValue != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showImagePreview = true
            }
        }
    }
    
    private func fallbackToPhotoLibrary() {
        sourceType = .photoLibrary
        withAnimation(.easeInOut) { showUploadPopup = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showImagePicker = true
        }
    }
    
    private func openCamera() {
        // First check if camera is available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraUnavailableAlert = true
            return
        }
        
        // Check and request camera permission
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            // Permission already granted, open camera
            sourceType = .camera
            withAnimation(.easeInOut) { showUploadPopup = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showImagePicker = true }
            
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.sourceType = .camera
                        withAnimation(.easeInOut) { self.showUploadPopup = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.showImagePicker = true
                        }
                    } else {
                        // Permission denied, show alert
                        self.showCameraPermissionDeniedAlert()
                    }
                }
            }
            
        case .denied, .restricted:
            // Permission denied or restricted, show alert to go to settings
            showCameraPermissionDeniedAlert()
            
        @unknown default:
            showCameraUnavailableAlert = true
        }
    }
    
    private func showCameraPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "Please enable camera access in Settings to take photos for defect upload.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
    
    private func openGallery() {
        sourceType = .photoLibrary
        withAnimation(.easeInOut) { showUploadPopup = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showImagePicker = true }
    }
    
    private func uploadSelectedImage(_ image: UIImage) {
        guard let defectItem = selectedDefectItem else { return }
        setDefectItemUploading(defectItem, isUploading: true)
        
        viewModel.uploadDefectImage(image: image, defectType: selectedDefectType, defectName: defectItem.name) { success in
            if success {
                updateDefectItemStatus(defectItem, isUploaded: true)
                showImagePreview = false
                selectedImage = nil
            } else {
                setDefectItemUploading(defectItem, isUploading: false)
            }
        }
    }
}

// MARK: - Database Helpers
extension UploadDefectView {
    private func parseDefects(_ defectsString: String, type: String) -> [DefectItem] {
        let trimmed = defectsString.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, trimmed.lowercased() != "no" else { return [] }
        
        var defectNames: [String]
        if trimmed.lowercased() == "yes" {
            defectNames = ["Defect Reported"]
        } else if trimmed.contains(",") {
            defectNames = trimmed.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.lowercased() != "yes" && $0.lowercased() != "no" }
        } else {
            defectNames = [trimmed]
        }
        return defectNames.map { DefectItem(name: $0, type: type) }
    }
    
    private func getAllDefectItems() -> [DefectItem] {
        var items: [DefectItem] = []
        let recordToUse = currentRecord ?? selectedRecord
        if let record = recordToUse {
            items.append(contentsOf: parseDefects(record.truckDefect, type: "Truck"))
            items.append(contentsOf: parseDefects(record.trailerDefect, type: "Trailer"))
        }
        return items
    }
    
    private func refreshRecordFromDatabase() {
        let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
        guard !allRecords.isEmpty else {
            currentRecord = selectedRecord
            return
        }
        
        let sortedRecords = allRecords.sorted { ($0.id ?? 0) > ($1.id ?? 0) }
        if let recordId = selectedRecord?.id,
           let updatedRecord = allRecords.first(where: { $0.id == recordId }) {
            currentRecord = updatedRecord
        } else {
            currentRecord = sortedRecords.first ?? selectedRecord
        }
    }
    
    private func updateDefectItemStatus(_ item: DefectItem, isUploaded: Bool) {
        if let index = defectItems.firstIndex(where: { $0.id == item.id }) {
            defectItems[index].isUploaded = isUploaded
            defectItems[index].isUploading = false
        }
    }
    
    private func setDefectItemUploading(_ item: DefectItem, isUploading: Bool) {
        if let index = defectItems.firstIndex(where: { $0.id == item.id }) {
            defectItems[index].isUploading = isUploading
        }
    }
}

#Preview {
    UploadDefectView(selectedRecord: nil)
}













































/*struct DefectItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String // "Truck" or "Trailer"
    var isUploaded: Bool = false
    var isUploading: Bool = false
}

struct UploadDefectView: View {
    
    var selectedRecord: DvirRecord?
    @EnvironmentObject var navmanager: NavigationManager
    @StateObject private var viewModel = AddDefectViewModel()
    @State private var showUploadPopup = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var showImagePreview = false
    @State private var selectedDefectType = ""
    @State private var selectedDefectItem: DefectItem?
    @State private var defectItems: [DefectItem] = []
    @State private var currentRecord: DvirRecord? = nil  // Store current record with latest data
    @State private var showCameraUnavailableAlert = false
    
    // Helper to parse defects from comma-separated string
    private func parseDefects(_ defectsString: String, type: String) -> [DefectItem] {
        let trimmed = defectsString.trimmingCharacters(in: .whitespaces)
        
        // Debug logging
        print(" Parsing defects for \(type): '\(trimmed)'")
        
        if trimmed.isEmpty || trimmed.lowercased() == "no" {
            print(" No defects found (empty or 'no')")
            return []
        }
        
        // Handle different formats:
        // 1. Comma-separated: "Brake Issue, Tire Problem"
        // 2. Single defect: "Brake Issue"
        // 3. Legacy "yes": treat as single defect
        var defectNames: [String] = []
        
        if trimmed.lowercased() == "yes" {
            // Legacy format - "yes" means there's a defect but no specific name
            defectNames = ["Defect Reported"]
            print(" Legacy 'yes' format detected")
        } else if trimmed.contains(",") {
            // Comma-separated defects
            defectNames = trimmed.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.lowercased() != "yes" && $0.lowercased() != "no" }
            print("Comma-separated defects: \(defectNames)")
        } else {
            // Single defect
            defectNames = [trimmed]
            print(" Single defect: \(defectNames)")
        }
        
        let items = defectNames.map { DefectItem(name: $0, type: type) }
        print(" Created \(items.count) defect items for \(type)")
        return items
    }
    
    // Helper to get all defect items
    private func getAllDefectItems() -> [DefectItem] {
        var items: [DefectItem] = []
        
        // Use currentRecord (latest from DB) if available, otherwise use selectedRecord
        let recordToUse = currentRecord ?? selectedRecord
        
        // Debug logging
        if let record = recordToUse {
            print(" Loading defects from record:")
            print("   Record ID: \(record.id ?? -1)")
            print("   Truck Defect: '\(record.truckDefect)'")
            print("   Trailer Defect: '\(record.trailerDefect)'")
            
            // Add truck defects
            let truckDefects = parseDefects(record.truckDefect, type: "Truck")
            items.append(contentsOf: truckDefects)
            
            // Add trailer defects
            let trailerDefects = parseDefects(record.trailerDefect, type: "Trailer")
            items.append(contentsOf: trailerDefects)
            
            print(" Total defect items created: \(items.count)")
            items.forEach { item in
                print("   - [\(item.type)] \(item.name)")
            }
        } else {
            print(" No selected record found!")
        }
        
        return items
    }
    
    // Helper to refresh record from database - Always get the latest record
    private func refreshRecordFromDatabase() {
        let allRecords = DvirDatabaseManager.shared.fetchAllRecords()
        
        guard !allRecords.isEmpty else {
            print(" No records found in database")
            currentRecord = selectedRecord
            return
        }
        
        // Sort records by ID (descending) to get the most recent one
        // New records will have higher IDs due to auto-increment
        let sortedRecords = allRecords.sorted { record1, record2 in
            let id1 = record1.id ?? 0
            let id2 = record2.id ?? 0
            return id1 > id2  // Latest first
        }
        
        // Priority 1: If selectedRecord has ID, try to find it first (might be updated)
        if let recordId = selectedRecord?.id {
            if let updatedRecord = allRecords.first(where: { $0.id == recordId }) {
                print("  Using updated record from database - ID: \(recordId)")
                print("   Truck Defect: '\(updatedRecord.truckDefect)'")
                print("   Trailer Defect: '\(updatedRecord.trailerDefect)'")
                currentRecord = updatedRecord
                return
            }
        }
        
        // Priority 2: Use the latest record (highest ID = most recent)
        if let latestRecord = sortedRecords.first {
            print("  Using LATEST record from database - ID: \(latestRecord.id ?? -1)")
            print("   Date/Time: \(latestRecord.DAY) \(latestRecord.DvirTime)")
            print("   Truck Defect: '\(latestRecord.truckDefect)'")
            print("   Trailer Defect: '\(latestRecord.trailerDefect)'")
            currentRecord = latestRecord
        } else {
            // Fallback to selectedRecord if available
            print(" ⚠️ No records found, using selectedRecord")
            currentRecord = selectedRecord
        }
    }
    
    // Helper to update defect item upload status
    private func updateDefectItemStatus(_ item: DefectItem, isUploaded: Bool) {
        if let index = defectItems.firstIndex(where: { $0.id == item.id }) {
            defectItems[index].isUploaded = isUploaded
            defectItems[index].isUploading = false
        }
    }
    
    // Helper to set defect item uploading status
    private func setDefectItemUploading(_ item: DefectItem, isUploading: Bool) {
        if let index = defectItems.firstIndex(where: { $0.id == item.id }) {
            defectItems[index].isUploading = isUploading
        }
    }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                
                // MARK: - Top Bar
                HStack {
                    Button(action: {
                        navmanager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                    
                    Text("Upload Defects")
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color(uiColor: .wine))
                .shadow(radius: 2)
                
                // MARK: - Defect Sections
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Truck Defect Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Truck Defect")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            let truckDefects = defectItems.filter { $0.type == "Truck" }
                            if truckDefects.isEmpty {
                                DefectRowView(
                                    defectText: "None",
                                    isUploaded: false,
                                    onUpload: {
                                        // Truck section upload (if needed)
                                    }
                                )
                            } else {
                                ForEach(truckDefects.indices, id: \.self) { index in
                                    if let defectIndex = defectItems.firstIndex(where: { $0.id == truckDefects[index].id }) {
                                        DefectRowView(
                                            defectText: truckDefects[index].name,
                                            isUploaded: defectItems[defectIndex].isUploaded,
                                            isUploading: defectItems[defectIndex].isUploading,
                                            onUpload: {
                                                selectedDefectItem = defectItems[defectIndex]
                                                selectedDefectType = defectItems[defectIndex].type
                                                withAnimation(.easeInOut) {
                                                    showUploadPopup = true
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        
                        // Trailer Defect Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Trailer Defect")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            let trailerDefects = defectItems.filter { $0.type == "Trailer" }
                            if trailerDefects.isEmpty {
                                DefectRowView(
                                    defectText: "None",
                                    isUploaded: false,
                                    onUpload: {
                                        // Trailer section upload (if needed)
                                    }
                                )
                            } else {
                                ForEach(trailerDefects.indices, id: \.self) { index in
                                    if let defectIndex = defectItems.firstIndex(where: { $0.id == trailerDefects[index].id }) {
                                        DefectRowView(
                                            defectText: trailerDefects[index].name,
                                            isUploaded: defectItems[defectIndex].isUploaded,
                                            isUploading: defectItems[defectIndex].isUploading,
                                            onUpload: {
                                                selectedDefectItem = defectItems[defectIndex]
                                                selectedDefectType = defectItems[defectIndex].type
                                                withAnimation(.easeInOut) {
                                                    showUploadPopup = true
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - Bottom Sheet Popup
            if showUploadPopup {
                ZStack {
                    // Background overlay
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            print("🔘 Background tapped, closing popup")
                            withAnimation(.easeInOut) {
                                showUploadPopup = false
                            }
                        }
                    
                    // Popup content
                    VStack(spacing: 16) {
                        Capsule()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        Text("Select Option")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.top, 5)
                        
                        HStack(spacing: 150) {
                            Button(action: {
                                print(" Camera tapped - Checking camera availability...")
                                
                                // Check if camera is available before setting sourceType
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    print(" Camera is available - Setting sourceType to camera")
                                    sourceType = .camera
                                    print(" sourceType set, closing popup...")
                                    withAnimation(.easeInOut) {
                                        showUploadPopup = false
                                    }
                                    print(" Popup closed, waiting 0.3s to open image picker...")
                                    // Small delay to allow popup to close before opening image picker
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        print(" Opening camera with showImagePicker = true")
                                        showImagePicker = true
                                        print(" showImagePicker is now: \(showImagePicker)")
                                    }
                                } else {
                                    print(" Camera not available - Showing alert")
                                    // Show SwiftUI alert
                                    showCameraUnavailableAlert = true
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Image("camera")
                                        .resizable()
                                        .frame(width: 40, height: 35)
                                        .foregroundColor(.purple)
                                    Text("Camera")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                            
                            
                            Button(action: {
                                print(" Gallery tapped - Setting sourceType to photoLibrary")
                                sourceType = .photoLibrary
                                print(" sourceType set, closing popup...")
                                withAnimation(.easeInOut) {
                                    showUploadPopup = false
                                }
                                print("Popup closed, waiting 0.3s to open image picker...")
                                // Small delay to allow popup to close before opening image picker
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    print(" Opening gallery with showImagePicker = true")
                                    showImagePicker = true
                                    print(" showImagePicker is now: \(showImagePicker)")
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Image("apple")
                                        .resizable()
                                        .frame(width: 40, height: 35)
                                        .foregroundColor(.purple)
                                    Text("Gallery")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .ignoresSafeArea(edges: .bottom)
                    )
                    .transition(.move(edge: .bottom))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .zIndex(1)
                }
                .zIndex(2)
            }
            
            // MARK: - Image Preview Popup
            if showImagePreview, let image = selectedImage {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        print(" Image preview tapped outside, closing")
                        showImagePreview = false
                        // Don't clear selectedImage here - let onChange handle it if needed
                    }
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Document")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            print(" Image preview close button tapped")
                            showImagePreview = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .font(.title2)
                                .bold()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    
                    // Image Preview
                    ScrollView {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.gray.opacity(0.1))
                    
                    // Upload Button
                    Button(action: {
                        guard let defectItem = selectedDefectItem else { return }
                        setDefectItemUploading(defectItem, isUploading: true)
                        
                        print(" Starting upload for \(defectItem.name) (\(defectItem.type))")
                        viewModel.uploadDefectImage(image: image, defectType: selectedDefectType) { success in
                            if success {
                                print(" Upload successful for \(defectItem.name)")
                                updateDefectItemStatus(defectItem, isUploaded: true)
                                showImagePreview = false
                                selectedImage = nil // Clear image after successful upload
                            } else {
                                print(" Upload failed for \(defectItem.name)")
                                setDefectItemUploading(defectItem, isUploading: false)
                                if let error = viewModel.errorMessage {
                                    print("Error: \(error)")
                                }
                            }
                        }
                    }) {
                        Text(viewModel.isUploading ? "Uploading..." : "Upload")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.isUploading ? Color.gray : Color(UIColor.wine))
                            .cornerRadius(8)
                            .padding()
                    }
                    .disabled(viewModel.isUploading)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.7)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .zIndex(3)
            }
            
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: {
            print("📷 fullScreenCover onDismiss called - showImagePicker is now: \(showImagePicker)")
        }) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
                .ignoresSafeArea()
                .onAppear {
                    print(" fullScreenCover appeared - ImagePicker is visible")
                }
                .onDisappear {
                    print(" fullScreenCover disappeared - ImagePicker closed")
                }
        }
        .onChange(of: selectedImage) { oldValue, newValue in
            print(" selectedImage changed: oldValue=\(oldValue != nil), newValue=\(newValue != nil)")
            if let newImage = newValue, oldValue == nil {
                print(" New image selected, showing preview")
                // Small delay to ensure image picker is fully dismissed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showImagePreview = true
                    print(" Image preview shown")
                }
            }
        }
        .onChange(of: showImagePicker) { oldValue, newValue in
            print(" showImagePicker changed: \(oldValue) -> \(newValue)")
            if newValue {
                print(" Image picker is opening now")
            } else {
                print(" Image picker closed")
                print("   selectedImage exists: \(selectedImage != nil)")
                print("   showImagePreview: \(showImagePreview)")
                // When image picker closes, check if image was selected
                if selectedImage != nil {
                    print(" Image picker dismissed, checking image...")
                    // Fallback: if onChange didn't trigger preview, show it now
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if selectedImage != nil && !showImagePreview {
                            showImagePreview = true
                        }
                    }
                } else {
                    print("No image selected, user cancelled")
                }
            }
        }
        .onAppear {
            // Initialize defect items when view appears
            print("  UploadDefectView appeared")
            
            // Small delay to ensure view is fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.refreshRecordFromDatabase()
                self.defectItems = self.getAllDefectItems()
                print("Defects loaded on appear - Total items: \(self.defectItems.count)")
            }
        }
        .onChange(of: selectedRecord) { newRecord in
            // Reload defects when selected record changes
            print("  Selected record changed")
            if let record = newRecord {
                print("   New record ID: \(record.id ?? -1)")
                print("   Truck Defect: '\(record.truckDefect)'")
                print("   Trailer Defect: '\(record.trailerDefect)'")
            }
            
            // Refresh from database when selectedRecord changes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.refreshRecordFromDatabase()
                self.defectItems = self.getAllDefectItems()
                print(" Defects refreshed after selectedRecord change - Total: \(self.defectItems.count)")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DVIRRecordUpdated"))) { _ in
            // Refresh when DVIR record is updated elsewhere
            print("  DVIR record updated notification received")
            
            // Small delay to ensure database write is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print(" Refreshing record from database after notification...")
                self.refreshRecordFromDatabase()
                self.defectItems = self.getAllDefectItems()
                print(" Defects refreshed - Total items: \(self.defectItems.count)")
            }
        }
        .alert("Camera Not Available", isPresented: $showCameraUnavailableAlert) {
            Button("Use Photo Library", role: .none) {
                // Fallback to photo library
                print("📷 Falling back to photoLibrary")
                sourceType = .photoLibrary
                withAnimation(.easeInOut) {
                    showUploadPopup = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showImagePicker = true
                }
            }
            Button("Cancel", role: .cancel) {
                // Just close the popup
                showUploadPopup = false
            }
        } message: {
            Text("Camera is not available on this device. Would you like to use photo library instead?")
        }
    }
}


#Preview {
    UploadDefectView(selectedRecord: nil)
}*/

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
    var onUpload: (() -> Void)?
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
//        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DVIRRecordUpdated"))) { _ in
//            reloadDefectsFromRecord()
//        }
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
                .foregroundColor(Color(uiColor:.black))
            
            if defects.isEmpty {
                // Check if this defect type is "none" or "no" - if yes, hide upload button
                let shouldShow = shouldShowUploadButtonForDefectType(title: title)
                DefectRowView(defectText: "None", isUploaded: false, showUploadButton: shouldShow, onUpload: {})
            } else {
                ForEach(defects) { defect in
                    if let index = defectItems.firstIndex(where: { $0.id == defect.id }) {
                        // Check if this defect type is "none" or "no" - if yes, hide upload button
                        let shouldShow = shouldShowUploadButtonForDefectType(title: title)
                        DefectRowView(
                            defectText: defect.name,
                            isUploaded: defectItems[index].isUploaded,
                            isUploading: defectItems[index].isUploading,
                            showUploadButton: shouldShow,
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
    
    // Helper function to check if upload button should be shown for a specific defect type
    private func shouldShowUploadButtonForDefectType(title: String) -> Bool {
        let recordToUse = currentRecord ?? selectedRecord
        guard let record = recordToUse else { return true }
        
        let truckDefect = record.truckDefect.trimmingCharacters(in: .whitespaces).lowercased()
        let trailerDefect = record.trailerDefect.trimmingCharacters(in: .whitespaces).lowercased()
        
        // If title is "Truck Defect", check truck defect value
        if title.lowercased().contains("truck") {
            // Hide upload button if truck defect is "none" or "no"
            if truckDefect == "none" || truckDefect == "no" {
                return false
            }
        }
        
        // If title is "Trailer Defect", check trailer defect value
        if title.lowercased().contains("trailer") {
            // Hide upload button if trailer defect is "none" or "no"
            if trailerDefect == "none" || trailerDefect == "no" {
                return false
            }
        }
        
        return true
    }
}

// MARK: - Popups
extension UploadDefectView {
    private var uploadOptionPopup: some View {
        ZStack {
            Color(uiColor:.black).opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { showUploadPopup = false } }
            
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                
                Text("Select Option")
                    .font(.headline)
                    .foregroundColor(Color(uiColor:.black))
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
                    .foregroundColor(Color(uiColor:.black))
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
            
            // Only show upload button if truck defect is not "none" AND trailer defect is not "none"
            if shouldShowUploadButton {
                Button(action: { uploadSelectedImage(image) }) {
                    Text(viewModel.isUploading ? "Uploading..." : "Upload")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(viewModel.isUploading ? Color.gray : Color(UIColor.wine))
                        .cornerRadius(8)
                        .padding()
                }
                .disabled(viewModel.isUploading)
            }
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
    
    // Check if upload button should be shown (hide if truck or trailer defect is "none" or "no")
    private var shouldShowUploadButton: Bool {
        let recordToUse = currentRecord ?? selectedRecord
        guard let record = recordToUse else { return false }
        
        let truckDefect = record.truckDefect.trimmingCharacters(in: .whitespaces).lowercased()
        let trailerDefect = record.trailerDefect.trimmingCharacters(in: .whitespaces).lowercased()
        
        // Hide upload button if truck defect is "none"/"no" OR trailer defect is "none"/"no"
        if truckDefect == "none" || truckDefect == "no" || trailerDefect == "none" || trailerDefect == "no" {
            return false
        }
        
        return true
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















//
//  AddDvirPopupHome.swift
//  NextEld
//
//  Created by priyanshi on 31/10/25.
//
import SwiftUI
import UIKit

// Model for individual defect item
struct DefectItem: Identifiable {
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
        
        // Debug logging
        if let record = selectedRecord {
            print(" Loading defects from record:")
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
                                print("📷 Camera tapped - Setting sourceType to camera")
                                sourceType = .camera
                                print("📷 sourceType set, closing popup...")
                                withAnimation(.easeInOut) {
                                    showUploadPopup = false
                                }
                                print("📷 Popup closed, waiting 0.3s to open image picker...")
                                // Small delay to allow popup to close before opening image picker
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    print("📷 Opening camera with showImagePicker = true")
                                    showImagePicker = true
                                    print("📷 showImagePicker is now: \(showImagePicker)")
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
                                print("🖼️ Gallery tapped - Setting sourceType to photoLibrary")
                                sourceType = .photoLibrary
                                print("🖼️ sourceType set, closing popup...")
                                withAnimation(.easeInOut) {
                                    showUploadPopup = false
                                }
                                print("🖼️ Popup closed, waiting 0.3s to open image picker...")
                                // Small delay to allow popup to close before opening image picker
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    print("🖼️ Opening gallery with showImagePicker = true")
                                    showImagePicker = true
                                    print("🖼️ showImagePicker is now: \(showImagePicker)")
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
                        print("🔄 Image preview tapped outside, closing")
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
                            print("🔄 Image preview close button tapped")
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
                    print("📷 fullScreenCover appeared - ImagePicker is visible")
                }
                .onDisappear {
                    print("📷 fullScreenCover disappeared - ImagePicker closed")
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
            print("🔄 showImagePicker changed: \(oldValue) -> \(newValue)")
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
                            print(" Fallback: Showing image preview")
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
            print(" UploadDefectView appeared")
            defectItems = getAllDefectItems()
            print(" defectItems count: \(defectItems.count)")
        }
        .onChange(of: selectedRecord) { newRecord in
            // Reload defects when selected record changes
            print(" Selected record changed")
            if let record = newRecord {
                print("   New record - Truck: '\(record.truckDefect)', Trailer: '\(record.trailerDefect)'")
            }
            defectItems = getAllDefectItems()
        }
    }
}







// MARK: - Defect Row View (matches image design exactly)
struct DefectRowView: View {
    let defectText: String
    var isUploaded: Bool = false
    var isUploading: Bool = false
    let onUpload: () -> Void
    
    var body: some View {
        HStack {
            Text(defectText)
                .foregroundColor(.gray)
                .font(.subheadline)
                .lineLimit(1)
            Spacer()
            Button(isUploaded ? "Uploaded" : (isUploading ? "Uploading..." : "Upload")) {
                if !isUploaded && !isUploading {
                    onUpload()
                }
            }
            .foregroundColor(isUploaded ? .green : (isUploading ? .gray : .red))
            .font(.subheadline)
            .disabled(isUploaded || isUploading)
        }
        .padding(.vertical, 4)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 10.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    UploadDefectView(selectedRecord: nil)
}

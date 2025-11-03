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
        print("🔍 Parsing defects for \(type): '\(trimmed)'")
        
        if trimmed.isEmpty || trimmed.lowercased() == "no" {
            print("⚠️ No defects found (empty or 'no')")
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
            print("📝 Legacy 'yes' format detected")
        } else if trimmed.contains(",") {
            // Comma-separated defects
            defectNames = trimmed.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.lowercased() != "yes" && $0.lowercased() != "no" }
            print("📝 Comma-separated defects: \(defectNames)")
        } else {
            // Single defect
            defectNames = [trimmed]
            print("📝 Single defect: \(defectNames)")
        }
        
        let items = defectNames.map { DefectItem(name: $0, type: type) }
        print("✅ Created \(items.count) defect items for \(type)")
        return items
    }
    
    // Helper to get all defect items
    private func getAllDefectItems() -> [DefectItem] {
        var items: [DefectItem] = []
        
        // Debug logging
        if let record = selectedRecord {
            print("📋 Loading defects from record:")
            print("   Truck Defect: '\(record.truckDefect)'")
            print("   Trailer Defect: '\(record.trailerDefect)'")
            
            // Add truck defects
            let truckDefects = parseDefects(record.truckDefect, type: "Truck")
            items.append(contentsOf: truckDefects)
            
            // Add trailer defects
            let trailerDefects = parseDefects(record.trailerDefect, type: "Trailer")
            items.append(contentsOf: trailerDefects)
            
            print("📊 Total defect items created: \(items.count)")
            items.forEach { item in
                print("   - [\(item.type)] \(item.name)")
            }
        } else {
            print("⚠️ No selected record found!")
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
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showUploadPopup = false
                        }
                    }
                
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
                            print("Camera tapped")
                            sourceType = .camera
                            showUploadPopup = false
                            showImagePicker = true
                        }) {
                            VStack {
                                Image("camera")
                                    .resizable()
                                    .frame(width: 40, height: 35)
                                    .foregroundColor(.purple)
                                Text("Camera")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        
                        Button(action: {
                            print("Gallery tapped")
                            sourceType = .photoLibrary
                            showUploadPopup = false
                            showImagePicker = true
                        }) {
                            VStack {
                                Image("apple")
                                    .resizable()
                                    .frame(width: 40, height: 35)
                                    .foregroundColor(.purple)
                                Text("Gallery")
                                    .foregroundColor(.gray)
                            }
                        }
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
                .animation(.spring(), value: showUploadPopup)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            // MARK: - Image Preview Popup
            if showImagePreview, let image = selectedImage {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showImagePreview = false
                    }
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Document")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
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
                        
                        viewModel.uploadDefectImage(image: image, defectType: selectedDefectType) { success in
                            if success {
                                updateDefectItemStatus(defectItem, isUploaded: true)
                                showImagePreview = false
                            } else {
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
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if newImage != nil {
                showImagePreview = true
            }
        }
        .onAppear {
            // Initialize defect items when view appears
            print("🔄 UploadDefectView appeared")
            defectItems = getAllDefectItems()
            print("✅ defectItems count: \(defectItems.count)")
        }
        .onChange(of: selectedRecord) { newRecord in
            // Reload defects when selected record changes
            print("🔄 Selected record changed")
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

//
//  ImagePickerController.swift
//  NextEld
//
//  Created by priyanshi on 31/10/25.
//

import Foundation
import SwiftUI
import UIKit



// MARK: - Image Picker Helper
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        // Check if sourceType is available before setting
        let availableSourceType: UIImagePickerController.SourceType
        if sourceType == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                availableSourceType = .camera
            } else {
                print(" Camera not available, falling back to photoLibrary")
                availableSourceType = .photoLibrary
            }
        } else {
            availableSourceType = sourceType
        }
        
        picker.sourceType = availableSourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.modalPresentationStyle = .fullScreen
        print(" ImagePicker created with sourceType: \(availableSourceType == .camera ? "camera" : "photoLibrary")")
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update source type if needed - check availability first
        if uiViewController.sourceType != sourceType {
            let availableSourceType: UIImagePickerController.SourceType
            if sourceType == .camera {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    availableSourceType = .camera
                } else {
                    print(" Camera not available in update, falling back to photoLibrary")
                    availableSourceType = .photoLibrary
                }
            } else {
                availableSourceType = sourceType
            }
            
            if uiViewController.sourceType != availableSourceType {
                print("Updating ImagePicker sourceType from \(uiViewController.sourceType == .camera ? "camera" : "photoLibrary") to \(availableSourceType == .camera ? "camera" : "photoLibrary")")
                uiViewController.sourceType = availableSourceType
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
            print(" ImagePicker Coordinator created")
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print(" ImagePicker: didFinishPickingMediaWithInfo called")
            if let image = info[.originalImage] as? UIImage {
                print(" Image extracted successfully, size: \(image.size)")
                DispatchQueue.main.async {
                    self.parent.selectedImage = image
                    print(" Image assigned to binding, calling dismiss")
                    self.parent.dismiss()
                }
            } else {
                print(" Failed to extract image from picker info")
                DispatchQueue.main.async {
                    self.parent.dismiss()
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print(" ImagePicker cancelled by user")
            DispatchQueue.main.async {
                self.parent.selectedImage = nil
                self.parent.dismiss()
            }
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

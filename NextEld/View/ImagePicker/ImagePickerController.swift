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
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.modalPresentationStyle = .fullScreen
        print("📷 ImagePicker created with sourceType: \(sourceType == .camera ? "camera" : "photoLibrary")")
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update source type if needed
        if uiViewController.sourceType != sourceType {
            print("📷 Updating ImagePicker sourceType from \(uiViewController.sourceType == .camera ? "camera" : "photoLibrary") to \(sourceType == .camera ? "camera" : "photoLibrary")")
            uiViewController.sourceType = sourceType
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
            print("📷 ImagePicker Coordinator created")
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("📷 ImagePicker: didFinishPickingMediaWithInfo called")
            if let image = info[.originalImage] as? UIImage {
                print("📷 Image extracted successfully, size: \(image.size)")
                DispatchQueue.main.async {
                    self.parent.selectedImage = image
                    print("✅ Image assigned to binding, calling dismiss")
                    self.parent.dismiss()
                }
            } else {
                print("⚠️ Failed to extract image from picker info")
                DispatchQueue.main.async {
                    self.parent.dismiss()
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("❌ ImagePicker cancelled by user")
            DispatchQueue.main.async {
                self.parent.selectedImage = nil
                self.parent.dismiss()
            }
        }
    }
}

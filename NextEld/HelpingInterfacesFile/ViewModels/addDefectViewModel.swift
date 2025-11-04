//
//  addDefectViewModel.swift
//  NextEld
//
//  Created by priyanshi on 01/11/25.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
class AddDefectViewModel: ObservableObject {
    @Published var isUploading = false
    @Published var isTruckUploaded = false
    @Published var isTrailerUploaded = false
    @Published var errorMessage: String?
    
    // MARK: - Upload Defect Image
    func uploadDefectImage(image: UIImage, defectType: String, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Failed to convert image to data"
            print("Failed to convert image to data")
            completion(false)
            return
        }
        
        isUploading = true
        errorMessage = nil
        
        let url = API.Endpoint.addDefectData.url
        
        // Convert all values to String as API expects strings
        let requestField: [String: String] = [
            "driverid": "\(AppStorageHandler.shared.driverId ?? 0)",
            "defectType": defectType,
            "clientid": "\(AppStorageHandler.shared.clientId ?? 0)",
            "tokenNo": AppStorageHandler.shared.authToken ?? "",
            "timestamp": "\(Int(Date().timeIntervalSince1970 * 1000))",
            "vehicleid": "\(AppStorageHandler.shared.vehicleId ?? 0)",
            "location": UserDefaults.standard.string(forKey: "customLocation") ?? ""
        ]
        
        print("📤 Defect Upload Fields:")
        requestField.forEach { print("  \($0.key): \($0.value)") }
        
        // Try different file parameter names - API might expect "file" or "defectFile"
        let multipartFile = MultipartFile(
            name: "file",
            filename: "defect_\(defectType.lowercased())_\(Date().timeIntervalSince1970).jpg",
            mimeType: "image/jpeg",
            data: imageData
        )
        
        print(" File attached: \(imageData.count) bytes, name: \(multipartFile.name), filename: \(multipartFile.filename)")
        
        MultipartAPIService.shared.upload(url: url, fields: requestField, files: [multipartFile]) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                
                switch result {
                case .success(let data):
                    print(" Upload successful!")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    
                    // Mark the appropriate defect as uploaded
                    if defectType == "Truck" {
                        self?.isTruckUploaded = true
                    } else if defectType == "Trailer" {
                        self?.isTrailerUploaded = true
                    }
                    
                    completion(true)
                    
                case .failure(let error):
                    // Try to extract more details from the error
                    var errorMsg = error.localizedDescription
                    
                    // If it's an NSError, try to get more info
                    if let nsError = error as NSError? {
                        print(" Upload failed - Error Domain: \(nsError.domain)")
                        print(" Error Code: \(nsError.code)")
                        print(" Error Info: \(nsError.userInfo)")
                        
                        // If we have error data from the server, print it
                        if let errorData = nsError.userInfo[NSLocalizedDescriptionKey] as? String {
                            errorMsg = errorData
                        }
                    }
                    
                    print(" Upload failed: \(errorMsg)")
                    self?.errorMessage = errorMsg
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Reset Upload Status
    func resetUploadStatus() {
        isTruckUploaded = false
        isTrailerUploaded = false
        errorMessage = nil
    }
}

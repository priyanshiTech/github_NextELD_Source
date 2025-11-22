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
    func uploadDefectImage(image: UIImage, defectType: String,defectName: String, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.prepareForUpload(maxFileSize: 800_000, maxDimension: 1400) else {
            errorMessage = "Failed to convert image to data"
            print("Failed to convert image to data")
            completion(false)
            return
        }
        
        isUploading = true
        errorMessage = nil
        
        let url = API.Endpoint.addDefectData.url

        let dvirLogId = AppStorageHandler.shared.dvirLogId ?? ""
        

        
        var requestField: [String: String] = [
            "dvirId": AppStorageHandler.shared.dvirLogId ?? "",  // Use dvirLogId instead of driverId
            "defectName": defectName,
            "defectType": defectType,
            "driverId": "\(AppStorageHandler.shared.driverId ?? 0)",
            "vehicleId": "\(AppStorageHandler.shared.vehicleId ?? 0)",
            "clientId": "\(AppStorageHandler.shared.clientId ?? 0)",
            "dateTime": DateTimeHelper.getCurrentDateTimeString(),
            "utcDateTime": currentTimestampMillis() , // 13-digit timestamp in milliseconds
         
        ]
        
        // Log dvirLogId usage
        if !dvirLogId.isEmpty {
            print(" Using dvirLogId in dvirId field: \(dvirLogId)")
        } else {
            print(" Warning: dvirLogId not available, dvirId will be empty")
        }
        
        print(" Defect Upload Fields:")
        requestField.forEach { print("  \($0.key): \($0.value)") }
        
        // Try different file parameter names - API might expect "file" or "defectFile"
        let multipartFile = MultipartFile(
            name: "file",
            filename: "defect_\(defectName.lowercased())_\(defectType.lowercased())_\(CurrentTimeHelperStamp.currentTimestamp).jpg",
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

// MARK: - UIImage helpers
private extension UIImage {
    func prepareForUpload(maxFileSize: Int, maxDimension: CGFloat) -> Data? {
        var targetImage = self.resized(toMaxDimension: maxDimension)
        var compression: CGFloat = 0.8
        guard var data = targetImage.jpegData(compressionQuality: compression) else { return nil }
        
        while data.count > maxFileSize && compression > 0.2 {
            compression -= 0.1
            if let newData = targetImage.jpegData(compressionQuality: compression) {
                data = newData
            }
        }
        
        while data.count > maxFileSize {
            let newDimension = targetImage.size.maxSide * 0.8
            targetImage = targetImage.resized(toMaxDimension: newDimension)
            if let newData = targetImage.jpegData(compressionQuality: compression) {
                data = newData
            } else {
                break
            }
        }
        
        return data.count <= maxFileSize ? data : nil
    }
    
    func resized(toMaxDimension maxDimension: CGFloat) -> UIImage {
        let longestSide = size.maxSide
        guard longestSide > maxDimension else { return self }
        
        let scale = maxDimension / longestSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

private extension CGSize {
    var maxSide: CGFloat { max(width, height) }
}

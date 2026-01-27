//
//  DVIRViewModelUpload.swift
//  NextEld
//
//  Created by Priyanshi   on 31/07/25.
//

import Foundation
import SwiftUI

//// Helper function to get current timestamp in milliseconds
//func currentTimestampMillis() -> Int64 {
//    return Int64(Date().timeIntervalSince1970 * 1000)
//}

func uploadDvirDataUsingCommonService(record: DvirRecordRequestModel, appRootManager: AppRootManager?, completion: @escaping (Bool) ->Void) {
    let url = API.Endpoint.dispatchadd_dvir_data.url

    // Convert truckDefect string to array format expected by API
    let truckDefectArray: [String]
    if record.truckDefect.lowercased() == "no" {
        truckDefectArray = []
    } else if record.truckDefect.lowercased() == "yes" {
        // If yes, we need to get actual defect names - for now send empty or placeholder
        // TODO: Get actual selected defect names from defect selection
        truckDefectArray = [] // Empty for now, should be populated with actual defect names
    } else {
        // If it's already a comma-separated string or single defect name
        truckDefectArray = record.truckDefect.isEmpty ? [] : [record.truckDefect]
    }
    
    // Convert trailerDefect string to array format
    let trailerDefectArray: [String]
    if record.trailerDefect.lowercased() == "no" {
        trailerDefectArray = []
    } else if record.trailerDefect.lowercased() == "yes" {
        // If yes, we need to get actual defect names
        trailerDefectArray = [] // Empty for now, should be populated with actual defect names
    } else {
        trailerDefectArray = record.trailerDefect.isEmpty ? [] : [record.trailerDefect]
    }
    
    // Convert trailer string to array format
    let trailerArray: [String]
    if record.trailer.isEmpty {
        trailerArray = []
    } else {
        // Split by comma if multiple trailers, otherwise single item array
        trailerArray = record.trailer.contains(",") ? record.trailer.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) } : [record.trailer]
    }

    // Convert vehicleId to Int if it's a string
    let vehicleIdInt: Int
    if let vehicleIdString = record.vehicleId as? String, !vehicleIdString.isEmpty {
        vehicleIdInt = Int(vehicleIdString) ?? 0
    } else if let vehicleIdIntValue = record.vehicleId as? Int {
        vehicleIdInt = vehicleIdIntValue
    } else {
        vehicleIdInt = Int(record.vehicleId) ?? 0
    }
    
    // Ensure all numeric fields are proper types
    let odometerValue = Double(record.odometer) ?? 0.0
    let engineHourValue = record.engineHour
    
    let fields: [String: Any] = [
        "driverId": (AppStorageHandler.shared.driverId ?? 17),
        "vehicleId": vehicleIdInt,  // Ensure it's Int, not String
        "clientId": (AppStorageHandler.shared.clientId ?? 0),
        "timestamp": record.timestampDvir, // Milliseconds timestamp as string
        "dateTime": record.dateTime,  // Keep as string
        "location": record.locationDvir.isEmpty ? "N/A" : record.locationDvir,
        "truckDefect": truckDefectArray.isEmpty ? [] : truckDefectArray,      // Array
        "trailerDefect": trailerDefectArray.isEmpty ? [] : trailerDefectArray, // Array
        "notes": record.notes.isEmpty ? "" : record.notes,
        "vehicleCondition": record.vehicleCondition.isEmpty ? "None" : record.vehicleCondition,
        "companyName": record.companyName.isEmpty ? "" : record.companyName,
        "odometer": odometerValue,  // Send as Double, not String
        "engineHour": "\(engineHourValue)",  // Keep as string
        "tokenNo": AppStorageHandler.shared.authToken ?? "",
        "trailer": trailerArray.isEmpty ? [] : trailerArray  // Array
    ]

    // print(" ========== API REQUEST FIELDS ==========")
    // print(" Request Fields:")
    for (key, value) in fields {
        if let arrayValue = value as? [String] {
            // print("   \(key): [\(arrayValue.joined(separator: ", "))]")
        } else {
            // print("   \(key): \(value) (type: \(type(of: value)))")
        }
    }
    // print("======================================")

    var files: [MultipartFile] = []
    
    // Check if signature data exists
    if let signatureData = record.fileDVir {
        // print(" Signature data found: \(signatureData.count) bytes")
        
        if let image = UIImage(data: signatureData) {
            // print(" Signature image created successfully")
            // print(" Image size: \(image.size.width)x\(image.size.height)")
            
            // Check if image is blank (all white/transparent)
            // Create a new image with black signature on white background to ensure visibility
            let renderer = UIGraphicsImageRenderer(size: image.size)
            let processedImage = renderer.image { context in
                // Fill with white background
                UIColor.white.setFill()
                context.fill(CGRect(origin: .zero, size: image.size))
                
                // Draw the original image (signature should be in black/dark color)
                image.draw(at: .zero)
            }
            
            // print(" Processed signature image (white background ensured)")
            
            // Convert to JPEG with high quality to preserve signature details
            if let jpegData = processedImage.jpegData(compressionQuality: 1.0) {
                // print(" Signature JPEG data created: \(jpegData.count) bytes")
                
                // Verify the image is not blank by checking if it has non-white pixels
                if let cgImage = processedImage.cgImage {
                    let width = cgImage.width
                    let height = cgImage.height
                    let colorSpace = CGColorSpaceCreateDeviceRGB()
                    let bytesPerPixel = 4
                    let bytesPerRow = bytesPerPixel * width
                    let bitsPerComponent = 8
                    var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
                    
                    let context = CGContext(data: &pixelData,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
                    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
                    
                    // Check if there are any non-white pixels (signature exists)
                    var hasNonWhitePixels = false
                    for i in stride(from: 0, to: pixelData.count, by: 4) {
                        let r = pixelData[i]
                        let g = pixelData[i + 1]
                        let b = pixelData[i + 2]
                        // If not white (255, 255, 255), signature exists
                        if r < 250 || g < 250 || b < 250 {
                            hasNonWhitePixels = true
                            break
                        }
                    }
                    
                    if hasNonWhitePixels {
                        // print(" Signature verified: Contains non-white pixels (signature exists)")
                    } else {
                        // print(" WARNING: Signature image appears to be blank (all white pixels)")
                    }
                }
                
                let driverId = AppStorageHandler.shared.driverId ?? 0
                let filename = "\(driverId)_sign_1.jpg"
                
                // print("   - filename: \(filename)")
            
                
                // Use "file" as field name (same as defect images, server will map it to driverSignFile)
                files.append(MultipartFile(
                    name: "file",
                    filename: filename,
                    mimeType: "image/jpeg",
                    data: jpegData
                ))
                
                // print(" Signature file added to multipart request")
            } else {
                // print(" Failed to convert signature image to JPEG data")
            }
        } else {
            // print(" Failed to create UIImage from signature data")
        }
    } else {
        // print(" No signature data found in record.fileDVir")
    }

    // print("  API Call: dispatchadd_dvir_data")
    // print("  URL: \(url)")
    // print("  Request Fields Count: \(fields.count)")
    // print("  Files Count: \(files.count)")
    
    MultipartAPIService.shared.upload(url: url, fields: fields, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                // print(" ========== dispatchadd_dvir_data API - Upload successful! ==========")
                if let responseString = String(data: data, encoding: .utf8) {
                    // print(" Full Response Body:")
                    // print(" \(responseString)")
                    
                    // Parse response to extract _id and verify all data
                    if let jsonData = responseString.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                        if let tokenValue = (json["token"] as? String)?.lowercased(), tokenValue == "false" {
                            
                            // print(" Session expired detected during DVIR upload")
                            // print(" appRootManager is \(appRootManager != nil ? "set" : "nil")")
                            appRootManager?.currentRoot = .SessionExpireUIView
                            return
                        }
                        
                        // print(" Response Status: \(json["status"] ?? "nil")")
                        // print(" Response Message: \(json["message"] ?? "nil")")
                        
                        if let resultDict = json["result"] as? [String: Any] {
                            // print(" Result object found in response")
                            
                            completion(true)
                            // Extract and save _id
                            if let dvirId = resultDict["_id"] as? String {
                                AppStorageHandler.shared.dvirLogId = dvirId
                                // print(" Saved dvirLogId: \(dvirId)")
                            } else {
                                // print(" Could not extract _id from response")
                            }
                
                            // Check if signature file was saved
                            if let driverSignFile = resultDict["driverSignFile"] as? String, !driverSignFile.isEmpty {
                                // print(" Signature file saved on server: \(driverSignFile)")
                            } else {
                                // print(" Warning: driverSignFile is empty or nil on server")
                            }
                   
                        } else {
                            // print(" Result object not found in response")
                            // print(" Response structure: \(json)")
                        }
                    } else {
                        // print(" Could not parse response JSON")
                    }
                } else {
                    // print(" Response: (Unable to decode)")
                }
                // print(" =================================================")
            case .failure(let error):
                completion(false)
                // print("  dispatchadd_dvir_data API - Upload failed: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    // print("  Error Code: \(nsError.code)")
                    // print("  Error Domain: \(nsError.domain)")
                }
            }
        }
    }
}


struct DvirRecordRequestModel {
    var driverId: Int
    var dateTime: String
    var locationDvir: String
    var truckDefect: String
    var trailerDefect: String
    var notes: String
    var vehicleCondition: String
    var companyName: String
    var odometer: Double
    var engineHour: Int
    var vehicleId: String
    var timestampDvir: String
    var tokenNo: String
    var clientId: Int
    var trailer: String
    var fileDVir: Data?   // signature/file data
}

















/*func uploadDvirDataUsingCommonService(record: DvirRecord) {
    let url = API.Endpoint.dispatchadd_dvir_data.url
   

    
    
    let rawFields: [String: Any] = [
        "driverId": AppStorageHandler.shared.driverId ?? 0,
        "dateTime": "\(record.date) \(record.time)",
        "location": "390, scheme No 53, Indore,Madhya Pradesh 452011, India",
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "companyName": record.company,
        "odometer": Double(record.odometer) ?? 0.0,
        "enginehour": record.engineHour,
        "vehicleid": AppStorageHandler.shared.vehicleId ?? 0,
        "timestamp": currentTimestampMillis(),
        "tokenNo": AppStorageHandler.shared.authToken,
        "clientid": AppStorageHandler.shared.clientId ?? 0,
        "trailer": record.trailer
    ]



    // Convert all values to String
    let requestField: [String: String] = rawFields.mapValues { "\($0)" }

    
    // print("Request sending for Multipart",  requestField)
    
    var files: [MultipartFile] = []
    if let signatureData = record.signature,
       let image = UIImage(data: signatureData),
       let jpegData = image.jpegData(compressionQuality: 0.8) {
        
        let filename = "\(AppStorageHandler.shared.driverId)_sign_1.jpg"
        files.append(MultipartFile(
            name: "file",
            filename: filename,
            mimeType: "image/jpeg",
            data: jpegData
        ))
    }
    
    // print("Request Fields: \(requestField)")
    
    MultipartAPIService.shared.upload(url: url, fields: requestField, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                // print(" Upload successful!")
                // print("Response: \(String(data: data, encoding: .utf8) ?? "None")")
            case .failure(let error):
                // print(" Upload failed: \(error.localizedDescription)")
            }
        }
    }
}*/

























//
//
//func uploadDvirDataUsingCommonService(record: DvirRecord) {
//    let url = API.Endpoint.dispatchadd_dvir_data.url
//    
//    // Make sure driverID is not nil
//    let driverIdString = "\(AppStorageHandler.shared.driverId ?? 0)"
//    
//    let requestField: [String: String] = [
//        "driverid": driverIdString,
//        "datetime": "2025-09-06 03:49:57",   // match exactly
//        "location": record.location,
//        "truckDefect": record.truckDefect,
//        "trailerDefect": record.trailerDefect,
//        "notes": record.notes,
//        "vehicleCondition": record.vehicleCondition,
//        "companyName" : record.company,
//        "odometer" : record.odometer,
//        "engineHour" : "\(record.engineHour)",
//        "vehicleid" : "\(record.vehicleID)",
//        "timestamp" : "\(currentTimestampMillis())",
//        "tokenNo" : AppStorageHandler.shared.authToken,
//        "clientid" : "\(AppStorageHandler.shared.clientId)",
//        "trailer" : record.trailer
//    ]
//
//    
//    var files: [MultipartFile] = []
//    
//
//
//    if let signatureData = record.signature, let image = UIImage(data: signatureData) {
//        let jpegData = image.jpegData(compressionQuality: 0.8)
//        let filename = "\(driverIdString)_sign_1.jpg"
//        files.append(MultipartFile(
//            name: "file",
//            filename: filename,
//            mimeType: "image/jpeg",
//            data: jpegData ?? signatureData
//        ))
//    }
//
//    
//    MultipartAPIService.shared.upload(url: url, fields: requestField, files: files) { result in
//        DispatchQueue.main.async {
//            switch result {
//            case .success(let data):
//                // print("Upload successful!")
//                // print("Response: \(String(data: data, encoding: .utf8) ?? "None")")
//                
//            case .failure(let error):
//                // print("Upload failed: \(error.localizedDescription)")
//            }
//        }
//    }
//}



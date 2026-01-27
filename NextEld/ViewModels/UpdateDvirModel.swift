//
//  UpdateDvirModel.swift
//  NextEld
//
//  Created by Priyanshi   on 04/08/25.
//

import Foundation

func updateDvirDataUsingCommonService(record: DvirRecordRequestModel, dvirLogId: String, appRootManager: AppRootManager?, completion: @escaping (Bool) -> Void) {
    let url = API.Endpoint.update_dvir_data.url
    
    let truckDefectArray: String
    if record.truckDefect.lowercased() == "no" {
        truckDefectArray = "None"
    } else if record.truckDefect.lowercased() == "yes" {
        // If yes, we need to get actual defect names - for now send empty or placeholder
        // TODO: Get actual selected defect names from defect selection
        truckDefectArray = "None" // Empty for now, should be populated with actual defect names
    } else {
        // If it's already a comma-separated string or single defect name
        truckDefectArray = record.truckDefect.isEmpty ? "None" : record.truckDefect
    }
    
    // Convert trailerDefect string to array format
    let trailerDefectArray: String
    if record.trailerDefect.lowercased() == "no" {
        trailerDefectArray = "None"
    } else if record.trailerDefect.lowercased() == "yes" {
        // If yes, we need to get actual defect names
        trailerDefectArray = "None" // Empty for now, should be populated with actual defect names
    } else {
        trailerDefectArray = record.trailerDefect.isEmpty ? "None" : record.trailerDefect
    }
    
    // Convert trailer string to array format
    let trailerArray: String
    if record.trailer.isEmpty {
        trailerArray = "None"
    } else {
        // Split by comma if multiple trailers, otherwise single item array
        trailerArray = record.trailer
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
    
    // Ensure all numeric fields are proper type
    
    let requestField: [String: Any] = [
        "driverId": (AppStorageHandler.shared.driverId ?? 17),
        "vehicleId": vehicleIdInt,  // Ensure it's Int, not String
        "clientId": (AppStorageHandler.shared.clientId ?? 0),
        "timestamp": record.timestampDvir, // Milliseconds timestamp as string
        "dateTime": record.dateTime,  // Keep as string
        "truckDefect": truckDefectArray,      // Array
        "trailerDefect": trailerDefectArray, // Array
        "notes": record.notes.isEmpty ? "" : record.notes,
        "vehicleCondition": record.vehicleCondition.isEmpty ? "None" : record.vehicleCondition,
        "tokenNo": AppStorageHandler.shared.authToken ?? "",
        "trailer": trailerArray  // Array
    ]
    
    var files: [MultipartFile] = []
    if let signatureData = record.fileDVir {
        let driverId = AppStorageHandler.shared.driverId ?? 0
        let filename = "\(driverId)_sign_1.jpg"
        
        // print(" Creating multipart file:")
        // print("   - name: file")
        // print("   - filename: \(filename)")
        // print("   - mimeType: image/jpeg")
        // print("   - data size: \(jpegData.count) bytes")
        
        // Use "file" as field name (same as defect images, server will map it to driverSignFile)
        files.append(MultipartFile(
            name: "file",
            filename: filename,
            mimeType: "image/jpeg",
            data: signatureData
        ))
    }
    
    
    // print(" DVIR Upload Fields:")
   // requestField.forEach { // print(" \($0.key): \($0.value)") }
        
        
//        if let signatureData = record.signature {
//            files.append(MultipartFile(
//                name: "trailerFile",
//                filename: "trailer_attachment.png",
//                mimeType: "image/png",
//                data: signatureData
//            ))
//            // print("Trailer file attached: \(signatureData.count) bytes")
//        }
        
        
        
        // print(" API Call: update_dvir_data")
        // print("  URL: \(url)")
        // print(" Request Fields Count: \(requestField.count)")
        
        MultipartAPIService.shared.upload(url: url, fields: requestField, files: files) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // print("  update_dvir_data API - Upload successful!")
                    if let responseString = String(data: data, encoding: .utf8) {
                        // print("  Response: \(responseString)")
                        if let jsonData = responseString.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                           let tokenValue = (json["token"] as? String)?.lowercased(), tokenValue == "false" {
                            
                            // print(" Session expired detected during DVIR update")
                            // print(" appRootManager is \(appRootManager != nil ? "set" : "nil")")
                            appRootManager?.currentRoot = .SessionExpireUIView
                            return
                        } else {
                            completion(true)
                        }
                    } else {
                        // print("  Response: (Unable to decode)")
                    }
                case .failure(let error):
                    completion(false)
                    // print("  update_dvir_data API - Upload failed: \(error.localizedDescription)")
                    if let nsError = error as NSError? {
                        // print("  Error Code: \(nsError.code)")
                        // print(" Error Domain: \(nsError.domain)")
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



/*func updateDvirDataUsingCommonService(record: DvirRecord, dvirLogId: String) {
//    guard let url = URL(string: "https://gbt-usa.com/eld_log/dispatch/update_dvir_data") else {
//        // print(" Invalid URL")
//        return
//    }
    let url =  API.Endpoint.update_dvir_data.url

    let requestField: [String: String] = [
        "driverid": "\(AppStorageHandler.shared.driverId ?? 0)",
        "dateTime": "\(record.date) \(record.time)",
        "location": "390, scheme No 53, Indore,Madhya Pradesh 452011, India",
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "companyName": record.company,
        "odometer":  "\(0)",
        "enginehour": "\(record.engineHour)",
        "vehicleid":   "\(record.vehicleID)",
        "timestamp": "\(currentTimestampMillis())",
        "tokenNo":    AppStorageHandler.shared.authToken,
        "clientid":  "\(AppStorageHandler.shared.clientId ?? 0)"   ,
        "trailer": record.trailer
    ]

    // print("📤 Fields to upload:")
    requestField.forEach { // print(" \($0.key): \($0.value)") }

    var files: [MultipartFile] = []

    if let signature = record.signature {
        files.append(MultipartFile(
            name: "file",
            filename: "signature.png",
            mimeType: "image/png",
            data: signature
        ))
        // print("📎 Signature attached: \(signature.count) bytes")
    }

    MultipartAPIService.shared.upload(url: url, fields: requestField, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                // print(" Upload success")
                // print(" Response: \(String(data: data, encoding: .utf8) ?? "None")")

            case .failure(let error):
                // print(" Upload failed: \(error.localizedDescription)")
            }
        }
    }
}*/

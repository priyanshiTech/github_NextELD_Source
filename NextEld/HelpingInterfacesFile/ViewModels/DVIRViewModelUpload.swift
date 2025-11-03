//
//  DVIRViewModelUpload.swift
//  NextEld
//
//  Created by Priyanshi   on 31/07/25.
//

import Foundation
import SwiftUI

// Helper function to get current timestamp in milliseconds
func currentTimestampMillis() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

func uploadDvirDataUsingCommonService(record: DvirRecordRequestModel) {
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

    let fields: [String: Any] = [
        "driverId": (AppStorageHandler.shared.driverId ?? 17),
        "vehicleId": record.vehicleId,
        "clientId": (AppStorageHandler.shared.clientId ?? 0),
        "timestamp": "\(currentTimestampMillis())", // Milliseconds timestamp as string
        "dateTime":  "\(record.dateTime)",
        "location": record.locationDvir,
        "truckDefect": truckDefectArray,      // Now sending as array
        "trailerDefect": trailerDefectArray, // Now sending as array
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "companyName": record.companyName,
        "odometer": "\(Double(record.odometer) ?? 0.0)",
        "engineHour": "\(record.engineHour)",
        "tokenNo": AppStorageHandler.shared.authToken ?? "",
        "trailer": trailerArray               // Now sending as array
    ]

    print("this our Request model \(fields)")

    var files: [MultipartFile] = []
    if let signatureData = record.fileDVir,
       let image = UIImage(data: signatureData),
       let jpegData = image.jpegData(compressionQuality: 0.8) {
        
        let filename = "\(AppStorageHandler.shared.driverId ?? 0)_sign_1.jpg"
        files.append(MultipartFile(
            name: "file",
            filename: filename,
            mimeType: "image/jpeg",
            data: jpegData
        ))
    }

    print("  API Call: dispatchadd_dvir_data")
    print("  URL: \(url)")
    print("  Request Fields Count: \(fields.count)")
    print("  Files Count: \(files.count)")
    
    MultipartAPIService.shared.upload(url: url, fields: fields, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                print("  dispatchadd_dvir_data API - Upload successful!")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("  Response: \(responseString)")
                } else {
                    print(" Response: (Unable to decode)")
                }
            case .failure(let error):
                print("  dispatchadd_dvir_data API - Upload failed: \(error.localizedDescription)")
                if let nsError = error as NSError? {
                    print("  Error Code: \(nsError.code)")
                    print("  Error Domain: \(nsError.domain)")
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

    
    print("Request sending for Multipart",  requestField)
    
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
    
    print("Request Fields: \(requestField)")
    
    MultipartAPIService.shared.upload(url: url, fields: requestField, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                print(" Upload successful!")
                print("Response: \(String(data: data, encoding: .utf8) ?? "None")")
            case .failure(let error):
                print(" Upload failed: \(error.localizedDescription)")
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
//                print("Upload successful!")
//                print("Response: \(String(data: data, encoding: .utf8) ?? "None")")
//                
//            case .failure(let error):
//                print("Upload failed: \(error.localizedDescription)")
//            }
//        }
//    }
//}



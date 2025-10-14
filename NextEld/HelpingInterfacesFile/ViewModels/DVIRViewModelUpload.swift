//
//  DVIRViewModelUpload.swift
//  NextEld
//
//  Created by Priyanshi   on 31/07/25.
//

import Foundation
import SwiftUI


func uploadDvirDataUsingCommonService(record: DvirRecordRequestModel) {
    let url = API.Endpoint.dispatchadd_dvir_data.url

    let fields: [String: Any] = [
        "driverId": (DriverInfo.driverId ?? 17),
        "vehicleId": record.vehicleId,          //  vehicleId not vehicleid
        "clientId": (DriverInfo.clientId ?? 0),
        "timestamp": "\(currentTimestampMillis())",
        "dateTime":  "\(record.dateTime)",
        "location": record.locationDvir,
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "companyName": record.companyName,
        "odometer": "\(Double(record.odometer) ?? 0.0)",   //  send as numeric string
        "engineHour": "\(record.engineHour)",              //  engineHour not enginehour
        "tokenNo": DriverInfo.authToken,
        "trailer": record.trailer
    ]

    print("this our Request model \(fields)")

    var files: [MultipartFile] = []
    if let signatureData = record.fileDVir,
       let image = UIImage(data: signatureData),
       let jpegData = image.jpegData(compressionQuality: 0.8) {
        
        let filename = "\(DriverInfo.driverId ?? 0)_sign_1.jpg"
        files.append(MultipartFile(
            name: "file",
            filename: filename,
            mimeType: "image/jpeg",
            data: jpegData
        ))
    }

    MultipartAPIService.shared.upload(url: url, fields: fields, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                print(" Upload successful")
                print("Response:", String(data: data, encoding: .utf8) ?? "No response")
            case .failure(let error):
                print(" Upload failed:", error.localizedDescription)
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
        "driverId": DriverInfo.driverId ?? 0,
        "dateTime": "\(record.date) \(record.time)",
        "location": "390, scheme No 53, Indore,Madhya Pradesh 452011, India",
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "companyName": record.company,
        "odometer": Double(record.odometer) ?? 0.0,
        "enginehour": record.engineHour,
        "vehicleid": DriverInfo.vehicleId ?? 0,
        "timestamp": currentTimestampMillis(),
        "tokenNo": DriverInfo.authToken,
        "clientid": DriverInfo.clientId ?? 0,
        "trailer": record.trailer
    ]



    // Convert all values to String
    let requestField: [String: String] = rawFields.mapValues { "\($0)" }

    
    print("Request sending for Multipart",  requestField)
    
    var files: [MultipartFile] = []
    if let signatureData = record.signature,
       let image = UIImage(data: signatureData),
       let jpegData = image.jpegData(compressionQuality: 0.8) {
        
        let filename = "\(DriverInfo.driverId)_sign_1.jpg"
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
//    let driverIdString = "\(DriverInfo.driverId ?? 0)"
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
//        "tokenNo" : DriverInfo.authToken,
//        "clientid" : "\(DriverInfo.clientId)",
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



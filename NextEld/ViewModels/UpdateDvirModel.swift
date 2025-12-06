//
//  UpdateDvirModel.swift
//  NextEld
//
//  Created by Priyanshi   on 04/08/25.
//

import Foundation

func updateDvirDataUsingCommonService(record: DvirRecord, dvirLogId: String, appRootManager: AppRootManager?) {
    let url = API.Endpoint.update_dvir_data.url
    
    let requestField: [String: String] = [
        "driverid": record.UserID,
        "dvirLogId": dvirLogId,
        "dateTime": "\(record.DAY) \(record.DvirTime)",
        "location": record.location,
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "companyName": record.UserName,
        "odometer": "\(record.odometer ?? 0.0)",
        "enginehour": "0",
        "vehicleid": record.vechicleID,
        "vehicleName": record.vehicleName,
        "shift": "\(AppStorageHandler.shared.shift ?? 1)",
        "timestamp": record.timestamp,
        "tokenNo": AppStorageHandler.shared.authToken ?? "",
        "clientid": "\(AppStorageHandler.shared.clientId ?? 0)",
        "sync": "\(record.Sync)",
        "server_id": record.Server_ID
    ]
    
    // print(" DVIR Upload Fields:")
   // requestField.forEach { // print(" \($0.key): \($0.value)") }
        
        var files: [MultipartFile] = []
        if let signatureData = record.signature {
            files.append(MultipartFile(
                name: "trailerFile",
                filename: "trailer_attachment.png",
                mimeType: "image/png",
                data: signatureData
            ))
            // print("Trailer file attached: \(signatureData.count) bytes")
        }
        
        
        
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
                            SessionManagerClass.shared.clearToken()
                            // print(" Session expired detected during DVIR update")
                            // print(" appRootManager is \(appRootManager != nil ? "set" : "nil")")
                            appRootManager?.currentRoot = .SessionExpireUIView
                            return
                        }
                    } else {
                        // print("  Response: (Unable to decode)")
                    }
                case .failure(let error):
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

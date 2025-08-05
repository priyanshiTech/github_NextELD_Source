//
//  DVIRViewModelUpload.swift
//  NextEld
//
//  Created by Priyanshi   on 31/07/25.
//

import Foundation
import SwiftUI



func uploadDvirDataUsingCommonService(record: DvirRecord) {
    
    let url = API.Endpoint.dispatchadd_dvir_data.url //  FIXED
    
    let fields: [String: String] = [
        "driverId": "10",
        "dateTime": "\(record.date) \(record.time)",
        "location": record.location,
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition
    ]

    var files: [MultipartFile] = []

    if let signature = record.signature {
        files.append(MultipartFile(
            name: "file",
            filename: "signature.png",
            mimeType: "image/png",
            data: signature
        ))
    }

    MultipartAPIService.shared.upload(url: url, fields: fields, files: files) { result in
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
}

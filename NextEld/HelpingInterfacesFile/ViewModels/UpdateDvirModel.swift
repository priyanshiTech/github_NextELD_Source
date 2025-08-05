//
//  UpdateDvirModel.swift
//  NextEld
//
//  Created by Priyanshi   on 04/08/25.
//

import Foundation
//func updateDvirDataUsingCommonService(record: DvirRecord, dvirLogId: String) {
//   // let url = API.Endpoint.update_dvir_data.url  // Make sure this is correctly defined
//    
//    guard let url = URL(string: "https://gbt-usa.com/eld_log/dispatch/update_dvir_data") else {
//        print(" Invalid URL")
//        return
//    }
//
//    let fields: [String: String] = [
//        "driverId": "12", // or dynamic if needed
//        "dateTime": "\(record.date) \(record.time)",
//        "location": record.location,
//        "truckDefect": record.truckDefect,
//        "trailerDefect": record.trailerDefect,
//        "notes": record.notes,
//        "vehicleCondition": record.vehicleCondition,
//        "dvirLogId": dvirLogId,
//        "companyName": record.company,
//        "odometer": record.odometer
//    ]
//
//    var files: [MultipartFile] = []
//    if let signature = record.signature {
//        files.append(MultipartFile(
//            name: "file",
//            filename: "signature.png",
//            mimeType: "image/png",
//            data: signature
//        ))
//    }
//
//    MultipartAPIService.shared.upload(url: url, fields: fields, files: files) { result in
//        DispatchQueue.main.async {
//            switch result {
//            case .success(let data):
//                do {
//                    let response = try JSONDecoder().decode(UpdateDVIRModel.self, from: data)
//                    print(" Update Success: \(response.message ?? "No message")")
//                } catch {
//                    print(" Decoding failed: \(error.localizedDescription)")
//                }
//
//            case .failure(let error):
//                print(" Upload failed: \(error.localizedDescription)")
//            }
//        }
//    }
//}
func updateDvirDataUsingCommonService(record: DvirRecord, dvirLogId: String) {
//    guard let url = URL(string: "https://gbt-usa.com/eld_log/dispatch/update_dvir_data") else {
//        print("❌ Invalid URL")
//        return
//    }
    let url =  API.Endpoint.update_dvir_data.url
    let odometer = record.odometer.isEmpty ? "0" : record.odometer

    let fields: [String: String] = [
        "driverId": "12",
        "dateTime": "\(record.date) \(record.time)",
        "location": record.location,
        "truckDefect": record.truckDefect,
        "trailerDefect": record.trailerDefect,
        "notes": record.notes,
        "vehicleCondition": record.vehicleCondition,
        "dvirLogId": dvirLogId,
        "companyName": record.company.isEmpty ? "N/A" : record.company,
        "odometer": odometer
    ]


    print("📤 Fields to upload:")
    fields.forEach { print("🔹 \($0.key): \($0.value)") }

    var files: [MultipartFile] = []

    if let signature = record.signature {
        files.append(MultipartFile(
            name: "file",
            filename: "signature.png",
            mimeType: "image/png",
            data: signature
        ))
        print("📎 Signature attached: \(signature.count) bytes")
    }

    MultipartAPIService.shared.upload(url: url, fields: fields, files: files) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                print(" Upload success")
                print(" Response: \(String(data: data, encoding: .utf8) ?? "None")")

            case .failure(let error):
                print("❌ Upload failed: \(error.localizedDescription)")
            }
        }
    }
}

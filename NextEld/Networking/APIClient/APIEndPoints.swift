//
//  APIEndPoints.swift
//  NextEld
//
//  Created by priyanshi on 18/06/25.
//
import Foundation
import SwiftUI
import Foundation


enum API {
    static let baseURL = URL(string: "https://gbt-usa.com/eld_log/")!

    enum Endpoint {
        case login
        case ForgetPassword
        case ForgetUserName
        case ForSavingOfflineData
        case getAllDatadelete

        var url: URL {
            switch self {
            case .login:
                return API.baseURL.appendingPathComponent("auth/login")
            case . ForgetPassword:
                return API.baseURL.appendingPathComponent("auth/forgot_password")
            case .ForgetUserName:
                return API.baseURL.appendingPathComponent("auth/forgot_username")
            case .ForSavingOfflineData:
                return API.baseURL.appendingPathComponent("dispatch/add_drivering_status_offline")
            case .getAllDatadelete:
                return API.baseURL.appendingPathComponent("dispatch/delete_all_driver_status_by_id")
            }
        }

        var method: String {
            switch self {
            case .login, .ForgetPassword , .ForgetUserName:
                return "POST"
            case .ForSavingOfflineData , .getAllDatadelete:
                return "POST"
            
            }
        }
    }
}


//MARK: -

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func post<T: Decodable, U: Encodable>(_ endpoint: API.Endpoint, body: U) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encodedBody = try JSONEncoder().encode(body)
        request.httpBody = encodedBody

        print("🌍 URL: \(endpoint.url)")
        print("📝 Method: \(endpoint.method)")
        print("📤 Content-Type: application/json")
        if let bodyString = String(data: encodedBody, encoding: .utf8) {
            print("📤 JSON Body: \(bodyString)")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status Code: \(httpResponse.statusCode)")
        }

        if let string = String(data: data, encoding: .utf8) {
            print("📥 Response Body: \(string)")
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

}

//MARK: - call MultipartAPI

import Foundation
import UIKit

class DvirAPIService {
    static let shared = DvirAPIService()

    
    func uploadDvirRecord(record: DvirRecord, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://gbt-usa.com/eld_log/dispatch/add_dvir_data")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = createMultipartBody(record: record, boundary: boundary)
        request.httpBody = httpBody

        print(" Starting API Upload...")
        
        URLSession.shared.uploadTask(with: request, from: httpBody) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status Code: \(httpResponse.statusCode)")
            }

            if let data = data {
                let responseString = String(data: data, encoding: .utf8) ?? "No readable response"
                print("📨 Response Data: \(responseString)")
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server error", code: 0)))
                return
            }

            //print(" Upload Success!")
            completion(.success(true))
        }.resume()
    }

    private func createMultipartBody(record: DvirRecord, boundary: String) -> Data {
        var body = Data()

        func appendField(_ name: String, value: String) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        appendField("driverId", value: "10")
    appendField("dateTime", value: "\(record.date) \(record.time)")
       // appendField("datetime", value: record.datetime)
        appendField("location", value: record.location)
        appendField("truckDefect", value: record.truckDefect)
        appendField("trailerDefect", value: record.trailerDefect)
        appendField("notes", value: record.notes)
        appendField("vehicleCondition", value: record.vehicleCondition)

        if let signature = record.signature {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"signature.png\"\r\n")
            body.append("Content-Type: image/png\r\n\r\n")
            body.append(signature)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


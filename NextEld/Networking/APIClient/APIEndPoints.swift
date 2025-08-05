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
        case dispatchadd_dvir_data
        case update_dvir_data
        case getRefershAlldata

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
            case .dispatchadd_dvir_data:
                return API.baseURL.appendingPathComponent("dispatch/add_dvir_data")
            case .update_dvir_data:
                return API.baseURL.appending(components: "dispatch/update_dvir_data")
            case .getRefershAlldata:
                return API.baseURL.appendingPathComponent("auth/login_data_by_employee_id")

            }
        }

        var method: String {
            switch self {
            case .login, .ForgetPassword , .ForgetUserName ,  .update_dvir_data:
                return "POST"
            case .ForSavingOfflineData , .getAllDatadelete , .dispatchadd_dvir_data , .getRefershAlldata:
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
            print("**************** JSON Body: \(bodyString)")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        

        if let httpResponse = response as? HTTPURLResponse {
            print("___________ Status Code: \(httpResponse.statusCode)")
        }

        if let string = String(data: data, encoding: .utf8) {
            print("$$$$$$$$$$$$$$$______Response Body: \(string)")
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

}


//MARK: - CALL MultipartAPI

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
//Resuable Common Function to call api

struct MultipartFile {
    let name: String
    let filename: String
    let mimeType: String
    let data: Data
}

class MultipartAPIService {
    static let shared = MultipartAPIService()

    func upload(
        url: URL,
        fields: [String: String],
        files: [MultipartFile],
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = createBody(fields: fields, files: files, boundary: boundary)

        URLSession.shared.uploadTask(with: request, from: httpBody) { data, response, error in
            if let error = error {
                print("ohh Shit  ....... Error: \(error)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            print("Waooo....... Status Code: \(httpResponse.statusCode)")

            if let data = data {
                print("**What a ...... Response: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
                if (200...299).contains(httpResponse.statusCode) {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
                }
            } else {
                completion(.failure(NSError(domain: "Empty response", code: 0)))
            }
        }.resume()
    }

    private func createBody(fields: [String: String], files: [MultipartFile], boundary: String) -> Data {
        var body = Data()

        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        for file in files {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n")
            body.append("Content-Type: \(file.mimeType)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        return body
    }
}




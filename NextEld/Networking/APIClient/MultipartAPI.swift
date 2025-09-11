//
//  MultipartAPI.swift
//  NextEld
//
//  Created by priyanshi   on 11/08/25.
//

import Foundation
import SwiftUI
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

//class MultipartAPIService {
//    static let shared = MultipartAPIService()
//
//    func upload(
//        url: URL,
//        fields: [String: String],
//        files: [MultipartFile],
//        completion: @escaping (Result<Data, Error>) -> Void
//    ) {
//        let boundary = "Boundary-\(UUID().uuidString)"
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let httpBody = createBody(fields: fields, files: files, boundary: boundary)
//
//        URLSession.shared.uploadTask(with: request, from: httpBody) { data, response, error in
//            if let error = error {
//                print("ohh Shit  ....... Error: \(error)")
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(NSError(domain: "Invalid response", code: 0)))
//                return
//            }
//
//            print("Waooo....... Status Code: \(httpResponse.statusCode)")
//
//            if let data = data {
//                print("**What a ...... Response: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
//                if (200...299).contains(httpResponse.statusCode) {
//                    completion(.success(data))
//                } else {
//                    completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
//                }
//            } else {
//                completion(.failure(NSError(domain: "Empty response", code: 0)))
//            }
//        }.resume()
//    }
//
//    private func createBody(fields: [String: String], files: [MultipartFile], boundary: String) -> Data {
//        var body = Data()
//
//        for (key, value) in fields {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.append("\(value)\r\n")
//        }
//
//        for file in files {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n")
//            body.append("Content-Type: \(file.mimeType)\r\n\r\n")
//            body.append(file.data)
//            body.append("\r\n")
//        }
//
//        body.append("--\(boundary)--\r\n")
//        return body
//    }
//}



class MultipartAPIService {
    static let shared = MultipartAPIService()

    func upload(
        url: URL,
        fields: [String: Any],   // <-- Ab Any bhi chalega
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
                print("❌ Error: \(error)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }

            print("📡 Status Code: \(httpResponse.statusCode)")

            if let data = data {
                print("📩 Response: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
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

    private func createBody(fields: [String: Any], files: [MultipartFile], boundary: String) -> Data {
        var body = Data()

        for (key, value) in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")

            // ✅ Handle Int, Double, Bool, String
            if let intValue = value as? Int {
                body.append("\(intValue)\r\n")
            } else if let doubleValue = value as? Double {
                body.append("\(doubleValue)\r\n")
            } else if let boolValue = value as? Bool {
                body.append("\(boolValue)\r\n")
            } else {
                body.append("\(value)\r\n")
            }
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

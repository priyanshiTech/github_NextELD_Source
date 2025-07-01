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

        var url: URL {
            switch self {
            case .login:
                return API.baseURL.appendingPathComponent("auth/login")
            }
        }

        var method: String {
            switch self {
            case .login:
                return "POST"
            }
        }
    }
}




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



/*enum API {
    static let baseURL = URL(string: "https://gbt-usa.com/eld_log/")! //  MARK: BASE URL

    enum Endpoint {
        case login

        var url: URL {
            switch self {
            case .login:
                return API.baseURL.appendingPathComponent("auth/login")

            }
        }

        var method: String {
            switch self {
            case .login:
                return "POST"
            }
        }
    }
}

func testLoginEndpoint() {
    let endpoint = API.Endpoint.login
    print("URL: \(endpoint.url)")
    print("Method: \(endpoint.method)")
}


final class NetworkManager: APIClient {

    static let shared = NetworkManager()
    private init() {}
    // Convenient wrappers:

    func get<T: Decodable>(_ endpoint: API.Endpoint) async throws -> T {
        try await request(endpoint, body: nil)
    }

    func post<T: Decodable, U: Encodable>(_ endpoint: API.Endpoint, body: U) async throws -> T {
        let data = try JSONEncoder().encode(body)
        return try await request(endpoint, body: data)
    }

    func delete(_ endpoint: API.Endpoint) async throws {
        _ = try await request(endpoint, body: nil) as EmptyResponse
    }
    
    //MARK: -  To call a Post API's

       func request<T>(
            _ endpoint: API.Endpoint,
            body: Data? = nil
        ) async throws -> T where T: Decodable {
            var request = URLRequest(url: endpoint.url)
            request.httpMethod = endpoint.method
            if let payload = body {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = payload
            }
    
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return try JSONDecoder().decode(T.self, from: data)
        }


    }


struct EmptyResponse: Decodable {}

// Networking/APIClient.swift*/




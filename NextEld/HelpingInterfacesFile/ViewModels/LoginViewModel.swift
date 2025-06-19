//
//  LoginViewModel.swift
//  NextEld
//
//  Created by Priyanshi on 19/06/25.
//

import Foundation
import SwiftUI
struct LoginRequestModel: Encodable {
    let username: String
    let password: String
    let mobileDeviceId: String
    let isCoDriver: Bool
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var token: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    
    
    func login(email: String, password: String) async {
        print("🚀 Starting login...")
        isLoading = true
        errorMessage = nil

        let requestBody = LoginRequestModel(
            username: email,
            password: password,
            mobileDeviceId: "jay12345",
            isCoDriver: true
        )
        print("📤 Request Body: \(requestBody)")

        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .login,
                body: requestBody
            )

            print("📬 API Response: \(response)")

            if let token = response.token {
                self.token = token
                print("✅ Token received: \(token)")
            } else {
                self.errorMessage = response.message ?? "Login failed"
                print("❌ Login failed with message: \(response.message ?? "Unknown")")
            }
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Network error: \(error.localizedDescription)")
        }

        isLoading = false
        print("🔚 Login finished")
    }

    private func urlEncodedForm(from dict: [String: String]) -> Data? {
        var components = URLComponents()
        components.queryItems = dict.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.query?.data(using: .utf8)
    }
}





































/*class LoginViewModel: ObservableObject {
    @Published var token: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func login(email: String, password: String) async {
        isLoading = true

        let formBody = [
            "username": email,
            "password": "1234567890",
            "mobileDeviceId": "jay12345",
            "isCoDriver": "true"
        ]
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")
        .data(using: .utf8)

        do {
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .login,
                body: formBody,
                //contentType: "application/x-www-form-urlencoded"
            )

            if let token = response.token {
                self.token = token
                print("✅ Token: \(token)")
            } else {
                self.errorMessage = response.message ?? "Login failed"
                print("❌ Message: \(response.message ?? "")")
            }
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}*/



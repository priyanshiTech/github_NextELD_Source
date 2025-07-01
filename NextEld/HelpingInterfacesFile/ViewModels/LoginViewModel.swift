//
//  LoginViewModel.swift
//  NextEld
//
//  Created by Priyanshi on 19/06/25.
//

import Foundation
import SwiftUI

@MainActor

struct LoginRequestModel: Encodable {
    let username: String
    let password: String
    let mobileDeviceId: String
    let isCoDriver: Bool
}
class LoginViewModel: ObservableObject {
    @Published var token: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    
    @AppStorage("hasLoggedIn") var hasLoggedIn: Bool = false

    
    func login(email: String, password: String) async {
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
            // 2️⃣ Call API
           
          
            let response: TokenModelLog = try await NetworkManager.shared.post(.login, body: requestBody)
            print("📬 API Response: \(response)")
            if let token = response.token {
                self.token = token
                KeychainHelper.shared.save(token, forKey: "authToken")
                print("✅ Token saved in Keychain: \(token)")
            }
         
            else {
                self.errorMessage = response.message ?? "Login failed"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
 

    func loadSavedSession() {
        token = KeychainHelper.shared.read(forKey: "authToken")
        print("📥 Loaded token: \(token ?? "nil")")
    }
    //MARK: -  Helping Function
    func checkExistingSession() -> Bool {
        if let savedToken = KeychainHelper.shared.read(forKey: "authToken") {
            self.token = savedToken
            return true
        }
        return false
    }


    func logout() {
//        token = nil
//        hasLoggedIn = false
//        KeychainHelper.shared.delete(forKey: "authToken")
//        print("🚪 Logged out and token removed")
        token = nil
        KeychainHelper.shared.delete(forKey: "authToken")
    }
}
















































/*
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

        // 1️⃣ Create request body
        let requestBody = LoginRequestModel(
            username: email,
            password: password,
            mobileDeviceId: "jay12345",
            isCoDriver: true
        )
        print("📤 Request Body: \(requestBody)")
        do {
            // 2️⃣ Call API
            let response: TokenModelLog = try await NetworkManager.shared.post(
                .login,
                body: requestBody
            )
            print("📬 API Response: \(response)")
            // 3️⃣ Store token if present
            if let token = response.token {
                self.token = token
                print("✅ Token received: \(token)")
            }
            // 4️⃣ Save driver logs to SQLite
            if let logs = response.result?.driverLog {
                print("🧩 Driver logs received from API: \(logs.count)")
                // ✅ Print each log before saving
                for (index, log) in logs.enumerated() {
                    print("📄 Log \(index + 1): Status: \(log.status ?? "nil"), StartTime: \(log.dateTime ?? "nil")")
                }
                // ✅ Save into SQLite
                DatabaseManager.shared.saveDriverLogsToSQLite(from: logs)
            } else {
                print("❌ No driver logs found in API response.")
            }
        } catch {
            // 5️⃣ Handle error
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
}*/





























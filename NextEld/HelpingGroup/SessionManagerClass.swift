//
//  SessionManagerClass.swift
//  NextEld
//
//  Created by Priyanshi   on 02/07/25.
//
//
import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    func saveToken(_ token: String) {
        let data = Data(token.utf8)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecValueData: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func readToken() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func deleteToken() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken"
        ]

        SecItemDelete(query as CFDictionary)
    }
}
//
//
////MARK: -  objectobseravle class
import Foundation

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var token: String?

    func logIn(token: String) {
        self.token = token
        self.isLoggedIn = true
        print(" Logged in with token: \(token)")
    }

    func logOut() {
        self.token = nil
        self.isLoggedIn = false
        print("🚪 Logged out")
        print(" Token removed from UserDefaults")
    }
}


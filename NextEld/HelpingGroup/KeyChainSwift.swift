//
//  KeyChainSwift.swift
//  NextEld
//
//  Created by Priyanshi   on 02/07/25.
//

import Foundation
import KeychainSwift

class SessionManagerClass {
    static let shared = SessionManagerClass()
    private let keychain = KeychainSwift()

    init() {
        // Configure keychain access options
        keychain.accessGroup = nil // Use default access group
        keychain.synchronizable = false // Don't sync across devices via iCloud
    }

    func saveToken(_ token: String) {
        let success = keychain.set(token, forKey: "userToken")
        if success {
            // print(" Token saved to keychain successfully")
        } else {
            // print(" Failed to save token to keychain")
            // Fallback to UserDefaults if keychain fails
            UserDefaults.standard.set(token, forKey: "userToken")
            // print(" Token saved to UserDefaults as fallback")
        }
    }

    func getToken() -> String? {
        if let token = keychain.get("userToken") {
            return token
        } else {
            // Fallback to UserDefaults if keychain retrieval fails
            if let token = UserDefaults.standard.string(forKey: "userToken") {
                // print(" Token retrieved from UserDefaults (keychain unavailable)")
                return token
            }
            // print(" No token found in keychain or UserDefaults")
            return nil
        }
    }

    func clearToken() {
        let deleted = keychain.delete("userToken")
        if deleted {
            // print("Token removed from keychain")
        } else {
            // print("Failed to delete token from keychain (may not exist)")
        }
        // Also remove from UserDefaults
        UserDefaults.standard.removeObject(forKey: "userToken")
    }

    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
}

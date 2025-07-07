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

    func saveToken(_ token: String) {
        keychain.set(token, forKey: "userToken")
        print(" Token Saved from keychain")
    }

    func getToken() -> String? {
        keychain.get("userToken")
    }

    func clearToken() {
        keychain.delete("userToken")
        print(" Token removed from KeyChain")
    }

    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
}

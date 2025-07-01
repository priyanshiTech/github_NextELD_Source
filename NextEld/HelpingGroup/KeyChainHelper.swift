//
//  KeyChainHelper.swift
//  NextEld
//
//  Created by Priyanshi  on 30/06/25.
//


import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }

    func delete(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}






































/*import Foundation
import Security


class KeychainHelper {
    static let shared = KeychainHelper()

    func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    func read(forKey key: String) -> String? {
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        guard let data = result as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }

    func delete(forKey key: String) {
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}*/

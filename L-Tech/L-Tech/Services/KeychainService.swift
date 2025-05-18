//
//  KeychainService.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()

    private init() {}

    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]

        SecItemDelete(query as CFDictionary) 

        let attributes: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrAccount as String: key,
                                         kSecValueData as String: data]

        SecItemAdd(attributes as CFDictionary, nil)
    }

    func read(forKey key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecReturnData as String: true,
                                    kSecMatchLimit as String: kSecMatchLimitOne]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }

    func delete(forKey key: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
    }
}


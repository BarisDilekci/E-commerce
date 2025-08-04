//
//  KeychainHelper.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation
import Security


protocol KeychainHelperProtocol {
    func save(_ value: String, for key: String) -> Bool
    func get(_ key: String) -> String?
    func delete(_ key: String) -> Bool
}

final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    func save(_ token: String, for key: String) -> Bool {
          guard let data = token.data(using: .utf8) else { return false }
          
          
          delete(key)
          
          let query: [String: Any] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: key,
              kSecValueData as String: data,
              kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
          ]
          
          let status = SecItemAdd(query as CFDictionary, nil)
          return status == errSecSuccess
      }
    
    func get(_ key: String) -> String? {
         let query: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: key,
             kSecReturnData as String: true,
             kSecMatchLimit as String: kSecMatchLimitOne
         ]
         
         var result: AnyObject?
         let status = SecItemCopyMatching(query as CFDictionary, &result)
         
         guard status == errSecSuccess,
               let data = result as? Data,
               let token = String(data: data, encoding: .utf8) else {
             return nil
         }
         
         return token
     }
    
    func delete(_ key: String) -> Bool {
          let query: [String: Any] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: key
          ]
          
          let status = SecItemDelete(query as CFDictionary)
          return status == errSecSuccess || status == errSecItemNotFound
      }
    
    func exists(_ key: String) -> Bool {
          return get(key) != nil
      }
}

//
//  password+hasher+extensions.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation
import CryptoKit

// MARK: - String Extensions for Password Hashing
extension String {
    // SHA256 hash
    func sha256() -> String {
        let data = Data(self.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // MD5 hash (güvenlik açısından önerilmez, sadece eski sistemler için)
    func md5() -> String {
        let data = Data(self.utf8)
        let hashed = Insecure.MD5.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Salt ile hash (basit versiyon)
    func hashWithSalt(_ salt: String = "your_app_salt") -> String {
        return (self + salt).sha256()
    }
}

//
//  UserStorage.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation

protocol UserStorageProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func deleteToken()

    func saveUser(_ user: User)
    func getUser() -> User?
    func deleteUser()

    var isLoggedIn: Bool { get set }
}

final class UserStorage: UserStorageProtocol {
    private let tokenKey = "auth_token"
    private let userKey = "current_user"
    private let isLoggedInKey = "isLoggedIn"
    
    private let keychain: KeychainHelperProtocol
    private let defaults: UserDefaults
    
    init(keychain: KeychainHelperProtocol = KeychainHelper.shared, defaults: UserDefaults = .standard) {
        self.keychain = keychain
        self.defaults = defaults
    }

    func saveToken(_ token: String) {
        keychain.save(token, for: tokenKey)
    }

    func getToken() -> String? {
        keychain.get(tokenKey)
    }

    func deleteToken() {
        keychain.delete(tokenKey)
    }

    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            defaults.set(data, forKey: userKey)
        }
    }

    func getUser() -> User? {
        guard let data = defaults.data(forKey: userKey) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func deleteUser() {
        defaults.removeObject(forKey: userKey)
    }

    var isLoggedIn: Bool {
        get { defaults.bool(forKey: isLoggedInKey) }
        set { defaults.set(newValue, forKey: isLoggedInKey) }
    }
}

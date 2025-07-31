//
//  ProfileViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 1.08.2025.
//

import Foundation

final class ProfileViewModel {
    private let authService: AuthServiceProtocol
    
    var username: String = ""
    var email: String = ""
    var fullName: String = ""
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
        loadUserInfo()
    }
    
    func loadUserInfo() {
        guard let user = authService.getCurrentUser() else {
            print("❌ Kullanıcı bulunamadı.")
            return
        }
        self.username = user.username
        self.email = user.email
        self.fullName = "\(user.firstName) \(user.lastName)"
    }
    
    func logout() {
        authService.logout()
    }
}

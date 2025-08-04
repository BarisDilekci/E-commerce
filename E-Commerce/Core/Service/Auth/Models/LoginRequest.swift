//
//  LoginRequest.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation

struct LoginRequest: Codable {
    let usernameOrEmail: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case usernameOrEmail = "username_or_email"
        case password
    }
    
    // Backend'iniz username_or_email field'ı bekliyor
    init(usernameOrEmail: String, password: String) {
        self.usernameOrEmail = usernameOrEmail
        self.password = password
    }
}

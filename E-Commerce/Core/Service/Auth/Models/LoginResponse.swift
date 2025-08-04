//
//  LoginResponse.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
}

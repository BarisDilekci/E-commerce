//
//  JWTClaims.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation

struct JWTClaims: Codable {
    let userId: Int64
    let username: String
    let email: String
    let exp: Int64
    let iat: Int64
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username, email, exp, iat
    }
}

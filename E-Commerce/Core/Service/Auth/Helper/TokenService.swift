//
//  TokenService.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation

protocol TokenServiceProtocol {
    func isExpired(token: String) -> Bool
    func decodeClaims(token: String) -> JWTClaims?
    func expiryDate(token: String) -> Date?
}

final class TokenService: TokenServiceProtocol {
    func isExpired(token: String) -> Bool {
        guard let claims = decodeClaims(token: token) else { return true }
        return Int64(Date().timeIntervalSince1970) >= claims.exp
    }

    func decodeClaims(token: String) -> JWTClaims? {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return nil }
        
        var base64 = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let pad = 4 - base64.count % 4
        if pad < 4 { base64 += String(repeating: "=", count: pad) }

        guard let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONDecoder().decode(JWTClaims.self, from: data)
    }

    func expiryDate(token: String) -> Date? {
        guard let claims = decodeClaims(token: token) else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(claims.exp))
    }
}

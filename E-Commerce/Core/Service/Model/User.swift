//
//  User.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation

// Go backend'inizin User response'una göre model
struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // Computed properties
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var displayName: String {
        return fullName.isEmpty ? username : fullName
    }
    
    // Date formatters
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    var createdDate: Date? {
        return User.dateFormatter.date(from: createdAt)
    }
    
    var updatedDate: Date? {
        return User.dateFormatter.date(from: updatedAt)
    }
}

// MARK: - User Extensions
extension User {
    // Debug description
    var debugDescription: String {
        return """
        User {
            id: \(id)
            username: \(username)
            email: \(email)
            name: \(fullName)
            created: \(createdAt)
        }
        """
    }
}

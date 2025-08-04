//
//  RegisterRequest.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case username, email, password
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(username: String, email: String, password: String, firstName: String, lastName: String) {
        self.username = username
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}

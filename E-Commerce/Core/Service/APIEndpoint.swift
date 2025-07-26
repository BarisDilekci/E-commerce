//
//  APIEndoint.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.07.2025.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "http://localhost:8080/api/v1"

    case products
    case productsByCategory(id: Int)
    case category
    
    case login
    case register
    case logout
    case refreshToken

    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productsByCategory(let id):
            return "/categories/\(id)/products"
        case .category:
            return "/categories"
            
        // Auth paths
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .logout:
            return "/auth/logout"
        case .refreshToken:
            return "/auth/refresh"
        }
    }

    var url: URL? {
        return URL(string: APIEndpoint.baseURL + path)
    }
    
    var httpMethod: String {
        switch self {
        case .products, .productsByCategory, .category:
            return "GET"
        case .login, .register, .logout, .refreshToken:
            return "POST"
        }
    }
}

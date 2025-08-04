//
//  APIEndoint.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.07.2025.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIEndpoint {
    case products
    case productsByCategory(id: Int)
    case category
    case login
    case register
    case logout
    case refreshToken

    var baseURL: String {
        return "http://localhost:8080/api/v1"
    }

    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productsByCategory(let id):
            return "/categories/\(id)/products"
        case .category:
            return "/categories"
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
        return URL(string: baseURL + path)
    }

    var method: HTTPMethod {
        switch self {
        case .products, .productsByCategory, .category:
            return .get
        case .login, .register, .logout, .refreshToken:
            return .post
        }
    }

    var headers: [String: String] {
        switch self {
        case .login, .register:
            return ["Content-Type": "application/json"]
        default:
            return [:]
        }
    }
}

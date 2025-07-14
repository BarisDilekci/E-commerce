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

    var path: String {
        switch self {
        case .products:
            return "/products"
        }
    }

    var url: URL? {
        return URL(string: APIEndpoint.baseURL + path)
    }
}

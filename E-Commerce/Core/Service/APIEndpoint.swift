//
//  APIEndoint.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.07.2025.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://fakestoreapi.com/"
    

    case products
    case category
    
    
    var path : String {
        switch self {
        case .products:
            return "/\(APIEndpoint.baseURL)/houses"
        case .category:
            return "/\(APIEndpoint.baseURL)/categories"

        }
    }
    
    var url : URL? {
        return URL(string: APIEndpoint.baseURL + path)
    }
}

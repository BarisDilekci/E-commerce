//
//  NetworkError.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.07.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case noInternet
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Decoding error"
        case .serverError(let message):
            return "Server error: \(message)"
        case .noInternet:
            return "No internet connection"
        }
    }
}

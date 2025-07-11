//
//  NetworkService.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 12.07.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T : Decodable>(endpoint: APIEndpoint) async throws -> T
}

final class NetworkService : NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session : URLSession
    
    init(session : URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T>(endpoint: APIEndpoint) async throws -> T where T : Decodable {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError("Invalid response")
            }
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        }
        
        catch let decodingError as DecodingError {
            print("Decoding:  \(decodingError)")
            throw NetworkError.decodingError
        }
    }
    
    
}

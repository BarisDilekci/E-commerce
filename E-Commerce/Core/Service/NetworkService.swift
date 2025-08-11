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

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSession
    private let networkMonitor: NetworkMonitorProtocol?
    private var requestAdapters: [RequestAdapter] = []
    private var tokenRefresher: TokenRefreshing?

    init(session: URLSession = .shared, networkMonitor: NetworkMonitorProtocol? = nil, adapters: [RequestAdapter] = [], tokenRefresher: TokenRefreshing? = nil) {
        self.session = session
        self.networkMonitor = networkMonitor
        self.requestAdapters = adapters
        self.tokenRefresher = tokenRefresher
    }
    
    func fetch<T>(endpoint: APIEndpoint) async throws -> T where T : Decodable {
        guard let url = endpoint.url else { throw NetworkError.invalidURL }
        if let monitor = networkMonitor, monitor.isConnected == false { throw NetworkError.noInternet }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            endpoint.headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }

            // Apply adapters (e.g., Authorization)
            for adapter in requestAdapters {
                request = adapter.adapt(request)
            }

            var (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401, let refresher = tokenRefresher, refresher.shouldRefresh(response: httpResponse) {
                // Try refresh token then retry once
                let refreshed: Bool = await withCheckedContinuation { continuation in
                    refresher.refreshTokenIfNeeded { success in continuation.resume(returning: success) }
                }
                if refreshed {
                    // Re-apply adapters (updated token) and retry
                    var retryRequest = request
                    for adapter in requestAdapters { retryRequest = adapter.adapt(retryRequest) }
                    (data, response) = try await session.data(for: retryRequest)
                }
            }

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

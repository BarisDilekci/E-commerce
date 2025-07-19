//
//  E_CommerceTests.swift
//  E-CommerceTests
//
//  Created by Barış Dilekçi on 14.06.2025.
//

import Testing
@testable import E_Commerce

struct E_CommerceTests {
    
    let service = MockNetworkService()

    @Test func fetch_product() async throws {
        let result: [Product] = try await service.fetch(endpoint: .products)
        
        #expect(result.count == 2, "Expected 2 products to be returned.")
        #expect(result[0].name == "Mock Product 1", "The name of the first product should match.")
        #expect(result[1].store == "Electronics", "Store category should be correct.")
    }

}

class MockNetworkService: NetworkServiceProtocol {
    private let mockProductData: [Product] = [
        Product(id: 1, name: "Mock Product 1", price: 99.9, discount: 70.0, store: "Electronics", imageUrls: ["https://via.placeholder.com/150"]),
        Product(id: 2, name: "Mock Product 2", price: 99.9, discount: 70.0, store: "Electronics", imageUrls: ["https://via.placeholder.com/150"]),
    ]
    
    func fetch<T>(endpoint: APIEndpoint) async throws -> T where T: Decodable {
        switch endpoint {
        case .products:
            if T.self == [Product].self {
                return mockProductData as! T
            } else {
                throw NetworkError.invalidURL
            }
        }
    }
}


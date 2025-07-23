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
        #expect(result[0].name == "Kablosuz Mouse", "The name of the first product should match.")
        #expect(result[1].store == "Teknoloji Dükkanı", "Store category should be correct.")

    }
    
    @Test func fetch_product_by_category() async throws {
        let result: [Product] = try await service.fetch(endpoint: .productsByCategory(id: 1))
        
        #expect(result.count == 2, "Expected 2 products to be returned.")
        
        #expect(result[0].name == "Kablosuz Mouse", "The name of the first product should match.")
        #expect(result[1].store == "Teknoloji Dükkanı", "Store category should be correct.")

    }

}

class MockNetworkService: NetworkServiceProtocol {
    private let mockProductData: [Product] = [
        Product(id: 1, name: "Kablosuz Mouse", price: 250.75, description: "Ergonomik tasarıma sahip kablosuz mouse.", discount: 0.1, store: "Teknoloji Dükkanı", imageUrls: [
            "http://example.com/mouse_image1.jpg",
            "http://example.com/mouse_image2.jpg"
        ], category_id: 1),
        Product(id: 2, name: "Kablosuz Mouse", price: 250.75, description: "Ergonomik tasarıma sahip kablosuz mouse.", discount: 0.1, store: "Teknoloji Dükkanı", imageUrls: [
            "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/apple/thumb/1-272_large.jpg",
            "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/apple/thumb/1-272_large.jpg"
        ], category_id: 1),
    ]
    
    func fetch<T>(endpoint: APIEndpoint) async throws -> T where T: Decodable {
        switch endpoint {
        case .products:
            if T.self == [Product].self {
                return mockProductData as! T
            } else {
                throw NetworkError.invalidURL
            }
            
        case .productsByCategory(let id):
            if T.self == [Product].self {
                let filtered = mockProductData.filter { $0.category_id == id }
                return filtered as! T
            } else {
                throw NetworkError.invalidURL
            }
        }
    }
}

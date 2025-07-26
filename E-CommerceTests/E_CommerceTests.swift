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
    
    @Test func fetch_product_by_id_category() async throws {
        let result: [Product] = try await service.fetch(endpoint: .productsByCategory(id: 1))
        
        #expect(result.count == 2, "Expected 2 products to be returned.")
        
        #expect(result[0].name == "Kablosuz Mouse", "The name of the first product should match.")
        #expect(result[1].store == "Teknoloji Dükkanı", "Store category should be correct.")
    }
    
    @Test func fetch_product_all_category() async throws {
        let result: [Category] = try await service.fetch(endpoint: .category)
        
        #expect(!result.isEmpty, "Categories should not be empty")
        #expect(result.count == 5, "Should return 5 categories")
        #expect(result.first?.name == "Electronics", "First category should be Electronics")
        #expect(result.allSatisfy { $0.id > 0 }, "All category IDs should be positive")

        let hasElectronics = result.contains { $0.name == "Electronics" }
        #expect(hasElectronics, "Should contain Electronics category")
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
    
    private let mockCategoryData: [Category] = [
        Category(id: 1, name: "Electronics"),
        Category(id: 2, name: "Clothing"),
        Category(id: 3, name: "Books"),
        Category(id: 4, name: "Home & Garden"),
        Category(id: 5, name: "Sports")
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
        case .category:
            if T.self == [Category].self {
                return mockCategoryData as! T
            } else {
                throw NetworkError.invalidURL
            }
        case .login:
            throw NetworkError.noData

        case .register:
            throw NetworkError.noData

        case .logout:
            throw NetworkError.noData

        case .refreshToken:
            throw NetworkError.noData
        }
    }
}

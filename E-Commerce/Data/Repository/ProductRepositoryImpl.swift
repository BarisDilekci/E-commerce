import Foundation

final class ProductRepositoryImpl: ProductRepository {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func getProducts() async throws -> [Product] {
        try await network.fetch(endpoint: .products)
    }

    func getProducts(byCategoryId categoryId: Int) async throws -> [Product] {
        try await network.fetch(endpoint: .productsByCategory(id: categoryId))
    }
}



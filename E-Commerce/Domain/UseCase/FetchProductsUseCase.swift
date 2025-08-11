import Foundation

protocol FetchProductsUseCase {
    func execute() async throws -> [Product]
}

final class DefaultFetchProductsUseCase: FetchProductsUseCase {
    private let repository: ProductRepository
    init(repository: ProductRepository) { self.repository = repository }

    func execute() async throws -> [Product] {
        try await repository.getProducts()
    }
}



import Foundation

protocol FetchProductsByCategoryUseCase {
    func execute(categoryId: Int) async throws -> [Product]
}

final class DefaultFetchProductsByCategoryUseCase: FetchProductsByCategoryUseCase {
    private let repository: ProductRepository
    init(repository: ProductRepository) { self.repository = repository }

    func execute(categoryId: Int) async throws -> [Product] {
        try await repository.getProducts(byCategoryId: categoryId)
    }
}



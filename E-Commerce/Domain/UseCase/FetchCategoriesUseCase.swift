import Foundation

protocol FetchCategoriesUseCase {
    func execute() async throws -> [Category]
}

final class DefaultFetchCategoriesUseCase: FetchCategoriesUseCase {
    private let repository: CategoryRepository
    init(repository: CategoryRepository) { self.repository = repository }

    func execute() async throws -> [Category] {
        try await repository.getCategories()
    }
}



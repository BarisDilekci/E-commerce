import Foundation

final class CategoryRepositoryImpl: CategoryRepository {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol) { self.network = network }

    func getCategories() async throws -> [Category] {
        try await network.fetch(endpoint: .category)
    }
}



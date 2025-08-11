import Foundation

protocol CategoryRepository {
    func getCategories() async throws -> [Category]
}



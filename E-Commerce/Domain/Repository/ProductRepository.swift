import Foundation

protocol ProductRepository {
    func getProducts() async throws -> [Product]
    func getProducts(byCategoryId categoryId: Int) async throws -> [Product]
}



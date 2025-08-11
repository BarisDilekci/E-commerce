import Foundation

protocol FavoritesServiceProtocol {
    func isFavorite(productId: Int) -> Bool
    func toggleFavorite(_ product: Product)
    func allFavorites() -> [Product]
}

final class FavoritesService: FavoritesServiceProtocol {
    private let storageKey = "favorite_products"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func isFavorite(productId: Int) -> Bool {
        return allFavorites().contains(where: { $0.id == productId })
    }

    func toggleFavorite(_ product: Product) {
        var items = allFavorites()
        if let id = product.id, let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        } else {
            items.append(product)
        }
        save(items)
    }

    func allFavorites() -> [Product] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([Product].self, from: data)) ?? []
    }

    private func save(_ products: [Product]) {
        if let data = try? JSONEncoder().encode(products) {
            defaults.set(data, forKey: storageKey)
        }
    }
}



//
//  HomeViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 15.07.2025.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
    var products: [Product] { get }
    var filteredProducts: [Product] { get }
    var isSearching: Bool { get set }
    var onProductsFetched: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var refreshControl: UIRefreshControl { get }
    var onProductSelected: ((Product) -> Void)? { get set }

    
    func viewDidLoad()
    func searchProducts(query: String)
    func numberOfItems() -> Int
    func product(at index: Int) -> Product
    func didSelectProduct(at index: Int)
}

final class HomeViewModel: HomeViewModelProtocol {
    
    private let fetchProductsUseCase: FetchProductsUseCase
    
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isSearching: Bool = false
    
    var onProductsFetched: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private var cachedProducts: [Product] = []
    private var lastFetchTime: Date?
    private let cacheValidityDuration: TimeInterval = 300
    
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIConstants.Colors.tint
        return refresh
    }()
    
    var onProductSelected: ((Product) -> Void)?

    
    init(fetchProductsUseCase: FetchProductsUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    func viewDidLoad() {
        if let lastFetch = lastFetchTime,
           Date().timeIntervalSince(lastFetch) < cacheValidityDuration,
           !cachedProducts.isEmpty {
            self.products = cachedProducts
            onProductsFetched?()
            return
        }
        fetchProducts()
    }
    
    func searchProducts(query: String) {
        if query.isEmpty {
            isSearching = false
            onProductsFetched?()
            return
        }
        isSearching = true
        filteredProducts = products.filter { $0.name.lowercased().contains(query.lowercased()) }
        onProductsFetched?()
    }
    
    func numberOfItems() -> Int {
        return isSearching ? filteredProducts.count : products.count
    }
    
    func product(at index: Int) -> Product {
        return isSearching ? filteredProducts[index] : products[index]
    }
    
    func didSelectProduct(at index: Int) {
        guard index >= 0 else { return }
        let selectedProduct: Product
        if isSearching {
            guard index < filteredProducts.count else { return }
            selectedProduct = filteredProducts[index]
        } else {
            guard index < products.count else { return }
            selectedProduct = products[index]
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        onProductSelected?(selectedProduct)
    }



    
    private func fetchProducts() {
        onLoadingStateChanged?(true)
        Task {
            do {
                let fetchedProducts: [Product] = try await fetchProductsUseCase.execute()
                let filtered = fetchedProducts.filter { !$0.name.isEmpty && $0.price > 0 }
                    .sorted { $0.name < $1.name }
                
                DispatchQueue.main.async {
                    self.products = filtered
                    self.cachedProducts = filtered
                    self.lastFetchTime = Date()
                    self.onLoadingStateChanged?(false)
                    self.onProductsFetched?()
                }
            } catch {
                DispatchQueue.main.async {
                    self.onLoadingStateChanged?(false)
                    self.onError?(error)
                }
            }
        }
    }
}

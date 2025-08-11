//
//  ProductListViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 24.07.2025.
//
import Foundation
import UIKit

protocol ProductListModelProtocol {
    func viewDidLoad()
    var onProductsFetched: (([Product]) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    func numberOfItemsInSection() -> Int
    func cellForItemAt(at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell
    func didSelectRow(at indexPath: IndexPath)
    var refreshControl: UIRefreshControl { get }
    var loadingView: UIActivityIndicatorView { get }
}

final class ProductListViewModel: ProductListModelProtocol {
    
    // MARK: - Properties
    private let categoryId: Int
    private let fetchByCategoryUseCase: FetchProductsByCategoryUseCase
    private var products: [Product] = []
    private var cachedProducts: [Product] = []
    private var lastFetchTime: Date?
    let categoryName: String
    private let cacheValidityDuration: TimeInterval = 300
    
    var onProductsFetched: (([Product]) -> Void)?
    var onError: ((Error) -> Void)?
    var onProductSelected: ((Product) -> Void)?
    
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIConstants.Colors.tint
        return refresh
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Init
    init(categoryId: Int, categoryName: String, fetchByCategoryUseCase: FetchProductsByCategoryUseCase) {
          self.categoryId = categoryId
          self.categoryName = categoryName
          self.fetchByCategoryUseCase = fetchByCategoryUseCase
      }
    // MARK: - Lifecycle
    func viewDidLoad() {
        if let lastFetch = lastFetchTime,
           Date().timeIntervalSince(lastFetch) < cacheValidityDuration,
           !cachedProducts.isEmpty {
            self.products = cachedProducts
            onProductsFetched?(cachedProducts)
            return
        }
        fetchProducts()
    }
    
    // MARK: - Actions
    private func fetchProducts() {
        Task {
            do {
                let fetched: [Product] = try await fetchByCategoryUseCase.execute(categoryId: categoryId)
                await MainActor.run {
                    self.products = fetched
                    self.cachedProducts = fetched
                    self.lastFetchTime = Date()
                    self.onProductsFetched?(fetched)
                }
            } catch {
                await MainActor.run {
                    self.onError?(error)
                }
            }
        }
    }
    
    func refresh() {
        clearCache()
        fetchProducts()
    }
    
    private func clearCache() {
        cachedProducts.removeAll()
        lastFetchTime = nil
    }
    
    func numberOfItemsInSection() -> Int {
        return products.count
    }
    
    func cellForItemAt(at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        onProductSelected?(selectedProduct)
    }
}

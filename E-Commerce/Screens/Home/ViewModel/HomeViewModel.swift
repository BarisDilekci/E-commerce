//
//  HomeViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 15.07.2025.
//
import Foundation
import UIKit

protocol HomeViewModelProtocol {
    func viewDidLoad()
    var onProductsFetched: (([Product]) -> Void)? { get set }
    func cellForItemAt(at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell
    var onError: ((Error) -> Void)? { get set }
    func numberOfItemsInSection() -> Int
    func didSelectRow(at indexPath: IndexPath)
    
    
}

final class HomeViewModel: HomeViewModelProtocol {

    
    private let networkService: NetworkServiceProtocol
    
    var onProductsFetched: (([Product]) -> Void)?
    var onError: ((Error) -> Void)?
    var product : [Product] = []
    
    private var cachedProducts: [Product] = []
    private var lastFetchTime: Date?
    private let cacheValidityDuration: TimeInterval = 300
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        if let lastFetch = lastFetchTime,
           Date().timeIntervalSince(lastFetch) < cacheValidityDuration,
           !cachedProducts.isEmpty {
            onProductsFetched?(cachedProducts)
            return
        }
        
        fetchProducts()
    }
    
    private func fetchProducts() {
        Task {
            do {
                let products = try await fetch()
                
                await MainActor.run {
                    self.product = products
                    self.cachedProducts = products
                    self.lastFetchTime = Date()
                    self.onProductsFetched?(products)
                }
            } catch {
                await MainActor.run {
                    self.onError?(error)
                }
                print("Ürünler alınırken hata oluştu: \(error)")
            }
        }
    }

    
    private func fetch() async throws -> [Product] {
        let products: [Product] = try await networkService.fetch(endpoint: APIEndpoint.products)
        
        // Ürünleri filtrele ve sırala (opsiyonel)
        let filteredProducts = products
            .filter { !$0.name.isEmpty && $0.price > 0 }
            .sorted { $0.name < $1.name }
        
        return filteredProducts
    }
    
    func clearCache() {
        cachedProducts.removeAll()
        lastFetchTime = nil
    }
    
    func refresh() {
        clearCache()
        fetchProducts()
    }
    
    func numberOfItemsInSection() -> Int {
        return product.count
    }
    
    func cellForItemAt(at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: product[indexPath.item])
        return cell
    }
    
    
    
    func didSelectRow(at indexPath: IndexPath) {
        let product = product[indexPath.item]
        
        let impactGenerator = UIImpactFeedbackGenerator(style: .light)
        impactGenerator.impactOccurred()

        
        print("Selected product: \(product.name)")
    }
    
     let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .systemBlue
        return refresh
    }()
    
     let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
}


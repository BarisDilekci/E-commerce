//
//  DIContainer.swift
//  E-Commerce
//
//  Created by AI Assistant on 11.08.2025.
//

import Foundation
import UIKit

final class DIContainer {
    static let shared = DIContainer()

    // MARK: - Core
    private(set) lazy var appConfig: AppConfig = AppConfig.current
    private(set) lazy var networkMonitor: NetworkMonitorProtocol = {
        let monitor = NetworkMonitor()
        monitor.start()
        return monitor
    }()

    // MARK: - Services
    private(set) lazy var networkService: NetworkServiceProtocol = {
        let authAdapter = AuthRequestAdapter(authService: authService)
        let refresher = RefreshTokenInterceptor(authService: authService)
        return NetworkService(session: .shared, networkMonitor: networkMonitor, adapters: [authAdapter], tokenRefresher: refresher)
    }()

    // MARK: - Repositories
    private(set) lazy var productRepository: ProductRepository = ProductRepositoryImpl(network: networkService)
    private(set) lazy var categoryRepository: CategoryRepository = CategoryRepositoryImpl(network: networkService)

    // MARK: - UseCases
    private(set) lazy var fetchProductsUseCase: FetchProductsUseCase = DefaultFetchProductsUseCase(repository: productRepository)
    private(set) lazy var fetchProductsByCategoryUseCase: FetchProductsByCategoryUseCase = DefaultFetchProductsByCategoryUseCase(repository: productRepository)
    private(set) lazy var fetchCategoriesUseCase: FetchCategoriesUseCase = DefaultFetchCategoriesUseCase(repository: categoryRepository)
    private(set) lazy var authService: AuthServiceProtocol = AuthService.shared

    // MARK: - Builders
    func makeHome() -> UIViewController {
        let vm = HomeViewModel(fetchProductsUseCase: fetchProductsUseCase)
        return UINavigationController(rootViewController: HomeViewController(viewModel: vm))
    }

    func makeCategories() -> UIViewController {
        let vm = CategoryViewModel(fetchCategoriesUseCase: fetchCategoriesUseCase)
        return UINavigationController(rootViewController: CategoryViewController(viewModel: vm))
    }
}



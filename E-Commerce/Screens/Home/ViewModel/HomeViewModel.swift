//
//  HomeViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 15.07.2025.
//

import Foundation
import UIKit

protocol HomeViewHomeProtocol {
    func viewDidLoad()
}


final class HomeViewModel : HomeViewHomeProtocol {
    private let networkService : NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewDidLoad() {
        Task {
            try await fetch()
        }
    }
    
    
    //Fetch product data
    private func fetch() async throws -> [Product] {
        let products: [Product] = try await networkService.fetch(endpoint: APIEndpoint.products)
        print(products)
        return products
    }
}


//
//  CategoryViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 24.07.2025.
//

import Foundation
import UIKit

protocol CategoryViewModelProtocol {
    func viewDidLoad()
    var onCategoryFetched : (([Category]) -> Void)? { get set }
    func cellForItemAt(at indexPath : IndexPath, tableView : UITableView) -> UITableViewCell
    var onError : ((Error) -> Void)? { get set }
    func numberOfItemsInSection() -> Int
    func didSelectRow(at indexPath: IndexPath)
}

final class CategoryViewModel : CategoryViewModelProtocol {
    
    var onError: ((any Error) -> Void)?
    var onCategoryFetched: (([Category]) -> Void)?
    var category : [Category] = []
    
    private let networkService : NetworkServiceProtocol
    
    init(networkService : NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    
    
    private func fetchCategory() {
        Task {
            do {
                let category = try await fetch()
                
                await MainActor.run {
                    self.category = category
                    self.onCategoryFetched?(category)
                }
            } catch {
                await MainActor.run {
                    self.onError?(error)
                }
                print("Kategori alınırken hata oluştu: \(error)")
            }
        }
    }
    
    private func fetch() async throws -> [Category] {
        let category: [Category] = try await networkService.fetch(endpoint: APIEndpoint.category)
        
 
        return category
    }
    
    func viewDidLoad() {
        fetchCategory()
    }
    
    func cellForItemAt(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = category[indexPath.row]
        cell.textLabel?.text = category.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func numberOfItemsInSection() -> Int {
        return category.count
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        print(indexPath)
    }
    
    
}

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
}

final class CategoryViewModel : CategoryViewModelProtocol {
    
    var onError: ((Error) -> Void)?
    var onCategoryFetched: (([Category]) -> Void)?
    
      
    var category : [Category] = []
    
    private let fetchCategoriesUseCase: FetchCategoriesUseCase
    
    init(fetchCategoriesUseCase: FetchCategoriesUseCase) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    func categoryAt(index: Int) -> Category {
        return category[index] 
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
                print("Error fetching categories: \(error)")
            }
        }
    }
    
    private func fetch() async throws -> [Category] {
        try await fetchCategoriesUseCase.execute()
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
    

}

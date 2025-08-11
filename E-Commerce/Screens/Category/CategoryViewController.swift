//
//  CategoryViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 24.07.2025.
//

import UIKit
enum CategoryViewBuilder {
    static func generate() -> UIViewController {
        let viewModel = CategoryViewModel(fetchCategoriesUseCase: DIContainer.shared.fetchCategoriesUseCase)
        let viewController = CategoryViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

final class CategoryViewController: UIViewController {
    
    private var category: [Category] = []
    private let viewModel : CategoryViewModel
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: UIConstants.Identifiers.categoryCell)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = UIConstants.Texts.categoriesTitle
        
        setupLayout()
        viewModel.viewDidLoad()
   

        viewModel.onCategoryFetched = { [weak self] categories in
            DispatchQueue.main.async {
                self?.category = categories 
                self?.tableView.reloadData()
            }
        }
           
           viewModel.onError = { error in
               print("Kategori çekilirken hata: \(error.localizedDescription)")
           }

    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForItemAt(at: indexPath, tableView: tableView.self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < category.count else {
            print("Geçersiz index: \(indexPath.row)")
            return
        }

        let selectedCategory = category[indexPath.row]
        let categoryId = selectedCategory.id
        let categoryName = selectedCategory.name

        print("Tıklanan index: \(indexPath.row)")
        print("NavigationController var mı: \(navigationController != nil)")
        print("Gönderilen categoryId: \(categoryId), categoryName: \(categoryName)")

        let productVC = ProductViewBuilder.generate(categoryId: categoryId, categoryName: categoryName)
        navigationController?.pushViewController(productVC, animated: true)
    }


}

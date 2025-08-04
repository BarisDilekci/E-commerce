//
//  ProductListViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 24.07.2025.
//

import Foundation
import UIKit

enum ProductViewBuilder {
    static func generate(categoryId: Int, categoryName: String) -> UIViewController {
        let viewModel = ProductListViewModel(
            categoryId: categoryId,
            categoryName: categoryName,
            networkService: NetworkService.shared
        )
        let viewController = ProductListViewController(viewModel: viewModel)
        viewController.title = categoryName 
        return viewController
    }
}


final class ProductListViewController: UIViewController {
    
    private let viewModel: ProductListViewModel
    private var products: [Product] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemGroupedBackground
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    private lazy var emptyStateView: UILabel = {
        let label = UILabel()
        label.text = "Hiç ürün bulunamadı."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        bindViewModel()
        showLoading(true)
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = viewModel.categoryName 
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        
        view.addSubview(collectionView)
        view.addSubview(viewModel.loadingView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewModel.loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewModel.loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        
        collectionView.refreshControl = viewModel.refreshControl
        viewModel.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func bindViewModel() {
        viewModel.onProductsFetched = { [weak self] products in
            DispatchQueue.main.async {
                self?.showLoading(false)
                self?.viewModel.refreshControl.endRefreshing()
                self?.updateProducts(products)
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showLoading(false)
                self?.viewModel.refreshControl.endRefreshing()
                self?.showError(error)
            }
        }
        
        viewModel.onProductSelected = { [weak self] product in
            // Önce viewModel oluştur
            let productDetailViewModel = ProductDetailViewModel(product: product)
            // Sonra ViewController'ı oluştur
            let vc = ProductDetailViewController(viewModel: productDetailViewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func updateProducts(_ products: [Product]) {
        self.products = products
        emptyStateView.isHidden = !products.isEmpty
        collectionView.isHidden = products.isEmpty
        
        if !products.isEmpty {
            collectionView.reloadData()
            if collectionView.contentOffset.y == 0 {
                collectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            viewModel.loadingView.startAnimating()
            collectionView.isHidden = true
            emptyStateView.isHidden = true
        } else {
            viewModel.loadingView.stopAnimating()
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Hata",
            message: "Ürünler yüklenirken bir hata oluştu. Lütfen tekrar deneyin.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default) { [weak self] _ in
            self?.refreshData()
        })
        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func refreshData() {
        viewModel.refresh()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.cellForItemAt(at: indexPath, collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 12
        let availableWidth = collectionView.frame.width - (padding * 2) - spacing
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.6
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

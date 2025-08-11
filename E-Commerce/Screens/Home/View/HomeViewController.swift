//
//  ViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 14.06.2025.
//
import UIKit


enum HomeViewBuilder {
    static func generate() -> UIViewController {
        let viewModel = HomeViewModel(fetchProductsUseCase: DIContainer.shared.fetchProductsUseCase)
        let viewController = HomeViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModelProtocol
    
    private lazy var emptyStateView = EmptyStateView(message: UIConstants.Texts.emptyStateMessage)
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = UIConstants.Texts.searchPlaceholder
        sb.searchBarStyle = .minimal
        sb.backgroundColor = UIConstants.Colors.background
        sb.delegate = self
        return sb
    }()
    
    // Ana scroll view
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIConstants.Colors.background
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = viewModel.refreshControl
        return scrollView
    }()
    
    // Scroll view içindeki content container
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bannerView: PromoBannerView = {
        let v = PromoBannerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // Collection view'i scroll view içinde kullan
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = UIConstants.Layout.spacing
        layout.minimumInteritemSpacing = UIConstants.Layout.spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Layout.padding, bottom: UIConstants.Layout.padding, right: UIConstants.Layout.padding)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIConstants.Colors.background
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false // ScrollView içinde olduğu için kendi scroll'unu kapat
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return cv
    }()
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Lifecycle
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.onProductsFetched = { [weak self] in
            self?.loadingView.stopAnimating()
            self?.mainScrollView.refreshControl?.endRefreshing()
            self?.updateUI()
        }
        
        self.viewModel.onError = { [weak self] error in
            self?.loadingView.stopAnimating()
            self?.mainScrollView.refreshControl?.endRefreshing()
            let message: String
            if let netError = error as? NetworkError, netError == .noInternet {
                message = "Internet bağlantısı yok. Lütfen bağlantınızı kontrol edip tekrar deneyin."
            } else {
                message = UIConstants.Texts.errorMessage
            }
            AlertHelper.showErrorAlert(on: self!, title: UIConstants.Texts.errorTitle, message: message) {
                self?.viewModel.viewDidLoad()
            }
        }
        
        self.viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loadingView.startAnimating()
                    self?.mainScrollView.isHidden = true
                    self?.emptyStateView.isHidden = true
                } else {
                    self?.loadingView.stopAnimating()
                    self?.mainScrollView.isHidden = false
                }
            }
        }
        
        self.viewModel.onProductSelected = { [weak self] product in
            DispatchQueue.main.async {
                let detailVM = ProductDetailViewModel(product: product)
                let detailVC = ProductDetailViewController(viewModel: detailVM)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        
        self.viewModel.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIConstants.Colors.background
        title = UIConstants.Texts.productsTitle
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIConstants.Colors.tint
        
        // View hierarchy
        view.addSubview(searchBar)
        view.addSubview(mainScrollView)
        view.addSubview(loadingView)
        view.addSubview(emptyStateView)
        
        mainScrollView.addSubview(contentView)
        contentView.addSubview(bannerView)
        contentView.addSubview(collectionView)
        
        // Collection view height constraint'i dinamik olarak ayarlamak için
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            // Search bar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: UIConstants.Layout.searchBarHeight),
            
            // Main scroll view
            mainScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            // Banner view
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bannerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Collection view - banner'ın hemen altında
            collectionView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionViewHeightConstraint,
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty state view
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: UIConstants.Layout.emptyStateWidth),
            emptyStateView.heightAnchor.constraint(equalToConstant: UIConstants.Layout.emptyStateHeight)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func refreshData() {
        searchBar.text = ""
        viewModel.isSearching = false
        searchBar.resignFirstResponder()
        viewModel.viewDidLoad()
    }
    
    private func updateUI() {
        let productsCount = viewModel.numberOfItems()
        emptyStateView.isHidden = productsCount > 0
        mainScrollView.isHidden = productsCount == 0
        
        collectionView.reloadData()
        
        // Collection view'in yüksekliğini içerik boyutuna göre ayarla
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint.constant = contentHeight
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = viewModel.product(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let padding: CGFloat = 16
         let spacing: CGFloat = 12
         let availableWidth = collectionView.frame.width - (padding * 2) - spacing
         let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 2.1
         return CGSize(width: itemWidth, height: itemHeight)
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectProduct(at: indexPath.item)
    }
}

// MARK: - UISearchBar Delegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.viewModel.searchProducts(query: searchText)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchProducts(query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.isSearching = false
        searchBar.resignFirstResponder()
        viewModel.viewDidLoad()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

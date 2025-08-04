//
//  ViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 14.06.2025.
//
import UIKit


enum HomeViewBuilder {
    static func generate() -> UIViewController {
          let viewModel = HomeViewModel(networkService: NetworkService.shared)
          let viewController = HomeViewController(viewModel: viewModel)
         let navigationController = UINavigationController(rootViewController: viewController)
          return navigationController
      }
}

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    private var sliderImages: [String] = []
    private var isSearching = false
    private lazy var emptyStateView = EmptyStateView(message: "Gösterilecek ürün bulunamadı.")

    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Ürün ara..."
        sb.searchBarStyle = .minimal
        sb.backgroundColor = .systemGroupedBackground
        return sb
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.systemGroupedBackground
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliderData()
        setupUI()
        setupCollectionView()
        bindViewModel()
        
        showLoading(true)
        viewModel.viewDidLoad()
    }
    
    private func setupSliderData() {
        sliderImages = [
            "samsung",
            "apple",
            "Huawei"
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        title = "Ürünler"
        
        // Navigation bar styling
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(viewModel.loadingView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            // Ana Collection View
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loading View
            viewModel.loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewModel.loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Empty State View
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200),
            emptyStateView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        
        collectionView.register(SliderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SliderHeaderView.identifier)
        
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
    }
    
    private func updateProducts(_ products: [Product]) {
        self.products = products
        
        if isSearching {
            self.filteredProducts = products
        }
        
        let displayProducts = isSearching ? filteredProducts : products
        
        emptyStateView.isHidden = !displayProducts.isEmpty
        collectionView.isHidden = displayProducts.isEmpty
        
        if !displayProducts.isEmpty {
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
        searchBar.text = ""
        isSearching = false
        searchBar.resignFirstResponder()
        viewModel.viewDidLoad()
    }
    
    private func performSearch(with query: String) {
        if query.isEmpty {
            isSearching = false
            collectionView.reloadData()
            return
        }
        
        isSearching = true
        
        viewModel.searchProducts(query: query) { [weak self] searchResults in
            DispatchQueue.main.async {
                self?.filteredProducts = searchResults
                self?.collectionView.reloadData()
                
                // Empty state kontrolü
                self?.emptyStateView.isHidden = !searchResults.isEmpty
                self?.collectionView.isHidden = searchResults.isEmpty
            }
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredProducts.count
        } else {
            return viewModel.numberOfItemsInSection()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            let product = filteredProducts[indexPath.item]
            cell.configure(with: product)
            return cell
        } else {
            return viewModel.cellForItemAt(at: indexPath, collectionView: collectionView)
        }
    }
    
    // Header View (Slider)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SliderHeaderView.identifier, for: indexPath) as! SliderHeaderView
            headerView.configure(with: sliderImages)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isSearching {
            return CGSize(width: collectionView.frame.width, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 240) 
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 12
        let availableWidth = collectionView.frame.width - (padding * 2) - spacing
        let itemWidth = availableWidth / 2
        let itemHeight = itemWidth * 1.6
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct: Product
        
        if isSearching {
            selectedProduct = filteredProducts[indexPath.item]
        } else {
            selectedProduct = products[indexPath.item]
        }
        
        let productDetailViewModel = ProductDetailViewModel(product: selectedProduct)
        let detailViewController = ProductDetailViewController(viewModel: productDetailViewModel) //ProductDetailViewController(product: selectedProduct)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Anlık arama (debounce ile optimize edilebilir)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(delayedSearch), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func delayedSearch() {
        guard let searchText = searchBar.text else { return }
        performSearch(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        performSearch(with: searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        searchBar.resignFirstResponder()
        updateProducts(products)
    }

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - Slider Header View
class SliderHeaderView: UICollectionReusableView {
    static let identifier = "SliderHeaderView"
    
    private var sliderImages: [String] = []
    
    // Slider Collection View
    private let sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    // Page Control
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .lightGray
        pc.hidesForSinglePage = true
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemGroupedBackground
        
        addSubview(sliderCollectionView)
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            // Slider Collection View
            sliderCollectionView.topAnchor.constraint(equalTo: topAnchor),
            sliderCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sliderCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sliderCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // Page Control
            pageControl.topAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
        
        setupSliderCollectionView()
    }
    
    private func setupSliderCollectionView() {
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
    }
    
    func configure(with images: [String]) {
        self.sliderImages = images
        pageControl.numberOfPages = images.count
        sliderCollectionView.reloadData()
    }
}

// MARK: - SliderHeaderView Collection View Methods
extension SliderHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCell.identifier, for: indexPath) as! SliderCell
        cell.configure(with: sliderImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Slider item \(indexPath.item) tapped")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
 

}


import UIKit

final class FavoritesViewController: UIViewController {
    private let favoritesService: FavoritesServiceProtocol
    private var products: [Product] = []

    init(favoritesService: FavoritesServiceProtocol) {
        self.favoritesService = favoritesService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIConstants.Colors.background
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoriler"
        view.backgroundColor = UIConstants.Colors.background
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        reload()
    }

    func reload() {
        products = favoritesService.allFavorites()
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { products.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with: products[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 12
        let availableWidth = collectionView.frame.width - (padding * 2) - spacing
        let itemWidth = availableWidth / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.8)
    }
}



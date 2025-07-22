//
//  DetailViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 21.07.2025.
//
import Foundation
import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let product: Product
    private var selectedImageIndex = 0
    private var isFavorite = false
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: "ProductImageCell")
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = product.imageUrls.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.preferredIndicatorImage = UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 6))
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return pageControl
    }()
    
    private lazy var productInfoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 16
        return view
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = product.name
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var priceContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "₺\(String(format: "%.2f", discountedPrice))"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "₺\(String(format: "%.2f", product.price))"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .tertiaryLabel
        
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        attributedString.addAttribute(.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        label.isHidden = product.discount <= 0
        return label
    }()
    
    private lazy var discountBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.isHidden = product.discount <= 0
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "%\(Int(product.discount)) indirim"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var storeInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var storeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "storefront.circle.fill")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var storeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = product.store
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var storeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Satıcı"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var actionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .quaternarySystemFill
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.separator.cgColor
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        // Hover effect
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    private lazy var buyNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hemen Satın Al", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
        
        // Hover effect
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    private lazy var descriptionSection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Açıklama"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = product.description
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var specificationsSection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    private lazy var specificationsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Computed Properties
    private var discountedPrice: Double {
        return product.price * (1 - product.discount / 100)
    }
    
    // MARK: - Initializer
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(productInfoContainer)
        
        productInfoContainer.addSubview(productNameLabel)
        productInfoContainer.addSubview(priceContainer)
        productInfoContainer.addSubview(dividerView)
        productInfoContainer.addSubview(storeInfoView)
        productInfoContainer.addSubview(actionButtonsStackView)
        productInfoContainer.addSubview(descriptionSection)
        productInfoContainer.addSubview(specificationsSection)
        
        priceContainer.addSubview(currentPriceLabel)
        priceContainer.addSubview(originalPriceLabel)
        priceContainer.addSubview(discountBadge)
        
        storeInfoView.addSubview(storeIcon)
        storeInfoView.addSubview(storeLabel)
        storeInfoView.addSubview(storeSubtitleLabel)
        
        actionButtonsStackView.addArrangedSubview(addToCartButton)
        actionButtonsStackView.addArrangedSubview(buyNowButton)
        
        descriptionSection.addSubview(descriptionTitleLabel)
        descriptionSection.addSubview(descriptionLabel)
        
        specificationsSection.addSubview(specificationsStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor), // Bu değişti
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Image CollectionView
            imageCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 400),

            // Page Control
            pageControl.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -40),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Product Info Container
            productInfoContainer.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -24),
            productInfoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Product Name
            productNameLabel.topAnchor.constraint(equalTo: productInfoContainer.topAnchor, constant: 32),
            productNameLabel.leadingAnchor.constraint(equalTo: productInfoContainer.leadingAnchor, constant: 24),
            productNameLabel.trailingAnchor.constraint(equalTo: productInfoContainer.trailingAnchor, constant: -24),

            // Price Container
            priceContainer.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            priceContainer.leadingAnchor.constraint(equalTo: productInfoContainer.leadingAnchor, constant: 24),
            priceContainer.trailingAnchor.constraint(equalTo: productInfoContainer.trailingAnchor, constant: -24),
            priceContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            currentPriceLabel.topAnchor.constraint(equalTo: priceContainer.topAnchor),
            currentPriceLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),

            originalPriceLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            originalPriceLabel.leadingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor, constant: 12),

            discountBadge.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 8),
            discountBadge.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            discountBadge.heightAnchor.constraint(equalToConstant: 32),
            discountBadge.bottomAnchor.constraint(equalTo: priceContainer.bottomAnchor),

            dividerView.topAnchor.constraint(equalTo: priceContainer.bottomAnchor, constant: 24),
            dividerView.leadingAnchor.constraint(equalTo: productInfoContainer.leadingAnchor, constant: 24),
            dividerView.trailingAnchor.constraint(equalTo: productInfoContainer.trailingAnchor, constant: -24),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            storeInfoView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 24),
            storeInfoView.leadingAnchor.constraint(equalTo: productInfoContainer.leadingAnchor, constant: 24),
            storeInfoView.trailingAnchor.constraint(equalTo: productInfoContainer.trailingAnchor, constant: -24),
            storeInfoView.heightAnchor.constraint(equalToConstant: 50),

            storeIcon.centerYAnchor.constraint(equalTo: storeInfoView.centerYAnchor),
            storeIcon.leadingAnchor.constraint(equalTo: storeInfoView.leadingAnchor),
            storeIcon.widthAnchor.constraint(equalToConstant: 24),
            storeIcon.heightAnchor.constraint(equalToConstant: 24),

            storeLabel.topAnchor.constraint(equalTo: storeInfoView.topAnchor, constant: 4),
            storeLabel.leadingAnchor.constraint(equalTo: storeIcon.trailingAnchor, constant: 12),
            storeLabel.trailingAnchor.constraint(equalTo: storeInfoView.trailingAnchor),

            storeSubtitleLabel.topAnchor.constraint(equalTo: storeLabel.bottomAnchor),
            storeSubtitleLabel.leadingAnchor.constraint(equalTo: storeIcon.trailingAnchor, constant: 12),
            storeSubtitleLabel.trailingAnchor.constraint(equalTo: storeInfoView.trailingAnchor),
            storeSubtitleLabel.bottomAnchor.constraint(equalTo: storeInfoView.bottomAnchor, constant: -4),

            // Description Section
            descriptionSection.topAnchor.constraint(equalTo: storeInfoView.bottomAnchor, constant: 40), // Bu değişti
            descriptionSection.leadingAnchor.constraint(equalTo: productInfoContainer.leadingAnchor, constant: 24),
            descriptionSection.trailingAnchor.constraint(equalTo: productInfoContainer.trailingAnchor, constant: -24),

            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionSection.topAnchor),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: descriptionSection.leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: descriptionSection.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionSection.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionSection.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionSection.bottomAnchor),

            // Action Buttons - En alta yerleştirme
            actionButtonsStackView.topAnchor.constraint(equalTo: descriptionSection.bottomAnchor, constant: 32),
            actionButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            actionButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            actionButtonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24), // Bu eklendi

            addToCartButton.heightAnchor.constraint(equalToConstant: 56),
            buyNowButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    

        NSLayoutConstraint.activate([
            addToCartButton.heightAnchor.constraint(equalToConstant: 56),
            buyNowButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .label
        
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [shareButton, favoriteButton]
    }
    

    
    private func createSpecificationView(title: String, value: String) -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16)
        ])
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        let imageName = isFavorite ? "heart.fill" : "heart"
        let color = isFavorite ? UIColor.systemRed : UIColor.label
        
        navigationItem.rightBarButtonItems?.last?.image = UIImage(systemName: imageName)
        navigationItem.rightBarButtonItems?.last?.tintColor = color
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    @objc private func shareButtonTapped() {
        let activityVC = UIActivityViewController(activityItems: [product.name], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func addToCartButtonTapped() {
        // Animation
        UIView.animate(withDuration: 0.1, animations: {
            self.addToCartButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.addToCartButton.transform = .identity
            }
        }
        
        addToCartButton.setTitle("Sepete Eklendi ✓", for: .normal)
        addToCartButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        addToCartButton.layer.borderColor = UIColor.systemGreen.cgColor
        addToCartButton.setTitleColor(.systemGreen, for: .normal)
        addToCartButton.isEnabled = false
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.addToCartButton.setTitle("Sepete Ekle", for: .normal)
            self.addToCartButton.backgroundColor = .quaternarySystemFill
            self.addToCartButton.layer.borderColor = UIColor.separator.cgColor
            self.addToCartButton.setTitleColor(.label, for: .normal)
            self.addToCartButton.isEnabled = true
        }
    }
    
    @objc private func buyNowButtonTapped() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Buy now logic
        print("Buy now tapped")
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    @objc private func pageControlValueChanged() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedImageIndex = pageControl.currentPage
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
        cell.configure(with: product.imageUrls[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageCollectionView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            selectedImageIndex = pageIndex
            pageControl.currentPage = pageIndex
        }
    }
}

//
//  ProductCell.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 19.07.2025.z"
//
import UIKit

// MARK: - ProductCell
class ProductCell: UICollectionViewCell {
    
    static let identifier = "ProductCell"
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = Theme.Colors.contentBackground
        scrollView.layer.cornerRadius = Theme.Radii.large
        scrollView.layer.masksToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = Theme.Colors.tint
        pc.pageIndicatorTintColor = UIColor.systemGray4
        pc.hidesForSinglePage = true
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.titleM
        label.textColor = Theme.Colors.textPrimary
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.tint.withAlphaComponent(0.1)
        view.layer.cornerRadius = Theme.Radii.medium
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body
        label.textColor = Theme.Colors.tint
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        imageScrollView.contentOffset = .zero
        pageControl.currentPage = 0
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = Theme.Radii.large
        layer.masksToBounds = false
        
        addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
        addSubview(pageControl)
        addSubview(nameLabel)
        addSubview(priceLabelContainer)
        priceLabelContainer.addSubview(priceLabel)
        
        imageScrollView.delegate = self
        
        NSLayoutConstraint.activate([
            // Image ScrollView
            imageScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            imageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            
            // Image StackView inside ScrollView
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
            
            // Page Control
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 6),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 18),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Price Label Container
            priceLabelContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabelContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabelContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            
            // Price Label inside Container
            priceLabel.topAnchor.constraint(equalTo: priceLabelContainer.topAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: priceLabelContainer.leadingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: priceLabelContainer.trailingAnchor, constant: -12),
            priceLabel.bottomAnchor.constraint(equalTo: priceLabelContainer.bottomAnchor, constant: -6)
        ])
    }
    
    private func setupShadow() {
        layer.shadowColor = Theme.Shadows.cardShadowColor
        layer.shadowOffset = Theme.Shadows.cardShadowOffset
        layer.shadowRadius = Theme.Shadows.cardShadowRadius
        layer.shadowOpacity = Theme.Shadows.cardShadowOpacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = PriceFormatter.string(from: product.price)
        setupImages(urls: product.imageUrls)
    }
    
    private func setupImages(urls: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        guard !urls.isEmpty else {
            setupPlaceholder()
            return
        }
        
        pageControl.numberOfPages = urls.count
        
        for urlString in urls {
            let imageView = createImageView()
            imageStackView.addArrangedSubview(imageView)
            imageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor).isActive = true
            imageViews.append(imageView)
            ImageLoader.shared.load(urlString, into: imageView, placeholder: UIImage(systemName: "photo"))
        }
        
        layoutIfNeeded()
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Theme.Radii.large
        imageView.backgroundColor = Theme.Colors.muted
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupPlaceholder() {
        let imageView = createImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = UIColor.systemGray3
        imageStackView.addArrangedSubview(imageView)
        imageViews.append(imageView)
        pageControl.numberOfPages = 0
    }
    
    // Image loading moved to ImageLoader
}

// MARK: - UIScrollViewDelegate
extension ProductCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}

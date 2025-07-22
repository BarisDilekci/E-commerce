//
//  ProductCell.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 19.07.2025.z"
//
import Foundation
import UIKit


// MARK: - ProductCell
class ProductCell: UICollectionViewCell {
    
    static let identifier = "ProductCell"
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.systemGray6
        scrollView.layer.cornerRadius = 12
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = UIColor.systemGray4
        pc.hidesForSinglePage = true
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.1
        
        addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
        addSubview(pageControl)
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        imageScrollView.delegate = self
        
        NSLayoutConstraint.activate([
            // Image ScrollView
            imageScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            
            // Image StackView inside ScrollView
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
            
            // Page Control
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 16),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            // Price Label
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = "\(product.price)₺"
        setupImages(urls: product.imageUrls)
    }
    
    private func setupImages(urls: [String]) {
        // Temizle
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
            loadImage(into: imageView, from: urlString)
        }
        
        // ScrollView content size güncellemesi otomatik StackView ile yapılır
        layoutIfNeeded()
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupPlaceholder() {
        let imageView = createImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray3
        imageStackView.addArrangedSubview(imageView)
        imageViews.append(imageView)
        pageControl.numberOfPages = 0
    }
    
    private func loadImage(into imageView: UIImageView, from urlString: String) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                imageView.image = UIImage(systemName: "photo")
                imageView.tintColor = .systemGray3
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "photo")
                    imageView.tintColor = .systemGray3
                }
                return
            }
            DispatchQueue.main.async {
                imageView.alpha = 0
                imageView.image = image
                UIView.animate(withDuration: 0.25) {
                    imageView.alpha = 1
                }
            }
        }.resume()
    }
}

// MARK: - UIScrollViewDelegate
extension ProductCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}

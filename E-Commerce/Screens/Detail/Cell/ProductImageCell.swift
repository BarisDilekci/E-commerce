

//
//  ProductImageCell.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 21.07.2025.
//

import Foundation
import UIKit

class ProductImageCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        contentView.backgroundColor = Theme.Colors.contentBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ImageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(with imageUrl: String) {
        activityIndicator.startAnimating()
        
        // Reset image
        imageView.image = nil
        
        // Load image from URL
        loadImage(from: imageUrl)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            activityIndicator.stopAnimating()
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        ImageLoader.shared.load(url.absoluteString, into: imageView, placeholder: UIImage(systemName: "photo"))
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.stopAnimating()
    }
}

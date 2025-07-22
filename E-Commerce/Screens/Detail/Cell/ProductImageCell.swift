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
        contentView.backgroundColor = .systemBackground
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
        
        // Simple image loading - in a real app, you'd want to use a proper image loading library like Kingfisher or SDWebImage
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let data = data, let image = UIImage(data: data) {
                    self?.imageView.image = image
                } else {
                    // Show placeholder image on error
                    self?.imageView.image = UIImage(systemName: "photo")
                    self?.imageView.tintColor = .systemGray3
                }
            }
        }.resume()
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator.stopAnimating()
    }
}

//
//  SliderCell.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 25.07.2025.
//

import UIKit

// MARK: - Slider Cell
class SliderCell: UICollectionViewCell {
    static let identifier = "SliderCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with imageName: String) {
          // Asset dosyasından görsel yükleme
          imageView.image = UIImage(named: imageName)
          imageView.backgroundColor = .systemGray6 // Görsel yüklenemezse fallback renk
      }
}

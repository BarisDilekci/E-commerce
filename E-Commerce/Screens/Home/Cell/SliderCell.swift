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
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        
        // Gölge efekti
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        view.backgroundColor = .clear
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .systemGray6 // Placeholder için arkaplan
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            // Container view kenarlardan biraz boşluk bırakıyor
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // ImageView container içinde tam dolsun
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    func configure(with imageName: String) {
        // Asset dosyasından görsel yükleme
        imageView.image = UIImage(named: imageName)
    }
}

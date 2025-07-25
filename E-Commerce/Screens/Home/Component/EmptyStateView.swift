//
//  EmptyStateView.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 19.07.2025.
//

import UIKit

final class EmptyStateView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gösterilecek ürün bulunamadı."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    init(message: String = "Gösterilecek ürün bulunamadı.") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(message: String) {
        addSubview(messageLabel)
        messageLabel.text = message
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8)
        ])
    }
    
    func updateMessage(_ text: String) {
        messageLabel.text = text
    }
}

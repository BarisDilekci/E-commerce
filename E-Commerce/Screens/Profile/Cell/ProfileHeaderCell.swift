//
//  ProfileHeaderCell.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 1.08.2025.
//

import UIKit

// MARK: - ProfileHeaderCell
final class ProfileHeaderCell: UITableViewCell {
    static let identifier = "ProfileHeaderCell"
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            fullNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(fullName: String, email: String) {
        fullNameLabel.text = fullName
        emailLabel.text = email
    }
}

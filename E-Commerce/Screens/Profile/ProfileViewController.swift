//
//  ProfileViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 1.08.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill") // Placeholder
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let fullNameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Çıkış Yap", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hesabım"
        view.backgroundColor = .systemGroupedBackground
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        // Setup Scroll View
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(profileCardView)
        profileCardView.translatesAutoresizingMaskIntoConstraints = false
        profileCardView.addSubview(avatarImageView)
        profileCardView.addSubview(fullNameLabel)
        profileCardView.addSubview(usernameLabel)
        profileCardView.addSubview(emailLabel)
        
        contentView.addSubview(logoutButton)
        
        // Profile Card Layout
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profileCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileCardView.bottomAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20)
        ])
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: profileCardView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: profileCardView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        fullNameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            fullNameLabel.leadingAnchor.constraint(equalTo: profileCardView.leadingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: profileCardView.trailingAnchor, constant: -16)
        ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        usernameLabel.textColor = .secondaryLabel
        usernameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 6),
            usernameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor)
        ])
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor)
        ])
        
        // Logout Button Layout
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: 40),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func bindViewModel() {
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = "@\(viewModel.username)"
        emailLabel.text = viewModel.email
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Çıkış Yap", message: "Oturumu kapatmak istediğinize emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { _ in
            self.viewModel.logout()
            self.redirectToLogin()
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
    
    private func redirectToLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}

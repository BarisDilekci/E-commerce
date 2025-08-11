//
//  ProfileViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 1.08.2025.
//
import UIKit

final class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIConstants.Colors.background
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register cells
        tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: ProfileHeaderCell.identifier)
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.register(LogoutCell.self, forCellReuseIdentifier: LogoutCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Data Source
    private enum Section: Int, CaseIterable {
        case profile = 0
        case menu = 1
        case logout = 2
        
        var title: String? {
            switch self {
            case .profile: return nil
        case .menu: return nil
            case .logout: return nil
            }
        }
    }
    
    private let menuItems: [(title: String, icon: String, action: MenuAction)] = [
        (UIConstants.Texts.menuManageProfile, "person.circle", .manageProfile),
        (UIConstants.Texts.menuCampaigns, "gift", .campaigns),
        (UIConstants.Texts.menuShippingAddress, "location", .shippingAddress),
        (UIConstants.Texts.menuPrivacy, "lock.shield", .privacy),
        (UIConstants.Texts.menuAboutApp, "info.circle", .aboutApp),
        (UIConstants.Texts.menuHelp, "questionmark.circle", .help)
    ]
    
    private enum MenuAction {
        case manageProfile
        case campaigns
        case shippingAddress
        case privacy
        case aboutApp
        case help
        case logout
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = UIConstants.Texts.settingsTitle
        view.backgroundColor = UIConstants.Colors.background
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    private func handleMenuAction(_ action: MenuAction) {
        switch action {
        case .manageProfile:
            print("Navigate to Manage Profile")
            // let vc = ManageProfileViewController()
            // navigationController?.pushViewController(vc, animated: true)
            
        case .campaigns:
            print("Navigate to Campaigns")
            
        case .shippingAddress:
            print("Navigate to Shipping Address")
            
        case .privacy:
            print("Navigate to Privacy")
            
        case .aboutApp:
            print("Navigate to About App")
            
        case .help:
            print("Navigate to Help")
            
        case .logout:
            showLogoutAlert()
        }
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: UIConstants.Texts.logoutTitle, message: UIConstants.Texts.logoutMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.logout()
            self?.redirectToLogin()
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func redirectToLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .profile:
            return 1
        case .menu:
            return menuItems.count
        case .logout:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCell.identifier, for: indexPath) as! ProfileHeaderCell
            cell.configure(fullName: viewModel.fullName, email: viewModel.email)
            return cell
            
        case .menu:
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
            let menuItem = menuItems[indexPath.row]
            cell.configure(title: menuItem.title, iconName: menuItem.icon)
            return cell
            
        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoutCell.identifier, for: indexPath) as! LogoutCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Section(rawValue: section) else { return nil }
        return sectionType.title
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sectionType = Section(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .profile:
            // Profile cell tapped - could navigate to edit profile
            handleMenuAction(.manageProfile)
            
        case .menu:
            let menuItem = menuItems[indexPath.row]
            handleMenuAction(menuItem.action)
            
        case .logout:
            handleMenuAction(.logout)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = Section(rawValue: indexPath.section) else { return 44 }
        
        switch sectionType {
        case .profile:
            return 80
        case .menu, .logout:
            return 56
        }
    }
}


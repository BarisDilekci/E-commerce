//
//  MainTabbarController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 14.06.2025.
//

import Foundation
import UIKit

protocol MainTabbarProtocol: AnyObject {
    var tabBarController: UITabBarController { get }
    static func createTabBar() -> MainTabbarProtocol
}

class MainTabbarController: MainTabbarProtocol {
    
    private var isLoggedIn: Bool {
        UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    let tabBarController: UITabBarController
    
    private init() {
        self.tabBarController = UITabBarController()
        setupTabBar()
    }
    
    static func createTabBar() -> MainTabbarProtocol {
        return MainTabbarController()
    }
    
    private func setupTabBar() {
        let homeVC = DIContainer.shared.makeHome()
        homeVC.tabBarItem = UITabBarItem(title: "Ana Sayfa", image: UIImage(systemName: "house"), tag: 0)
        
        let favoritesVC = FavoritesViewController(favoritesService: FavoritesService())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "heart"), tag: 1)
        
        
        let categoryVC = CategoryViewBuilder.generate()
        categoryVC.tabBarItem = UITabBarItem(title: "Kategoriler", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        
        var viewControllers: [UIViewController] = [homeVC, categoryVC ,favoritesVC]
        
        if isLoggedIn {
            let profileVC = ProfileViewController()
            profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 2)
            viewControllers.append(profileVC)
        }
        
        tabBarController.viewControllers = viewControllers
    }
}

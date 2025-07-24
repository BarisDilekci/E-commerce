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
    
    let tabBarController: UITabBarController
    
    private init() {
        self.tabBarController = UITabBarController()
        setupTabBar()
    }
    
    static func createTabBar() -> MainTabbarProtocol {
        return MainTabbarController()
    }
    
    private func setupTabBar() {
        let homeVC = HomeViewBuilder.generate()
        homeVC.tabBarItem = UITabBarItem(title: "Ana Sayfa", image: UIImage(systemName: "house"), tag: 0)
        
        let categoryVC = CategoryViewBuilder.generate()
        categoryVC.tabBarItem = UITabBarItem(title: "Kategoriler", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        
        tabBarController.viewControllers = [homeVC, categoryVC]
    }
}

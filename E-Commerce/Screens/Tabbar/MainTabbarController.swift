//
//  MainTabbarController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 14.06.2025.
//

import Foundation
import UIKit

protocol MainTabbarProtocol : AnyObject {
    var tabBarController: UITabBarController? { get }
    static func createTabBar() -> MainTabbarProtocol
}


final class MainTabbarController: MainTabbarProtocol {
    var tabBarController: UITabBarController?
    
    static func createTabBar() -> any MainTabbarProtocol {
        return MainTabbarController()
    }
    
    
}

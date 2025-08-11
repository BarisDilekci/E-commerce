import UIKit

enum AppAppearance {
    static func apply() {
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = Theme.Colors.tint
        UINavigationBar.appearance().largeTitleTextAttributes = [ .foregroundColor: Theme.Colors.textPrimary ]
        UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: Theme.Colors.textPrimary ]

        UITableView.appearance().backgroundColor = Theme.Colors.background
        UICollectionView.appearance().backgroundColor = Theme.Colors.background
        UIView.appearance().tintColor = Theme.Colors.tint
    }
}



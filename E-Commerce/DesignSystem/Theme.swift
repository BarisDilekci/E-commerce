import UIKit

enum Theme {
    enum Colors {
        static let background = UIColor.systemGroupedBackground
        static let contentBackground = UIColor.systemBackground
        static let tint = UIColor.systemBlue
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        static let muted = UIColor.systemGray5
        static let separator = UIColor.separator
        static let danger = UIColor.systemRed
        static let success = UIColor.systemGreen
        static let warning = UIColor.systemOrange
    }

    enum Shadows {
        static let cardShadowColor = UIColor.black.cgColor
        static let cardShadowOpacity: Float = 0.08
        static let cardShadowRadius: CGFloat = 12
        static let cardShadowOffset = CGSize(width: 0, height: 6)
    }

    enum Radii {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 24
    }
}



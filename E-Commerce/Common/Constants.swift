//
//  Constants.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.08.2025.
//

import UIKit

enum UIConstants {
    enum Colors {
        static let background = UIColor.systemGroupedBackground
        static let tint = UIColor.systemBlue
    }
    
    enum Texts {
        static let productsTitle = "Ürünler"
        static let categoriesTitle = "Kategoriler"
        static let searchPlaceholder = "Ürün ara..."
        static let emptyStateMessage = "Gösterilecek ürün bulunamadı."
        static let errorTitle = "Hata"
        static let errorMessage = "Ürünler yüklenirken bir hata oluştu. Lütfen tekrar deneyin."
        static let retryButton = "Tekrar Dene"
        static let okButton = "Tamam"

        // Product Detail
        static let descriptionTitle = "Açıklama"
        static let sellerSubtitle = "Satıcı"
        static let addToCart = "Sepete Ekle"
        static let addedToCart = "Sepete Eklendi ✓"
        static let buyNow = "Hemen Satın Al"
        static let loginRequiredTitle = "Giriş Yapın"
        static let loginRequiredMessage = "Bu işlem için önce giriş yapmanız gerekmektedir."

        // Profile
        static let settingsTitle = "Ayarlar"
        static let menuManageProfile = "Profili Yönet"
        static let menuCampaigns = "Kampanyalar"
        static let menuShippingAddress = "Teslimat Adresi"
        static let menuPrivacy = "Gizlilik ve Güvenlik"
        static let menuAboutApp = "Uygulama Hakkında"
        static let menuHelp = "Yardım"
        static let logoutTitle = "Çıkış Yap"
        static let logoutMessage = "Oturumu kapatmak istediğinize emin misiniz?"

        // Login
        static let loginTitle = "Login to your account"
        static let loginSubtitle = "It's great to see you again."
        static let usernameLabel = "Username"
        static let usernamePlaceholder = "Enter your username"
        static let passwordLabel = "Password"
        static let passwordPlaceholder = "Enter your password"
        static let createAccountCTA = "Don't have an account? "
        static let createAccountAction = "Create account"
        static let login = "Login"
        static let continueAsGuest = "Continue as Guest"
        static let loginFailedTitle = "Login Failed"
    }
    
    enum Layout {
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 12
        static let searchBarHeight: CGFloat = 50
        static let emptyStateWidth: CGFloat = 200
        static let emptyStateHeight: CGFloat = 120
        static let sliderHeight: CGFloat = 240
        static let refreshControlTopInset: CGFloat = 8
    }
    
    enum Images {
        static let sliderItems = ["samsung", "apple", "Huawei"]
    }

    enum Identifiers {
        static let categoryCell = "categoryCell"
        static let productImageCell = "ProductImageCell"
    }

    enum Home {
        static let categoryChips = [
            "Technology", "Fashion", "Sports", "Supermarket", "Home", "Toys"
        ]
    }
}

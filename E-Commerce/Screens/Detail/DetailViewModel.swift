//
//  DetailViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 31.07.2025.
//

import Foundation

class ProductDetailViewModel {

    let product: Product
    var isFavorite: Bool = false
    var selectedImageIndex: Int = 0

    var isLoggedIn: Bool {
        UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    var discountedPrice: Double {
        product.price * (1 - product.discount / 100)
    }

    var hasDiscount: Bool {
        product.discount > 0
    }

    var imageCount: Int {
        product.imageUrls.count
    }

    init(product: Product) {
        self.product = product
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

    func performActionIfLoggedIn(action: () -> Void, onNotLoggedIn: (() -> Void)? = nil) {
        if isLoggedIn {
            action()
        } else {
            onNotLoggedIn?()
        }
    }
}

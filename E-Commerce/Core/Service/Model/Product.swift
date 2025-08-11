//
//  Product.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.07.2025.
//

import Foundation

struct Product: Codable {
    let id: Int?
    let name: String
    let price: Double
    let description: String
    let discount: Double
    let store: String
    let imageUrls: [String]
    let category_id: Int

    enum CodingKeys: String, CodingKey {
        case id, name, price, description, discount, store
        case category_id = "category_id"
        case imageUrls = "image_urls"
    }
}

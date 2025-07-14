//
//  Product.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.07.2025.
//

import Foundation


struct Product: Decodable {
    let id: Int?          // ? ile opsiyonel yaptık
    let name: String
    let price: Double
    let discount: Double
    let store: String
    let imageUrls: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, price, discount, store
        case imageUrls = "image_urls"
    }
}

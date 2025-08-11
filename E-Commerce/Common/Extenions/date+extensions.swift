//
//  date+extensions.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation

extension Date {
    var iso8601String: String {
        ISO8601DateFormatter().string(from: self)
    }
}

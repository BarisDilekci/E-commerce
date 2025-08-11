//
//  AppConfig.swift
//  E-Commerce
//
//  Created by AI Assistant on 11.08.2025.
//

import Foundation

enum AppEnvironment {
    case development
    case production
}

struct AppConfig {
    let environment: AppEnvironment
    let apiBaseURLString: String

    static let current: AppConfig = {
        // You can switch environments via build configurations or scheme arguments
        #if DEBUG
        return AppConfig(environment: .development, apiBaseURLString: "http://localhost:8080/api/v1")
        #else
        return AppConfig(environment: .production, apiBaseURLString: "https://api.yourdomain.com/api/v1")
        #endif
    }()
}



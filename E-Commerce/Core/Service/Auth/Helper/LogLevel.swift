//
//  LogLevel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 4.08.2025.
//

import Foundation


protocol LoggerProtocol {
    func log(_ message: String, level: LogLevel)
}

enum LogLevel: String {
    case debug = "🐛 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
}

final class ConsoleLogger: LoggerProtocol {
    func log(_ message: String, level: LogLevel) {
        print("[\(level.rawValue)] \(message)")
    }
}

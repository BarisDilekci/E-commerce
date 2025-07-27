//
//  AuthError.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation

// MARK: - AuthError
enum AuthError: Error, LocalizedError, Equatable {
    case invalidCredentials
    case networkError
    case serverError(Int)
    case tokenExpired
    case invalidToken
    case userNotFound
    case emailAlreadyExists
    case weakPassword
    case accountLocked
    case tooManyAttempts
    case invalidEmail
    case userNotActivated
    case sessionExpired
    case registerError(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        case .networkError:
            return "Network connection error"
        case .serverError(let code):
            return "Server error occurred (Code: \(code))"
        case .tokenExpired:
            return "Authentication token has expired"
        case .invalidToken:
            return "Invalid authentication token"
        case .userNotFound:
            return "User not found"
        case .emailAlreadyExists:
            return "Email address already exists"
        case .weakPassword:
            return "Password is too weak"
        case .accountLocked:
            return "Account is locked due to security reasons"
        case .tooManyAttempts:
            return "Too many login attempts. Please try again later"
        case .invalidEmail:
            return "Invalid email format"
        case .userNotActivated:
            return "User account is not activated"
        case .sessionExpired:
            return "Session has expired. Please login again"
        case .registerError(let message):
            return message
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidCredentials:
            return "The provided credentials do not match any user account"
        case .networkError:
            return "Unable to connect to the server"
        case .serverError:
            return "The server encountered an internal error"
        case .tokenExpired:
            return "The authentication token has exceeded its validity period"
        case .invalidToken:
            return "The authentication token format is invalid or corrupted"
        case .userNotFound:
            return "No user account exists with the provided information"
        case .emailAlreadyExists:
            return "An account with this email address already exists"
        case .weakPassword:
            return "Password does not meet security requirements"
        case .accountLocked:
            return "Account has been temporarily locked for security"
        case .tooManyAttempts:
            return "Login attempt limit exceeded for security protection"
        case .invalidEmail:
            return "Email format does not meet validation requirements"
        case .userNotActivated:
            return "Account registration is complete but not yet activated"
        case .sessionExpired:
            return "Current session is no longer valid"
        case .unknown:
            return "An unexpected error occurred"
        case .registerError(_):
            return "This email is already registered"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidCredentials:
            return "Please check your username and password and try again"
        case .networkError:
            return "Please check your internet connection and try again"
        case .serverError:
            return "Please try again later or contact support if the problem persists"
        case .tokenExpired, .sessionExpired:
            return "Please login again to continue"
        case .invalidToken:
            return "Please logout and login again"
        case .userNotFound:
            return "Please verify your account information or create a new account"
        case .emailAlreadyExists:
            return "Please use a different email address or login to existing account"
        case .weakPassword:
            return "Please choose a stronger password with at least 8 characters, including uppercase, lowercase, numbers, and special characters"
        case .accountLocked:
            return "Please contact support to unlock your account"
        case .tooManyAttempts:
            return "Please wait 15 minutes before trying again"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .userNotActivated:
            return "Please check your email for activation instructions"
        case .unknown:
            return "Please try again or contact support"
        case .registerError(_):
            return "This email is already registeredb"
        }
    }
    
    // MARK: - Helper Properties
    var isRetryable: Bool {
        switch self {
        case .networkError, .serverError, .unknown:
            return true
        default:
            return false
        }
    }
    
    var requiresReauthentication: Bool {
        switch self {
        case .tokenExpired, .invalidToken, .sessionExpired:
            return true
        default:
            return false
        }
    }
    
    var httpStatusCode: Int? {
        switch self {
        case .invalidCredentials:
            return 401
        case .userNotFound:
            return 404
        case .emailAlreadyExists:
            return 409
        case .serverError(let code):
            return code
        case .tooManyAttempts:
            return 429
        default:
            return nil
        }
    }
}

// MARK: - AuthError Extensions
extension AuthError {
    
    /// Creates AuthError from HTTP status code
    static func from(httpStatusCode: Int, message: String? = nil) -> AuthError {
        switch httpStatusCode {
        case 401:
            return .invalidCredentials
        case 404:
            return .userNotFound
        case 409:
            return .emailAlreadyExists
        case 429:
            return .tooManyAttempts
        case 500...599:
            return .serverError(httpStatusCode)
        default:
            return .unknown(message ?? "HTTP Error \(httpStatusCode)")
        }
    }
    
    /// Creates AuthError from URLError
    static func from(urlError: URLError) -> AuthError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut:
            return .networkError
        default:
            return .unknown(urlError.localizedDescription)
        }
    }
}

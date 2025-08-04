//
//  LoginViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//


import Foundation
import UIKit

// MARK: - LoginViewModelDelegate
protocol LoginViewModelProtocol: AnyObject {
    func loginDidStart()
    func loginDidSucceed(response: LoginResponse)
    func loginDidFail(error: Error)
    func shouldNavigateToMainApp()
    func shouldHighlightField(_ field: LoginViewModel.InputField, isError: Bool)
    func shouldUpdateLoginButtonState(isEnabled: Bool)
}

// MARK: - LoginViewModel
final class LoginViewModel {
    
    // MARK: - Types
    enum InputField {
        case username
        case password
    }
    
    enum ValidationError: LocalizedError {
        case emptyUsername
        case emptyPassword
        
        var errorDescription: String? {
            switch self {
            case .emptyUsername:
                return "Please enter your username"
            case .emptyPassword:
                return "Please enter your password"
            }
        }
    }
    
    // MARK: - Properties
    weak var delegate: LoginViewModelProtocol?
    private let authService: AuthServiceProtocol
    
    private(set) var username: String = ""
    private(set) var password: String = ""
    private(set) var isLoading: Bool = false
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func checkLoginStatus() {
        if authService.isLoggedIn {
            print("✅ Kullanıcı zaten giriş yapmış, ana ekrana yönlendiriliyor...")
            
            if let user = authService.getCurrentUser() {
                print("👤 Current user: \(user.username)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.delegate?.shouldNavigateToMainApp()
            }
        }
    }
    
    func updateUsername(_ username: String) {
        self.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        clearFieldErrors()
        updateLoginButtonState()
    }
    
    func updatePassword(_ password: String) {
        self.password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        clearFieldErrors()
        updateLoginButtonState()
    }
    
    func login() {
        print("🔑 Login attempt started")
        
        do {
            try validateInputs()
        } catch let error as ValidationError {
            handleValidationError(error)
            return
        } catch {
            delegate?.loginDidFail(error: error)
            return
        }
        
        clearFieldErrors()
        
        isLoading = true
        delegate?.loginDidStart()
        
        print("🔐 Attempting login with username: \(username)")
        
        authService.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    print("✅ Login successful: \(response.message)")
                    print("👤 Welcome \(response.user.firstName) \(response.user.lastName)!")
                    self?.delegate?.loginDidSucceed(response: response)
                    
                case .failure(let error):
                    print("❌ Login failed: \(error.localizedDescription)")
                    self?.handleLoginError(error)
                }
            }
        }
    }
    
    func continueAsGuest() {
        print("👤 Continuing as guest")
        delegate?.shouldNavigateToMainApp()
    }
    
    // MARK: - Private Methods
    private func validateInputs() throws {
        if username.isEmpty {
            throw ValidationError.emptyUsername
        }
        
        if password.isEmpty {
            throw ValidationError.emptyPassword
        }
    }
    
    private func handleValidationError(_ error: ValidationError) {
        switch error {
        case .emptyUsername:
            delegate?.shouldHighlightField(.username, isError: true)
        case .emptyPassword:
            delegate?.shouldHighlightField(.password, isError: true)
        }
        
        delegate?.loginDidFail(error: error)
    }
    
    private func handleLoginError(_ error: Error) {
        if let authError = error as? AuthError {
            switch authError {
            case .invalidCredentials:
                delegate?.shouldHighlightField(.username, isError: true)
                delegate?.shouldHighlightField(.password, isError: true)
            default:
                break
            }
        } else if let authError = error as? AuthError {
            switch authError {
            case .invalidCredentials:
                delegate?.shouldHighlightField(.username, isError: true)
                delegate?.shouldHighlightField(.password, isError: true)
            default:
                break
            }
        } else if error.localizedDescription.contains("401") {
            delegate?.shouldHighlightField(.username, isError: true)
            delegate?.shouldHighlightField(.password, isError: true)
        }
        
        delegate?.loginDidFail(error: error)
    }
    
    private func clearFieldErrors() {
        delegate?.shouldHighlightField(.username, isError: false)
        delegate?.shouldHighlightField(.password, isError: false)
    }
    
    private func updateLoginButtonState() {
        let isEnabled = !username.isEmpty && !password.isEmpty
        delegate?.shouldUpdateLoginButtonState(isEnabled: isEnabled)
    }
    
    // MARK: - Helper Methods
    func getErrorMessage(from error: Error) -> String {
        if let authError = error as? AuthError {
            return authError.localizedDescription
        }
        
        if let authError = error as? AuthError {
            return authError.localizedDescription
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection. Please check your connection."
            case .timedOut:
                return "Request timed out. Please try again."
            case .cannotConnectToHost:
                return "Cannot connect to server. Please try again later."
            default:
                return "Network error. Please try again."
            }
        }
        
        if let validationError = error as? ValidationError {
            return validationError.localizedDescription ?? "Validation error occurred."
        }
        
        if error.localizedDescription.contains("401") {
            return "Invalid username or password."
        }
        
        return "Login failed. Please try again."
    }
}

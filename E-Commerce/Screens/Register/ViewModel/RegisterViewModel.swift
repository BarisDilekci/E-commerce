//
//  RegisterViewModel.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 28.07.2025.
//

import Foundation

protocol RegisterViewModelProtocol: AnyObject {
    func registerButtonStateChanged(isEnabled: Bool)
    func loadingStateChanged(isLoading: Bool)
    func passwordVisibilityChanged(isVisible: Bool)
    func registrationCompleted()
    func registrationFailed(error: String)
}

final class RegisterViewModel {
    
    // MARK: - Properties
    weak var delegate: RegisterViewModelProtocol?
    
    var firstName: String = "" {
        didSet { validateForm() }
    }
    
    var lastName: String = "" {
        didSet { validateForm() }
    }
    
    var username: String = "" {
        didSet { validateForm() }
    }
    
    var email: String = "" {
        didSet { validateForm() }
    }
    
    var password: String = "" {
        didSet { validateForm() }
    }
    
    private var isPasswordVisible: Bool = false
    private var isLoading: Bool = false {
        didSet {
            delegate?.loadingStateChanged(isLoading: isLoading)
            validateForm()
        }
    }
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        delegate?.passwordVisibilityChanged(isVisible: isPasswordVisible)
    }
    
    func register() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        authService.register(
            username: username,
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    print("✅ Registration successful: \(response.message)")
                    self?.delegate?.registrationCompleted()
                    
                case .failure(let error):
                    print("❌ Registration failed: \(error.localizedDescription)")
                    self?.delegate?.registrationFailed(error: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateForm() {
        let isFormValid = !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                         !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                         !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                         !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                         !password.isEmpty &&
                         !isLoading
        
        delegate?.registerButtonStateChanged(isEnabled: isFormValid)
    }
    
    private func validateInputs() -> Bool {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedFirstName.isEmpty else {
            delegate?.registrationFailed(error: "Please enter your first name")
            return false
        }
        
        guard !trimmedLastName.isEmpty else {
            delegate?.registrationFailed(error: "Please enter your last name")
            return false
        }
        
        guard !trimmedUsername.isEmpty else {
            delegate?.registrationFailed(error: "Please choose a username")
            return false
        }
        
        guard isValidUsername(trimmedUsername) else {
            delegate?.registrationFailed(error: "Username can only contain letters, numbers, and underscores (3-20 characters)")
            return false
        }
        
        guard !trimmedEmail.isEmpty else {
            delegate?.registrationFailed(error: "Please enter your email address")
            return false
        }
        
        guard isValidEmail(trimmedEmail) else {
            delegate?.registrationFailed(error: "Please enter a valid email address")
            return false
        }
        
        guard !password.isEmpty else {
            delegate?.registrationFailed(error: "Please enter a password")
            return false
        }
        
        guard password.count >= 6 else {
            delegate?.registrationFailed(error: "Password must be at least 6 characters long")
            return false
        }
        
        guard isValidPassword(password) else {
            delegate?.registrationFailed(error: "Password must contain at least one uppercase letter, one lowercase letter, and one number")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

//
//  LoginViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailContainerView = UIView()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordContainerView = UIView()
    private let showPasswordButton = UIButton(type: .custom)
    
    private let createAccountButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)
    private let guestButton = UIButton(type: .system)
    
    // MARK: - Loading Indicator
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - ViewModel
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupConstraints()
        setupActions()
        setupLoadingIndicator()
        setupKeyboardHandling()
        
        viewModel.checkLoginStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title Label
        titleLabel.text = "Login to your account"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "It's great to see you again."
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Email Label
        emailLabel.text = "Username"
        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emailLabel.textColor = .label
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)
        
        // Email Container
        emailContainerView.backgroundColor = .systemGray6
        emailContainerView.layer.cornerRadius = 12
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor.clear.cgColor
        emailContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailContainerView)
        
        // Email TextField
        emailTextField.placeholder = "Enter your username"
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.textColor = .label
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .default
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailContainerView.addSubview(emailTextField)
        
        // Password Label
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        passwordLabel.textColor = .label
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordLabel)
        
        // Password Container
        passwordContainerView.backgroundColor = .systemGray6
        passwordContainerView.layer.cornerRadius = 12
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = UIColor.clear.cgColor
        passwordContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordContainerView)
        
        // Password TextField
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.textColor = .label
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordContainerView.addSubview(passwordTextField)
        
        // Show Password Button
        showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        passwordContainerView.addSubview(showPasswordButton)
        
        // Create Account Button
        let dontHaveText = "Don't have an account? "
        let createText = "Create account"
        let attributedString = NSMutableAttributedString(string: dontHaveText + createText)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: dontHaveText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: dontHaveText.count, length: createText.count))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: dontHaveText.count, length: createText.count))
        
        createAccountButton.setAttributedTitle(attributedString, for: .normal)
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createAccountButton.contentHorizontalAlignment = .center
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createAccountButton)
        
        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemGray4
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loginButton.layer.cornerRadius = 12
        loginButton.isEnabled = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginButton)
        
        // Guest Button
        let continueText = "Continue as "
        let guestText = "Guest"
        let guestAttributedString = NSMutableAttributedString(string: continueText + guestText)
        
        guestAttributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: continueText.count))
        guestAttributedString.addAttribute(.foregroundColor, value: UIColor.systemGray, range: NSRange(location: continueText.count, length: guestText.count))
        guestAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: continueText.count, length: guestText.count))
        
        guestButton.setAttributedTitle(guestAttributedString, for: .normal)
        guestButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        guestButton.contentHorizontalAlignment = .center
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(guestButton)
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        loginButton.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }
    
    private func setupKeyboardHandling() {
        // Keyboard notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Email Container
            emailContainerView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Email TextField
            emailTextField.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -16),
            emailTextField.centerYAnchor.constraint(equalTo: emailContainerView.centerYAnchor),
            
            // Password Label
            passwordLabel.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 24),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Password Container
            passwordContainerView.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Password TextField
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor, constant: -8),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
            
            // Show Password Button
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -16),
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            showPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Create Account Button
            createAccountButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 16),
            createAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            createAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            createAccountButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Guest Button
            guestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            guestButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            guestButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            guestButton.heightAnchor.constraint(equalToConstant: 40),
            guestButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)
        
        // Text field delegates for login button state
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: - Helper Methods
    private func setLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            loginButton.setTitle("", for: .normal)
            loginButton.isEnabled = false
            view.isUserInteractionEnabled = false
        } else {
            loadingIndicator.stopAnimating()
            loginButton.setTitle("Login", for: .normal)
            view.isUserInteractionEnabled = true
        }
    }
    
    private func highlightTextField(_ field: LoginViewModel.InputField, isError: Bool) {
        let containerView = field == .username ? emailContainerView : passwordContainerView
        
        UIView.animate(withDuration: 0.3) {
            containerView.layer.borderColor = isError ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
        }
    }
    
    private func updateLoginButtonState(isEnabled: Bool) {
        if isEnabled {
            loginButton.backgroundColor = .systemBlue
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = .systemGray4
            loginButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func createAccountTapped() {
        print("Create account tapped")
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func loginTapped() {
        viewModel.login()
    }
    
    @objc private func guestTapped() {
        viewModel.continueAsGuest()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.updateUsername(textField.text ?? "")
        } else if textField == passwordTextField {
            viewModel.updatePassword(textField.text ?? "")
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func navigateToMainApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        let tabbar = MainTabbarController.createTabBar().tabBarController
        sceneDelegate.window?.rootViewController = tabbar
        
        // Smooth transition
        UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            if loginButton.isEnabled {
                viewModel.login()
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Clear error highlights when user focuses on field
        let field: LoginViewModel.InputField = textField == emailTextField ? .username : .password
        highlightTextField(field, isError: false)
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelProtocol {
    func loginDidStart() {
        setLoadingState(true)
    }
    
    func loginDidSucceed(response: LoginResponse) {
        setLoadingState(false)
        
        // Success feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        navigateToMainApp()
    }
    
    func loginDidFail(error: Error) {
        setLoadingState(false)
        
        // Error feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        let errorMessage = viewModel.getErrorMessage(from: error)
        showAlert(title: "Login Failed", message: errorMessage)
    }
    
    func shouldNavigateToMainApp() {
        navigateToMainApp()
    }
    
    func shouldHighlightField(_ field: LoginViewModel.InputField, isError: Bool) {
        highlightTextField(field, isError: isError)
    }
    
    func shouldUpdateLoginButtonState(isEnabled: Bool) {
        updateLoginButtonState(isEnabled: isEnabled)
    }
}

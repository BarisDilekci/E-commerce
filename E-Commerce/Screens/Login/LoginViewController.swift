//
//  LoginViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Texts.loginTitle
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Texts.loginSubtitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Texts.usernameLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = UIConstants.Texts.usernamePlaceholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .label
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Texts.passwordLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = UIConstants.Texts.passwordPlaceholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .label
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let base = UIConstants.Texts.createAccountCTA
        let action = UIConstants.Texts.createAccountAction
        let attr = NSMutableAttributedString(string: base + action)
        attr.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: base.count))
        attr.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: base.count, length: action.count))
        attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: base.count, length: action.count))
        button.setAttributedTitle(attr, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(UIConstants.Texts.login, for: .normal)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var guestButton: UIButton = {
        let button = UIButton(type: .system)
        let base = "Continue as "
        let guest = "Guest"
        let attr = NSMutableAttributedString(string: base + guest)
        attr.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: base.count))
        attr.addAttribute(.foregroundColor, value: UIColor.systemGray, range: NSRange(location: base.count, length: guest.count))
        attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: base.count, length: guest.count))
        button.setAttributedTitle(attr, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Loading Indicator
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailContainerView)
        emailContainerView.addSubview(emailTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordContainerView)
        passwordContainerView.addSubview(passwordTextField)
        passwordContainerView.addSubview(showPasswordButton)
        contentView.addSubview(createAccountButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(guestButton)
    }
    
    private func setupLoadingIndicator() {
        loginButton.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }
    
    private func setupKeyboardHandling() {
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
            loginButton.setTitle(UIConstants.Texts.login, for: .normal)
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
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        navigateToMainApp()
    }
    
    func loginDidFail(error: Error) {
        setLoadingState(false)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        let errorMessage = viewModel.getErrorMessage(from: error)
        showAlert(title: UIConstants.Texts.loginFailedTitle, message: errorMessage)
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

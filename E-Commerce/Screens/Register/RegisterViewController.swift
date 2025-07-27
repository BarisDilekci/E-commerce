//
//  RegisterViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // First Name
    private let firstNameLabel = UILabel()
    private let firstNameTextField = UITextField()
    private let firstNameContainerView = UIView()
    
    // Last Name
    private let lastNameLabel = UILabel()
    private let lastNameTextField = UITextField()
    private let lastNameContainerView = UIView()
    
    // Username
    private let usernameLabel = UILabel()
    private let usernameTextField = UITextField()
    private let usernameContainerView = UIView()
    
    // Email
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailContainerView = UIView()
    
    // Password
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordContainerView = UIView()
    private let showPasswordButton = UIButton(type: .custom)
    
    // Buttons
    private let registerButton = UIButton(type: .system)
    private let loginRedirectButton = UIButton(type: .system)
    
    private let orLabel = UILabel()
    
    // MARK: - Properties
    private let viewModel: RegisterViewModel
    
    // MARK: - Initialization
    init(viewModel: RegisterViewModel = RegisterViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = RegisterViewModel()
        super.init(coder: coder)
        self.viewModel.delegate = self
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        
        // Keyboard handling
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title Label
        titleLabel.text = "Create your account"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Please fill in the information below."
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Setup all form fields
        setupFormField(label: firstNameLabel, textField: firstNameTextField, container: firstNameContainerView,
                      labelText: "First Name", placeholder: "Enter your first name")
        
        setupFormField(label: lastNameLabel, textField: lastNameTextField, container: lastNameContainerView,
                      labelText: "Last Name", placeholder: "Enter your last name")
        
        setupFormField(label: usernameLabel, textField: usernameTextField, container: usernameContainerView,
                      labelText: "Username", placeholder: "Choose a username")
        
        setupFormField(label: emailLabel, textField: emailTextField, container: emailContainerView,
                      labelText: "Email", placeholder: "Enter your email address")
        
        // Email specific settings
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        
        // Username specific settings
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        
        // Password Field (special handling)
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        passwordLabel.textColor = .label
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordLabel)
        
        passwordContainerView.backgroundColor = .systemGray6
        passwordContainerView.layer.cornerRadius = 12
        passwordContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordContainerView)
        
        passwordTextField.placeholder = "Create a strong password"
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.textColor = .label
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordContainerView.addSubview(passwordTextField)
        
        showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        passwordContainerView.addSubview(showPasswordButton)
        
        // Register Button
        registerButton.setTitle("Create Account", for: .normal)
        registerButton.backgroundColor = .systemGray4
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        registerButton.layer.cornerRadius = 12
        registerButton.isEnabled = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(registerButton)
        
        // Login redirect button
        let alreadyText = "Already have an account? "
        let loginText = "Sign in"
        let attributedString = NSMutableAttributedString(string: alreadyText + loginText)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: alreadyText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: alreadyText.count, length: loginText.count))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: alreadyText.count, length: loginText.count))
        
        loginRedirectButton.setAttributedTitle(attributedString, for: .normal)
        loginRedirectButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginRedirectButton.contentHorizontalAlignment = .center
        loginRedirectButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginRedirectButton)
        
        // Or Label
        orLabel.text = "Or"
        orLabel.font = UIFont.systemFont(ofSize: 14)
        orLabel.textColor = .secondaryLabel
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(orLabel)
    }
    
    private func setupFormField(label: UILabel, textField: UITextField, container: UIView,
                               labelText: String, placeholder: String) {
        // Label
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        // Container
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        // TextField
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .label
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(textField)
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // First Name
            firstNameLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            firstNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            firstNameContainerView.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
            firstNameContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            firstNameContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            firstNameTextField.leadingAnchor.constraint(equalTo: firstNameContainerView.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: firstNameContainerView.trailingAnchor, constant: -16),
            firstNameTextField.centerYAnchor.constraint(equalTo: firstNameContainerView.centerYAnchor),
            
            // Last Name
            lastNameLabel.topAnchor.constraint(equalTo: firstNameContainerView.bottomAnchor, constant: 20),
            lastNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            lastNameContainerView.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 8),
            lastNameContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            lastNameContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            lastNameContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTextField.leadingAnchor.constraint(equalTo: lastNameContainerView.leadingAnchor, constant: 16),
            lastNameTextField.trailingAnchor.constraint(equalTo: lastNameContainerView.trailingAnchor, constant: -16),
            lastNameTextField.centerYAnchor.constraint(equalTo: lastNameContainerView.centerYAnchor),
            
            // Username
            usernameLabel.topAnchor.constraint(equalTo: lastNameContainerView.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            usernameContainerView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            usernameContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            usernameContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameTextField.leadingAnchor.constraint(equalTo: usernameContainerView.leadingAnchor, constant: 16),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameContainerView.trailingAnchor, constant: -16),
            usernameTextField.centerYAnchor.constraint(equalTo: usernameContainerView.centerYAnchor),
            
            // Email
            emailLabel.topAnchor.constraint(equalTo: usernameContainerView.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailContainerView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -16),
            emailTextField.centerYAnchor.constraint(equalTo: emailContainerView.centerYAnchor),
            
            // Password
            passwordLabel.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            passwordContainerView.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor, constant: -8),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
            
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -16),
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            showPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Register Button
            registerButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 32),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Login Redirect Button
            loginRedirectButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            loginRedirectButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Or Label
            orLabel.topAnchor.constraint(equalTo: loginRedirectButton.bottomAnchor, constant: 24),
            orLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            orLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginRedirectButton.addTarget(self, action: #selector(loginRedirectTapped), for: .touchUpInside)
        
        // Text field delegates for ViewModel binding
        firstNameTextField.addTarget(self, action: #selector(firstNameChanged), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameChanged), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility() {
        viewModel.togglePasswordVisibility()
    }
    
    @objc private func registerTapped() {
        viewModel.register()
    }
    
    @objc private func loginRedirectTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func firstNameChanged() {
        viewModel.firstName = firstNameTextField.text ?? ""
    }
    
    @objc private func lastNameChanged() {
        viewModel.lastName = lastNameTextField.text ?? ""
    }
    
    @objc private func usernameChanged() {
        viewModel.username = usernameTextField.text ?? ""
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToLoginScreen() {
        // Registration başarılı olduğunda login ekranına yönlendir
        let alert = UIAlertController(title: "Success", message: "Registration successful! Please sign in with your new account.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign In", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - RegisterViewModelDelegate
extension RegisterViewController: RegisterViewModelProtocol {
    func registerButtonStateChanged(isEnabled: Bool) {
        registerButton.isEnabled = isEnabled
        registerButton.backgroundColor = isEnabled ? .systemBlue : .systemGray4
    }
    
    func loadingStateChanged(isLoading: Bool) {
        registerButton.setTitle(isLoading ? "Creating Account..." : "Create Account", for: .normal)
        registerButton.isEnabled = !isLoading
        
        // Disable all text fields during loading
        [firstNameTextField, lastNameTextField, usernameTextField, emailTextField, passwordTextField].forEach {
            $0.isEnabled = !isLoading
        }
    }
    
    func passwordVisibilityChanged(isVisible: Bool) {
        passwordTextField.isSecureTextEntry = !isVisible
        let imageName = isVisible ? "eye" : "eye.slash"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func registrationCompleted() {
        navigateToLoginScreen()
    }
    
    func registrationFailed(error: String) {
        showAlert(message: error)
    }
}

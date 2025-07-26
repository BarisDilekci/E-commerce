//
//  RegisterViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
    private let googleRegisterButton = UIButton(type: .system)
    private let facebookRegisterButton = UIButton(type: .system)
    
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
        
        // Google Register Button
        googleRegisterButton.setTitle("  Sign up with Google", for: .normal)
        googleRegisterButton.setTitleColor(.label, for: .normal)
        googleRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        googleRegisterButton.backgroundColor = .systemBackground
        googleRegisterButton.layer.cornerRadius = 12
        googleRegisterButton.layer.borderWidth = 1
        googleRegisterButton.layer.borderColor = UIColor.systemGray4.cgColor
        
        if let googleImage = createGoogleIcon() {
            googleRegisterButton.setImage(googleImage, for: .normal)
            googleRegisterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        }
        
        googleRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(googleRegisterButton)
        
        // Facebook Register Button
        facebookRegisterButton.setTitle("  Sign up with Facebook", for: .normal)
        facebookRegisterButton.setTitleColor(.white, for: .normal)
        facebookRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        facebookRegisterButton.backgroundColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        facebookRegisterButton.layer.cornerRadius = 12
        
        facebookRegisterButton.setImage(UIImage(systemName: "f.circle.fill"), for: .normal)
        facebookRegisterButton.tintColor = .white
        facebookRegisterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        
        facebookRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(facebookRegisterButton)
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
            
            // Google Register Button
            googleRegisterButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 24),
            googleRegisterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            googleRegisterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            googleRegisterButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Facebook Register Button
            facebookRegisterButton.topAnchor.constraint(equalTo: googleRegisterButton.bottomAnchor, constant: 16),
            facebookRegisterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            facebookRegisterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            facebookRegisterButton.heightAnchor.constraint(equalToConstant: 50),
            facebookRegisterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginRedirectButton.addTarget(self, action: #selector(loginRedirectTapped), for: .touchUpInside)
        googleRegisterButton.addTarget(self, action: #selector(googleRegisterTapped), for: .touchUpInside)
        facebookRegisterButton.addTarget(self, action: #selector(facebookRegisterTapped), for: .touchUpInside)
        
        // Text field delegates for register button state
        [firstNameTextField, lastNameTextField, usernameTextField, emailTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    // MARK: - Helper Methods
    private func createGoogleIcon() -> UIImage? {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.systemBlue.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.white
        ]
        let text = "G"
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func updateRegisterButtonState() {
        let hasFirstName = !(firstNameTextField.text?.isEmpty ?? true)
        let hasLastName = !(lastNameTextField.text?.isEmpty ?? true)
        let hasUsername = !(usernameTextField.text?.isEmpty ?? true)
        let hasEmail = !(emailTextField.text?.isEmpty ?? true)
        let hasPassword = !(passwordTextField.text?.isEmpty ?? true)
        
        let allFieldsFilled = hasFirstName && hasLastName && hasUsername && hasEmail && hasPassword
        
        if allFieldsFilled {
            registerButton.backgroundColor = .systemBlue
            registerButton.isEnabled = true
        } else {
            registerButton.backgroundColor = .systemGray4
            registerButton.isEnabled = false
        }
    }
    
    private func validateInputs() -> Bool {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "Please enter your first name")
            return false
        }
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(message: "Please enter your last name")
            return false
        }
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(message: "Please choose a username")
            return false
        }
        
        guard let email = emailTextField.text, !email.isEmpty, email.contains("@") else {
            showAlert(message: "Please enter a valid email address")
            return false
        }
        
        guard let password = passwordTextField.text, !password.isEmpty, password.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters long")
            return false
        }
        
        return true
    }
    
    private func createRegistrationData() -> [String: String] {
        return [
            "username": usernameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "password": passwordTextField.text ?? "",
            "first_name": firstNameTextField.text ?? "",
            "last_name": lastNameTextField.text ?? ""
        ]
    }
    
    private func performRegistration(with data: [String: String]) {
        registerButton.setTitle("Creating Account...", for: .normal)
        registerButton.isEnabled = false
        
        // API çağrısı simülasyonu
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Registration başarılı - normalde API response'u burada handle ederiz
            print("Registration Data:", data)
            
            // Auto-login after successful registration
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(data["email"], forKey: "userEmail")
            UserDefaults.standard.set(data["username"], forKey: "username")
            UserDefaults.standard.set(data["first_name"], forKey: "firstName")
            UserDefaults.standard.set(data["last_name"], forKey: "lastName")
            
            self.navigateToMainApp()
        }
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func registerTapped() {
        guard validateInputs() else { return }
        
        let registrationData = createRegistrationData()
        performRegistration(with: registrationData)
    }
    
    @objc private func loginRedirectTapped() {
        // Login ekranına geri dön
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func googleRegisterTapped() {
        print("Google register tapped")
        // Google ile kayıt ol functionality
    }
    
    @objc private func facebookRegisterTapped() {
        print("Facebook register tapped")
        // Facebook ile kayıt ol functionality
    }
    
    @objc private func textFieldDidChange() {
        updateRegisterButtonState()
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

// MARK: - Navigation Example
/*
// Login ekranından register ekranına geçmek için:

@objc private func registerRedirectTapped() {
    let registerVC = RegisterViewController()
    navigationController?.pushViewController(registerVC, animated: true)
}
*/

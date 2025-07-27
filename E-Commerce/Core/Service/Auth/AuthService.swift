//
//  AuthService.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation
import CryptoKit


// MARK: - Models
struct LoginRequest: Codable {
    let usernameOrEmail: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case usernameOrEmail = "username_or_email"
        case password
    }
    
    // Backend'iniz username_or_email field'ı bekliyor
    init(usernameOrEmail: String, password: String) {
        self.usernameOrEmail = usernameOrEmail
        self.password = password
    }
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case username, email, password
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(username: String, email: String, password: String, firstName: String, lastName: String) {
        self.username = username
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct RegisterResponse: Codable {
    let message: String
}


struct JWTClaims: Codable {
    let userId: Int64
    let username: String
    let email: String
    let exp: Int64
    let iat: Int64
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username, email, exp, iat
    }
}


// MARK: - AuthServiceProtocol
protocol AuthServiceProtocol {
    var isLoggedIn: Bool { get }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
    func register(username: String, email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void)
    func logout()
    func getToken() -> String?
    func getCurrentUser() -> User?
    func getTokenRemainingTime() -> TimeInterval?
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void)
    func getAuthHeaders() -> [String: String]
}

// MARK: - AuthService Implementation
final class AuthService: AuthServiceProtocol {
    static let shared: AuthServiceProtocol = AuthService()
    
    // Keychain keys
    private let tokenKey = "auth_token"
    private let tokenExpiryKey = "token_expiry"
    private let userKey = "current_user"
    
    // MARK: - Dependencies (for testability)
    private let keychainHelper: KeychainHelperProtocol
    private let userDefaults: UserDefaults
    private let urlSession: URLSessionProtocol
    
    // MARK: - Initialization
    private init(
        keychainHelper: KeychainHelperProtocol = KeychainHelper.shared,
        userDefaults: UserDefaults = .standard,
        urlSession: URLSessionProtocol = URLSession.shared
    ) {
        self.keychainHelper = keychainHelper
        self.userDefaults = userDefaults
        self.urlSession = urlSession
    }
    
    // Test için factory method
    static func create(
        keychainHelper: KeychainHelperProtocol = KeychainHelper.shared,
        userDefaults: UserDefaults = .standard,
        urlSession: URLSessionProtocol = URLSession.shared
    ) -> AuthServiceProtocol {
        return AuthService(
            keychainHelper: keychainHelper,
            userDefaults: userDefaults,
            urlSession: urlSession
        )
    }
    
    // MARK: - AuthServiceProtocol Implementation
    var isLoggedIn: Bool {
        guard let token = keychainHelper.get(tokenKey) else { return false }
        
        if isJWTTokenExpired(token) {
            logout()
            return false
        }
        
        return true
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = APIEndpoint.login.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let loginRequest = LoginRequest(usernameOrEmail: username, password: password)
        
        print("🔐 Login attempt:")
        print("   📍 URL: \(url)")
        print("   👤 Username/Email: \(username)")
        print("   🔑 Password length: \(password.count)")
        
        var request = URLRequest(url: url)
        request.httpMethod = APIEndpoint.login.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        do {
            let requestData = try JSONEncoder().encode(loginRequest)
            request.httpBody = requestData
            
            if let requestString = String(data: requestData, encoding: .utf8) {
                print("   📤 Request JSON: \(requestString)")
            }
        } catch {
            print("❌ JSON encoding error: \(error)")
            completion(.failure(error))
            return
        }
        
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("   📥 HTTP Status: \(httpResponse.statusCode)")
                    
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("   📄 Response: \(responseString)")
                    }
                    
                    if httpResponse.statusCode == 401 {
                        completion(.failure(AuthError.invalidCredentials))
                        return
                    } else if httpResponse.statusCode != 200 {
                        completion(.failure(AuthError.serverError(httpResponse.statusCode)))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    
                    print("✅ Login successful!")
                    print("   🎉 Message: \(loginResponse.message)")
                    print("   👤 User: \(loginResponse.user.username)")
                    
                    self?.saveToken(loginResponse.token)
                    self?.saveUser(loginResponse.user)
                    
                    if let expiryDate = self?.getExpiryDateFromJWT(loginResponse.token) {
                        self?.userDefaults.set(expiryDate, forKey: self?.tokenExpiryKey ?? "")
                        print("   ⏰ Token expires: \(expiryDate)")
                    }
                    
                    completion(.success(loginResponse))
                } catch {
                    print("❌ JSON parsing error: \(error)")
                    if let decodingError = error as? DecodingError {
                        print("   Decoding details: \(decodingError)")
                    }
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func register(username: String, email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = APIEndpoint.register.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let registerRequest = RegisterRequest(
            username: username,
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        
        print("📝 Register attempt:")
        print("   📍 URL: \(url)")
        print("   👤 Username: \(username)")
        print("   📧 Email: \(email)")
        print("   👤 Name: \(firstName) \(lastName)")
        print("   🔑 Password length: \(password.count)")
        
        var request = URLRequest(url: url)
        request.httpMethod = APIEndpoint.register.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        do {
            let requestData = try JSONEncoder().encode(registerRequest)
            request.httpBody = requestData
            
            if let requestString = String(data: requestData, encoding: .utf8) {
                print("   📤 Request JSON: \(requestString)")
            }
        } catch {
            print("❌ JSON encoding error: \(error)")
            completion(.failure(error))
            return
        }
        
        urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("   📥 HTTP Status: \(httpResponse.statusCode)")
                    
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("   📄 Response: \(responseString)")
                    }
                    
                    if httpResponse.statusCode == 422 {
                        // Backend'den gelen error mesajını parse et
                        if let data = data,
                           let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorMessage = errorResponse["error"] as? String {
                            completion(.failure(AuthError.registrationError(errorMessage)))
                        } else {
                            completion(.failure(AuthError.registrationError("Kayıt sırasında hata oluştu")))
                        }
                        return
                    } else if httpResponse.statusCode == 400 {
                        completion(.failure(AuthError.invalidRequest))
                        return
                    } else if httpResponse.statusCode != 201 {
                        completion(.failure(AuthError.serverError(httpResponse.statusCode)))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    
                    print("✅ Registration successful!")
                    print("   🎉 Message: \(registerResponse.message)")
                    
                    completion(.success(registerResponse))
                } catch {
                    print("❌ JSON parsing error: \(error)")
                    if let decodingError = error as? DecodingError {
                        print("   Decoding details: \(decodingError)")
                    }
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func logout() {
        _ = keychainHelper.delete(tokenKey)
        userDefaults.removeObject(forKey: tokenExpiryKey)
        userDefaults.removeObject(forKey: userKey)
        print("🚪 Kullanıcı çıkış yaptı")
    }
    
    func getToken() -> String? {
        guard let token = keychainHelper.get(tokenKey) else { return nil }
        
        if isJWTTokenExpired(token) {
            logout()
            return nil
        }
        return token
    }
    
    func getCurrentUser() -> User? {
        guard let token = keychainHelper.get(tokenKey),
              !isJWTTokenExpired(token) else {
            logout()
            return nil
        }
        
        guard let userData = userDefaults.data(forKey: userKey) else { return nil }
        return try? JSONDecoder().decode(User.self, from: userData)
    }
    
    func getTokenRemainingTime() -> TimeInterval? {
        guard let token = keychainHelper.get(tokenKey),
              let claims = decodeJWTClaims(from: token) else {
            return nil
        }
        
        let expiryDate = Date(timeIntervalSince1970: TimeInterval(claims.exp))
        let remaining = expiryDate.timeIntervalSinceNow
        return remaining > 0 ? remaining : 0
    }
    
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        // Refresh token endpoint'inizi çağırın
        // Bu Go backend'inizde implement etmeniz gerekebilir
        print("🔄 Token refresh - Backend'de refresh endpoint gerekli")
        completion(.failure(AuthError.networkError))
    }
    
    func getAuthHeaders() -> [String: String] {
        guard let token = getToken() else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }
    
    // MARK: - JWT Token Methods
    private func isJWTTokenExpired(_ token: String) -> Bool {
        guard let claims = decodeJWTClaims(from: token) else { return true }
        
        let currentTimestamp = Int64(Date().timeIntervalSince1970)
        let isExpired = currentTimestamp >= claims.exp
        
        if isExpired {
            print("⏰ JWT Token süresi doldu")
        }
        
        return isExpired
    }
    
    private func getExpiryDateFromJWT(_ token: String) -> Date? {
        guard let claims = decodeJWTClaims(from: token) else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(claims.exp))
    }
    
    private func decodeJWTClaims(from token: String) -> JWTClaims? {
        let segments = token.components(separatedBy: ".")
        guard segments.count == 3 else { return nil }
        
        let payloadSegment = segments[1]
        
        // Base64 padding ekle
        var base64 = payloadSegment
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddingLength = 4 - (base64.count % 4)
        if paddingLength < 4 {
            base64 += String(repeating: "=", count: paddingLength)
        }
        
        guard let data = Data(base64Encoded: base64) else { return nil }
        
        do {
            return try JSONDecoder().decode(JWTClaims.self, from: data)
        } catch {
            print("JWT decode hatası: \(error)")
            return nil
        }
    }
    
    private func saveToken(_ token: String) {
        let success = keychainHelper.save(token, for: tokenKey)
        if !success {
            print("⚠️ Token Keychain'e kaydedilemedi")
        } else {
            print("✅ JWT Token Keychain'e kaydedildi")
        }
    }
    
    private func saveUser(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            userDefaults.set(userData, forKey: userKey)
            print("✅ User bilgisi kaydedildi")
        }
    }
}

// MARK: - Network Error Handling
extension AuthService {
    enum AuthError: LocalizedError {
        case invalidCredentials
        case networkError
        case tokenExpired
        case serverError(Int)
        case invalidRequest
        case registrationError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "Kullanıcı adı veya şifre hatalı"
            case .networkError:
                return "Ağ bağlantı hatası"
            case .tokenExpired:
                return "Oturum süresi doldu"
            case .serverError(let code):
                return "Sunucu hatası: \(code)"
            case .invalidRequest:
                return "Geçersiz istek"
            case .registrationError(let message):
                return message
            }
        }
    }
}

// MARK: - Supporting Protocols for Testing

protocol KeychainHelperProtocol {
    func save(_ value: String, for key: String) -> Bool
    func get(_ key: String) -> String?
    func delete(_ key: String) -> Bool
}

extension KeychainHelper: KeychainHelperProtocol {}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: - Mock Implementation for Testing
final class MockAuthService: AuthServiceProtocol {
    var mockToken: String?
    var mockUser: User?
    var loginCalled = false
    var registerCalled = false
    var shouldReturnError = false
    var mockRemainingTime: TimeInterval?
    
    init(mockToken: String? = nil, mockUser: User? = nil, shouldReturnError: Bool = false) {
        self.mockToken = mockToken
        self.mockUser = mockUser
        self.shouldReturnError = shouldReturnError
    }
    
    var isLoggedIn: Bool {
        return mockToken != nil && !shouldReturnError
    }
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        loginCalled = true
        
        if shouldReturnError {
            completion(.failure(AuthError.invalidCredentials))
        } else {
            let user = mockUser ?? User(
                id: 1,
                username: "testuser",
                email: "test@example.com",
                firstName: "Test",
                lastName: "User",
                createdAt: ISO8601DateFormatter().string(from: Date()),
                updatedAt: ISO8601DateFormatter().string(from: Date())
            )
            
            let response = LoginResponse(
                message: "Login successful",
                token: "mock.jwt.token",
                user: user
            )
            
            self.mockToken = response.token
            self.mockUser = user
            
            completion(.success(response))
        }
    }
    
    func register(username: String, email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        registerCalled = true
        
        if shouldReturnError {
            completion(.failure(AuthError.registerError("Kullanıcı adı zaten mevcut")))
        } else {
            let response = RegisterResponse(message: "User registered successfully")
            completion(.success(response))
        }
    }
    
    func logout() {
        mockToken = nil
        mockUser = nil
    }
    
    func getToken() -> String? {
        return shouldReturnError ? nil : mockToken
    }
    
    func getCurrentUser() -> User? {
        return shouldReturnError ? nil : mockUser
    }
    
    func getTokenRemainingTime() -> TimeInterval? {
        return mockRemainingTime
    }
    
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(AuthError.networkError))
        } else {
            let newToken = "refreshed.jwt.token"
            mockToken = newToken
            completion(.success(newToken))
        }
    }
    
    func getAuthHeaders() -> [String: String] {
        guard let token = getToken() else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }
}

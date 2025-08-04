//
//  AuthService.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 26.07.2025.
//

import Foundation
import CryptoKit

extension KeychainHelper: KeychainHelperProtocol {}

// MARK: - Protocols for URLSession mocking

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask)
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

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
    
    private let tokenService: TokenServiceProtocol
    private var storage: UserStorageProtocol
    private let urlSession: URLSessionProtocol
    private let logger: LoggerProtocol

    init(
        tokenService: TokenServiceProtocol = TokenService(),
        storage: UserStorageProtocol = UserStorage(),
        urlSession: URLSessionProtocol = URLSession.shared,
        logger: LoggerProtocol = ConsoleLogger()
    ) {
        self.tokenService = tokenService
        self.storage = storage
        self.urlSession = urlSession
        self.logger = logger
    }

    var isLoggedIn: Bool {
        guard storage.isLoggedIn, let token = storage.getToken(), !tokenService.isExpired(token: token) else {
            logout()
            return false
        }
        return true
    }

    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = APIEndpoint.login.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let loginRequest = LoginRequest(usernameOrEmail: username, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = APIEndpoint.login.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            logger.log("Encoding error: \(error)", level: .error)
            completion(.failure(error))
            return
        }

        urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.logger.log("Network error: \(error)", level: .error)
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    self.logger.log("Invalid response", level: .error)
                    completion(.failure(NSError(domain: "Invalid response", code: 0)))
                    return
                }

                if httpResponse.statusCode != 200 {
                    self.logger.log("Server error: \(httpResponse.statusCode)", level: .warning)
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode)))
                    return
                }

                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    self.storage.saveToken(loginResponse.token)
                    self.storage.saveUser(loginResponse.user)
                    self.storage.isLoggedIn = true
                    self.logger.log("Login success for user: \(loginResponse.user.username)", level: .info)
                    completion(.success(loginResponse))
                } catch {
                    self.logger.log("Parsing error: \(error)", level: .error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func register(username: String, email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = APIEndpoint.register.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        let registerRequest = RegisterRequest(username: username, email: email, password: password, firstName: firstName, lastName: lastName)
        var request = URLRequest(url: url)
        request.httpMethod = APIEndpoint.register.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(registerRequest)
        } catch {
            logger.log("Encoding error: \(error)", level: .error)
            completion(.failure(error))
            return
        }

        urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.logger.log("Network error: \(error)", level: .error)
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    self.logger.log("Invalid response", level: .error)
                    completion(.failure(NSError(domain: "Invalid response", code: 0)))
                    return
                }

                if httpResponse.statusCode != 201 {
                    self.logger.log("Registration failed: \(httpResponse.statusCode)", level: .warning)
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode)))
                    return
                }

                do {
                    let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    self.logger.log("Registration successful", level: .info)
                    completion(.success(registerResponse))
                } catch {
                    self.logger.log("Parsing error: \(error)", level: .error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func logout() {
        storage.deleteToken()
        storage.deleteUser()
        storage.isLoggedIn = false
        logger.log("User logged out", level: .info)
    }

    func getToken() -> String? {
        guard let token = storage.getToken(), !tokenService.isExpired(token: token) else {
            logout()
            return nil
        }
        return token
    }

    func getCurrentUser() -> User? {
        storage.getUser()
    }

    func getTokenRemainingTime() -> TimeInterval? {
        guard let token = getToken(), let expiry = tokenService.expiryDate(token: token) else { return nil }
        return max(0, expiry.timeIntervalSinceNow)
    }

    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        logger.log("Token refresh requested - not implemented", level: .debug)
        completion(.failure(NSError(domain: "Not implemented", code: 0)))
    }

    func getAuthHeaders() -> [String: String] {
        guard let token = getToken() else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }
}

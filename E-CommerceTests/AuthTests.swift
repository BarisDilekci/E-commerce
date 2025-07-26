//
//  AuthTests.swift
//  E-CommerceTests
//
//  Created by Barış Dilekçi on 26.07.2025.
//
import Testing
import Foundation
@testable import E_Commerce

struct AuthTests {
    
    @Test("Login should succeed with valid credentials")
    func testLoginSuccessful() async throws {
        let mockService = MockAuthService()
        
        let username = "testuser"
        let password = "password"
        
        let result = await withCheckedContinuation { continuation in
            mockService.login(username: username, password: password) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success(let response):
            #expect(response.token == "mock.jwt.token", "Token should match mock token")
            #expect(response.user.username == username, "Username should match input")
            #expect(response.message == "Login successful", "Success message should be present")
            #expect(mockService.loginCalled == true, "Login method should be called")
            #expect(mockService.isLoggedIn == true, "User should be logged in after successful login")
        case .failure(let error):
            Issue.record("Login should not fail, but got error: \(error)")
        }
    }
    
    @Test("Login should fail with invalid credentials")
    func testLoginFailure() async throws {
        let mockService = MockAuthService(shouldReturnError: true)
        
        let username = "wronguser"
        let password = "wrongpassword"
        
        let result = await withCheckedContinuation { continuation in
            mockService.login(username: username, password: password) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success:
            Issue.record("Login should fail with invalid credentials")
        case .failure(let error):
            #expect(error is AuthError, "Error should be of type AuthError")
            #expect(mockService.loginCalled == true, "Login method should be called")
            #expect(mockService.isLoggedIn == false, "User should not be logged in after failed login")
        }
    }
    
    @Test("Current user should be available after login")
    func testCurrentUserAvailability() async throws {
        let mockUser = User(
            id: 123,
            username: "testuser123",
            email: "testuser123@example.com",
            firstName: "Test",
            lastName: "User",
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
        
        let mockService = MockAuthService(mockUser: mockUser)
        
        let result = await withCheckedContinuation { continuation in
            mockService.login(username: "testuser123", password: "password") { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success:
            let currentUser = mockService.getCurrentUser()
            #expect(currentUser != nil, "Current user should be available")
            #expect(currentUser?.username == mockUser.username, "Username should match")
            #expect(currentUser?.email == mockUser.email, "Email should match")
        case .failure(let error):
            Issue.record("Login should succeed, but got error: \(error)")
        }
    }
    
    @Test("Logout should clear token and user data")
    func testLogout() async throws {
        let mockService = MockAuthService(mockToken: "initial.token")
        
        let result = await withCheckedContinuation { continuation in
            mockService.login(username: "testuser", password: "password") { result in
                continuation.resume(returning: result)
            }
        }
        
        #expect(try result.get().token == "mock.jwt.token", "Initial login should succeed")
        #expect(mockService.isLoggedIn == true, "User should be logged in")
        

        mockService.logout()
        
        #expect(mockService.getToken() == nil, "Token should be nil after logout")
        #expect(mockService.getCurrentUser() == nil, "Current user should be nil after logout")
        #expect(mockService.isLoggedIn == false, "User should not be logged in after logout")
    }
    
    @Test("Multiple login attempts should work correctly")
    func testMultipleLoginAttempts() async throws {
        let mockService = MockAuthService()
        
        let firstResult = await withCheckedContinuation { continuation in
            mockService.login(username: "user1", password: "pass1") { result in
                continuation.resume(returning: result)
            }
        }
        
        #expect(try firstResult.get().user.username == "testuser", "First login should succeed")
        
        mockService.logout()
        
        let secondResult = await withCheckedContinuation { continuation in
            mockService.login(username: "user2", password: "pass2") { result in
                continuation.resume(returning: result)
            }
        }
        
        #expect(try secondResult.get().user.username == "testuser", "Second login should succeed")
        #expect(mockService.isLoggedIn == true, "User should be logged in after second login")
    }
}

// MARK: - AuthServiceProtocol (Add this to your main code if not exists)
protocol AuthServiceProtocol {
    var isLoggedIn: Bool { get }
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
    func getToken() -> String?
    func getCurrentUser() -> User?
    func logout()
}

// MARK: - MockAuthService
final class MockAuthService: AuthServiceProtocol {
    var mockToken: String?
    var mockUser: User?
    var loginCalled = false
    var shouldReturnError = false

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

    func getToken() -> String? {
        return shouldReturnError ? nil : mockToken
    }

    func getCurrentUser() -> User? {
        return shouldReturnError ? nil : mockUser
    }

    func logout() {
        mockToken = nil
        mockUser = nil
    }
}

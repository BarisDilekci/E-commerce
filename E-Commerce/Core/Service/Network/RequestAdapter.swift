import Foundation

protocol RequestAdapter {
    func adapt(_ request: URLRequest) -> URLRequest
}

struct AuthRequestAdapter: RequestAdapter {
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol) { self.authService = authService }

    func adapt(_ request: URLRequest) -> URLRequest {
        var req = request
        let headers = authService.getAuthHeaders()
        headers.forEach { key, value in req.setValue(value, forHTTPHeaderField: key) }
        return req
    }
}



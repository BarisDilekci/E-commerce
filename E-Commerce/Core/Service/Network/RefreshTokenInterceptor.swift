import Foundation

final class RefreshTokenInterceptor: RequestAdapter, TokenRefreshing {
    private let authService: AuthServiceProtocol
    private let session: URLSession

    init(authService: AuthServiceProtocol, session: URLSession = .shared) {
        self.authService = authService
        self.session = session
    }

    func adapt(_ request: URLRequest) -> URLRequest {
        // No-op at request time; actual refresh flow should be handled on 401 responses.
        return request
    }

    func shouldRefresh(response: HTTPURLResponse) -> Bool {
        return response.statusCode == 401
    }

    func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        authService.refreshToken { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}



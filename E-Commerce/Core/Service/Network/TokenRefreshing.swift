import Foundation

protocol TokenRefreshing {
    func shouldRefresh(response: HTTPURLResponse) -> Bool
    func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void)
}



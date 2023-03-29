import Foundation

private extension String {
    static let bearerToken = "bearerToken"
}

final class OAuth2TokenStorage {
    var token: String? {
        get {
            userDefaults.string(forKey: .bearerToken)
        }
        set {
            userDefaults.set(newValue, forKey: .bearerToken)
        }
    }
    
    private let userDefaults = UserDefaults.standard
}

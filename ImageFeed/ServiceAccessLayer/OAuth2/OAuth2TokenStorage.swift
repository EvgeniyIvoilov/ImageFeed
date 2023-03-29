import Foundation

private extension String {
    static let bearerToken = "bearerToken"
}

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    var token: String? {
        get {
            userDefaults.string(forKey: .bearerToken)
        }
        set {
            userDefaults.set(newValue, forKey: .bearerToken)
        }
    }
}

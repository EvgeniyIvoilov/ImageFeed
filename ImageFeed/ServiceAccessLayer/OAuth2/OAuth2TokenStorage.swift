import Foundation
import SwiftKeychainWrapper

private extension String {
    static let bearerToken = "bearerToken"
}

final class OAuth2TokenStorage {
    
    private let keychainStorage = KeychainWrapper.standard
        
    var token: String? {
        get {
            keychainStorage.string(forKey: .bearerToken)
        }
        set {
            guard let token = newValue else {
                keychainStorage.removeObject(forKey: .bearerToken)
                return
            }
            keychainStorage.set(token, forKey: .bearerToken)
        }
    }
}
